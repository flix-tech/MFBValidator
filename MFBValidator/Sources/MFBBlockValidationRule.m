//
//  MFBBlockValidationRule.m
//  Pods
//
//  Created by Mykola Tarbaiev on 07.07.16.
//
//

#import "MFBBlockValidationRule.h"

@implementation MFBBlockValidationRule {
    NSString *_field;
    BOOL (^_block)(id);
}

- (instancetype)initWithField:(NSString *)field block:(BOOL (^)(id))block
{
    NSCParameterAssert(field != nil);
    NSCParameterAssert(block != nil);

    self = [super init];
    if (self) {
        _field = [field copy];
        _block = block;
    }
    return self;
}


#pragma mark - MFBValidationRule Methods

- (BOOL)evaluateWithObject:(id)object
{
    return _block([object valueForKey:_field]);
}

@end
