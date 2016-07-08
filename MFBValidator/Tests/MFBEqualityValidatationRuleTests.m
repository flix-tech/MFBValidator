//
//  MFBEqualityValidatationRuleTests.m
//  Pods
//
//  Created by Mykola Tarbaiev on 08.07.16.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <MFBValidator/MFBValidator.h>

@interface MFBEqualityValidatationRuleTests : XCTestCase

@end

@implementation MFBEqualityValidatationRuleTests

#pragma mark - Test Methods

- (void)test_evaluateWithObject_equalValue_returnsYES
{
    NSString *const Field = @"fieldA";

    id<MFBValidationRule> rule = [MFBValidationRule ruleForField:Field isEqualTo:@YES];

    id objectMock = OCMClassMock([NSObject class]);
    OCMExpect([objectMock valueForKey:Field]).andReturn(@YES);

    XCTAssertTrue([rule evaluateWithObject:objectMock]);

    OCMVerifyAll(objectMock);
}

- (void)test_evaluateWithObject_nonEqualValue_returnsNO
{
    NSString *const Field = @"fieldA";

    id<MFBValidationRule> rule = [MFBValidationRule ruleForField:Field isEqualTo:@YES];

    id objectMock = OCMClassMock([NSObject class]);
    OCMExpect([objectMock valueForKey:Field]).andReturn(@NO);

    XCTAssertFalse([rule evaluateWithObject:objectMock]);

    OCMVerifyAll(objectMock);
}

- (void)test_evaluateWithObject_nilValues_returnsYES
{
    NSString *const Field = @"fieldA";

    id<MFBValidationRule> rule = [MFBValidationRule ruleForField:Field isEqualTo:nil];

    id objectMock = OCMClassMock([NSObject class]);
    OCMExpect([objectMock valueForKey:Field]).andReturn(nil);

    XCTAssertTrue([rule evaluateWithObject:objectMock]);

    OCMVerifyAll(objectMock);
}

@end
