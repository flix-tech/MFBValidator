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


@interface MFBActionValidationRule : NSObject <MFBValidationRule>

- (instancetype)init NS_UNAVAILABLE;

/** 
 * @param fields A list of fields to be passed as arguments to the @p action method.
 * @param target An object that is a recipient of @p action messages sent by the receiver.
 * @param action A selector identifying a method of a @p target that performs fields validation.
 * It should be of the form @a-(BOOL)validateValue1:value2:...valueN: 
 * with number of arguments equal to number of fields
 * and return @p YES if validation succeeds or @p NO otherwise.
 */
- (instancetype)initWithFields:(NSArray<NSString *> *)fields
              validatingTarget:(id)target
                        action:(SEL)action NS_DESIGNATED_INITIALIZER;

@end


@interface MFBValidator<FailureType> : NSObject

- (void)addValidationRule:(id<MFBValidationRule>)validationRule
                 forClass:(Class)aClass
                  failure:(FailureType <NSCopying>)failure;

- (nullable FailureType)validateObject:(id)object;

@end

NS_ASSUME_NONNULL_END
