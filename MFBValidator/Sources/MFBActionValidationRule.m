//
//  MFBActionValidationRule.m
//  Pods
//
//  Created by Mykola Tarbaiev on 07.07.16.
//
//

#import "MFBActionValidationRule.h"

@implementation MFBActionValidationRule {
    id _target;
    SEL _action;
    NSArray<NSString *> *_fields;

    NSMethodSignature *_signature;
}

- (instancetype)initWithFields:(NSArray<NSString *> *)fields validatingTarget:(id)target action:(SEL)action
{
    NSCParameterAssert(fields != nil);
    NSCParameterAssert(target != nil);
    NSCParameterAssert(action != nil);

    self = [super init];
    if (self) {
        _target = target;
        _action = action;
        _fields = [fields copy];

        _signature = [_target methodSignatureForSelector:_action];

        NSCAssert(_signature.numberOfArguments == fields.count + 2,
                  @"Inappropriate number of arguments (%d), expected (%d) in validation action '%@' for fields %@",
                  (int) _signature.numberOfArguments - 2, (int) fields.count, NSStringFromSelector(_action), _fields);
    }
    return self;
}


#pragma mark - MFBValidationRule Methods

- (BOOL)evaluateWithObject:(id)object
{
    NSMutableArray *values = [NSMutableArray new];

    for (NSString *field in _fields) {
        [values addObject:[object valueForKey:field] ?: [NSNull null]];
    }

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:_signature];
    invocation.selector = _action;

    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != [NSNull null]) {
            [invocation setArgument:&obj atIndex:idx + 2];
        }
    }];

    [invocation invokeWithTarget:_target];

    BOOL result;
    [invocation getReturnValue:&result];
    
    return result;
}

@end
