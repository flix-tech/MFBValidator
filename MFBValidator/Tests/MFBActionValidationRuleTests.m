//
//  MFBActionValidationRuleTests.m
//  MFBValidator
//
//  Created by Mykola Tarbaiev on 04.07.16.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MFBValidator.h"

@interface MFBActionValidationRuleTestClass : NSObject
@property (nonatomic) NSString *fieldA1;
@property (nonatomic) NSString *fieldA2;
@end

@implementation MFBActionValidationRuleTestClass
@end


@interface MFBActionValidationRuleTarget : NSObject
@end

@implementation MFBActionValidationRuleTarget

- (BOOL)validateX:(id)x Y:(id)y
{
    return NO;
}

@end


@interface MFBActionValidationRuleTests : XCTestCase

@end

@implementation MFBActionValidationRuleTests {
    MFBActionValidationRule *_rule;

    NSArray *_fields;
    id _validatorTargetMock;
}

- (void)setUp 
{
    [super setUp];

    _fields = @[ NSStringFromSelector(@selector(fieldA1)),
                 NSStringFromSelector(@selector(fieldA2)) ];

    _validatorTargetMock = OCMPartialMock([MFBActionValidationRuleTarget new]);

    _rule = [[MFBActionValidationRule alloc] initWithFields:_fields
                                           validatingTarget:_validatorTargetMock
                                                     action:@selector(validateX:Y:)];
}


#pragma mark - Test Methods

- (void)test_evaluateWithObject_twoNonNilFieldsFails_returnsNO
{
    id objectMock = OCMPartialMock([MFBActionValidationRuleTestClass new]);

    id valueA1Stub = [NSObject new];
    OCMExpect([objectMock valueForKey:_fields[0]]).andReturn(valueA1Stub);

    id valueA2Stub = [NSObject new];
    OCMExpect([objectMock valueForKey:_fields[1]]).andReturn(valueA2Stub);

    OCMExpect([_validatorTargetMock validateX:valueA1Stub Y:valueA2Stub]).andReturn(NO);

    XCTAssertFalse([_rule evaluateWithObject:objectMock]);
}

- (void)test_evaluateWithObject_twoNonNilFieldsSucceeds_returnsYES
{
    id objectMock = OCMPartialMock([MFBActionValidationRuleTestClass new]);

    id valueA1Stub = [NSObject new];
    OCMExpect([objectMock valueForKey:_fields[0]]).andReturn(valueA1Stub);

    id valueA2Stub = [NSObject new];
    OCMExpect([objectMock valueForKey:_fields[1]]).andReturn(valueA2Stub);

    OCMExpect([_validatorTargetMock validateX:valueA1Stub Y:valueA2Stub]).andReturn(YES);

    XCTAssertTrue([_rule evaluateWithObject:objectMock]);
}

- (void)test_evaluateWithObject_twoNilFieldsFails_returnsNO
{
    id objectMock = OCMPartialMock([MFBActionValidationRuleTestClass new]);

    OCMExpect([objectMock valueForKey:_fields[0]]).andReturn(nil);

    OCMExpect([objectMock valueForKey:_fields[1]]).andReturn(nil);

    OCMExpect([_validatorTargetMock validateX:[OCMArg isNil] Y:[OCMArg isNil]]).andReturn(NO);

    XCTAssertFalse([_rule evaluateWithObject:objectMock]);
}

- (void)test_evaluateWithObject_twoNilFieldsSucceeds_returnsYES
{
    id objectMock = OCMPartialMock([MFBActionValidationRuleTestClass new]);

    OCMExpect([objectMock valueForKey:_fields[0]]).andReturn(nil);

    OCMExpect([objectMock valueForKey:_fields[1]]).andReturn(nil);

    OCMExpect([_validatorTargetMock validateX:[OCMArg isNil] Y:[OCMArg isNil]]).andReturn(YES);

    XCTAssertTrue([_rule evaluateWithObject:objectMock]);
}

@end
