//
//  MFBValidator.h
//  MFBValidator
//
//  Created by Mykola Tarbaiev on 28.06.16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MFBValidationRule <NSObject>
- (BOOL)evaluateWithObject:(id)object;
@end

@interface NSPredicate (MFBValidationRule) <MFBValidationRule>
@end

@interface MFBValidationRule : NSObject <MFBValidationRule>

/**
 * @param field A field which value is passed as an argument to the @p block.
 * @param block The block is applied to the field's value to be evaluated.
 */
+ (instancetype)ruleForField:(NSString *)field
                       block:(BOOL(^)(id _Nullable value))block;

/**
 * @param field A field which value is evaluated.
 * @param value The value to be compared with the field's value.
 */
+ (instancetype)ruleForField:(NSString *)field isEqualTo:(id _Nullable)value;

/**
 * @param field A field which value is evaluated.
 */
+ (instancetype)isNotNilRuleForField:(NSString *)field;

/**
 * @param fields A list of fields which values are passed as arguments to the @p action method.
 * @param target An object that is a recipient of @p action messages sent by the receiver.
 * @param action A selector identifying a method of a @p target that performs fields validation.
 * It should be of the form @a-(BOOL)validateValue1:value2:...valueN:
 * with number of arguments equal to number of fields
 * and return @p YES if validation succeeds or @p NO otherwise.
 */
+ (instancetype)ruleForFields:(NSArray<NSString *> *)fields
             validatingTarget:(id)target
                       action:(SEL)action;

@end


@interface MFBValidator<FailureType> : NSObject

- (void)addValidationRule:(id<MFBValidationRule>)validationRule
                 forClass:(Class)aClass
                  failure:(FailureType <NSCopying>)failure;

- (nullable FailureType)validateObject:(id)object;

@end

NS_ASSUME_NONNULL_END
