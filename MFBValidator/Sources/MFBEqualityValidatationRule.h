//
//  MFBEqualityValidatationRule.h
//  Pods
//
//  Created by Mykola Tarbaiev on 08.07.16.
//
//

#import <MFBValidator/MFBValidator.h>

@interface MFBEqualityValidatationRule : MFBValidationRule

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithField:(NSString *)field
                        value:(id)value;

@end
