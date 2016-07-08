//
//  MFBEqualityValidatationRule.m
//  Pods
//
//  Created by Mykola Tarbaiev on 08.07.16.
//
//

#import "MFBEqualityValidatationRule.h"

@implementation MFBEqualityValidatationRule {
    NSString *_field;
    id _value;
}

- (instancetype)initWithField:(NSString *)field value:(id)value
{
    self = [super init];
    if (self) {
        _field = [field copy];
        _value = value;
    }
    return self;
}


#pragma mark - MFBValidationRule Methods

- (BOOL)evaluateWithObject:(id)object
{
    id fieldValue = [object valueForKey:_field];
    return fieldValue == _value || [fieldValue isEqual:_value];
}

@end
