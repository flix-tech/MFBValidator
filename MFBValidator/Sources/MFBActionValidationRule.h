//
//  MFBActionValidationRule.h
//  Pods
//
//  Created by Mykola Tarbaiev on 07.07.16.
//
//

#import <MFBValidator/MFBValidator.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFBActionValidationRule : MFBValidationRule

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithFields:(NSArray<NSString *> *)fields
              validatingTarget:(id)target
                        action:(SEL)action NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
