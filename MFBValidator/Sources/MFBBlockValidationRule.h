//
//  MFBBlockValidationRule.h
//  Pods
//
//  Created by Mykola Tarbaiev on 07.07.16.
//
//

#import <MFBValidator/MFBValidator.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFBBlockValidationRule : MFBValidationRule

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithField:(NSString *)field
                        block:(BOOL(^)(id _Nullable value))block;

@end

NS_ASSUME_NONNULL_END
