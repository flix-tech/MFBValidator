//
//  MFBValidator.m
//  MFBValidator
//
//  Created by Mykola Tarbaiev on 28.06.16.
//
//

#import "MFBValidator.h"
#import "MFBBlockValidationRule.h"
#import "MFBActionValidationRule.h"


@interface MFBOrderedSetClassTable<ObjectType> : NSObject
- (void)addObject:(ObjectType)object forClass:(Class)aClass;
- (NSOrderedSet<ObjectType> *)objectsForClass:(Class)aClass;
- (NSOrderedSet<ObjectType> *)objectForKeyedSubscript:(Class)aClass;
@end

@implementation MFBOrderedSetClassTable {
    NSMutableDictionary<Class, NSMutableIndexSet *> *_indexSets;
    NSMutableOrderedSet *_objects;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _indexSets = [NSMutableDictionary new];
        _objects = [NSMutableOrderedSet new];
    }
    return self;
}

- (void)addObject:(id)object forClass:(Class)aClass
{
    if ([_objects containsObject:object]) {
        return;
    }

    NSMutableIndexSet *indexes = _indexSets[aClass];

    if (!indexes) {
        indexes = [NSMutableIndexSet new];
        _indexSets[(id) aClass] = indexes;
    }

    [indexes addIndex:_objects.count];
    [_objects addObject:object];
}

- (NSIndexSet *)indexesForClass:(Class)aClass
{
    NSIndexSet *result = _indexSets[aClass];

    Class superclass = [aClass superclass];

    if (superclass) {

        NSMutableIndexSet *superclassIndexes = [[self indexesForClass:superclass] mutableCopy];

        if (superclassIndexes) {
            [superclassIndexes addIndexes:result];
            result = superclassIndexes;
        }
    }
    
    return result;
}

- (NSOrderedSet *)objectsForClass:(Class)aClass
{
    NSIndexSet *indexes = [self indexesForClass:aClass];

    if (!indexes) {
        return nil;
    }

    return [NSOrderedSet orderedSetWithArray:[_objects objectsAtIndexes:indexes]];
}

- (NSOrderedSet *)objectForKeyedSubscript:(Class)aClass
{
    return [self objectsForClass:aClass];
}

@end


@interface MFBDictionaryClassTable<KeyType, ObjectType> : NSObject
- (void)setObject:(ObjectType)object forKey:(KeyType<NSCopying>)key forClass:(Class)aClass;
- (ObjectType)objectForKey:(KeyType)key class:(Class)aClass;
- (NSDictionary *)objectForKeyedSubscript:(Class)aClass;
@end

@implementation MFBDictionaryClassTable {
    NSMutableDictionary<Class, NSMutableDictionary *> *_dictionaries;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionaries = [NSMutableDictionary new];
    }
    return self;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key forClass:(Class)aClass
{
    NSMutableDictionary *objects = _dictionaries[(id) aClass];

    if (!objects) {
        objects = [NSMutableDictionary new];
        _dictionaries[(id) aClass] = objects;
    }

    objects[key] = object;
}

- (NSDictionary *)objectsForClass:(Class)aClass
{
    NSMutableDictionary *result = _dictionaries[aClass];

    Class superclass = [aClass superclass];

    if (superclass) {

        NSMutableDictionary *superclassObjects = [[self objectsForClass:superclass] mutableCopy];

        if (superclassObjects) {
            [superclassObjects addEntriesFromDictionary:result];
            result = superclassObjects;
        }
    }

    return result;
}

- (id)objectForKey:(id)key class:(Class)aClass
{
    return [self objectsForClass:aClass][key];
}

- (NSDictionary *)objectForKeyedSubscript:(Class)aClass
{
    return [self objectsForClass:aClass];
}

@end


@implementation MFBValidationRule

+ (instancetype)ruleForField:(NSString *)field block:(BOOL (^)(id _Nullable))block
{
    return [[MFBBlockValidationRule alloc] initWithField:field block:block];
}

+ (instancetype)ruleForField:(NSString *)field isEqualTo:(id)requiredValue
{
    return [[MFBBlockValidationRule alloc] initWithField:field block:^BOOL(id  _Nullable value) {
        return value == requiredValue || [value isEqual:requiredValue];
    }];
}

+ (instancetype)isNotNilRuleForField:(NSString *)field
{
    return [[MFBBlockValidationRule alloc] initWithField:field block:^BOOL(id  _Nullable value) {
        return value != nil;
    }];
}

+ (instancetype)ruleForFields:(NSArray<NSString *> *)fields validatingTarget:(id)target action:(SEL)action
{
    return [[MFBActionValidationRule alloc] initWithFields:fields validatingTarget:target action:action];
}


#pragma mark - MFBValidationRule Methods

- (BOOL)evaluateWithObject:(id)object
{
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

@end


@implementation MFBValidator {
    MFBOrderedSetClassTable<NSString *> *_failures;
    MFBDictionaryClassTable<NSArray<id> *, id<MFBValidationRule>> *_validationRules;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _failures = [MFBOrderedSetClassTable new];
        _validationRules = [MFBDictionaryClassTable new];
    }
    return self;
}

- (void)addValidationRule:(id)validationRule forClass:(Class)aClass failure:(id)failure
{
    [_failures addObject:failure forClass:aClass];

    [_validationRules setObject:validationRule forKey:failure forClass:aClass];
}

- (id)validateObject:(id)object
{
    Class objectClass = [object class];

    NSOrderedSet *failures = _failures[objectClass];

    for (NSArray *failure in failures) {

        id<MFBValidationRule> validationRule = _validationRules[objectClass][failure];

        if (![validationRule evaluateWithObject:object]) {
            return failure;
        }
    }

    return nil;
}

@end

@implementation MFBValidator (MultipleClasses)

- (void)addValidationRule:(id<MFBValidationRule>)validationRule
               forClasses:(NSArray<Class> *)classes
                  failure:(id<NSCopying>)failure
{
    for (Class aClass in classes) {
        [self addValidationRule:validationRule forClass:aClass failure:failure];
    }
}

@end
