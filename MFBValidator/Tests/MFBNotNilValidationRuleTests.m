//
//  MFBNotNilValidationRuleTests.m
//  Pods
//
//  Created by Mykola Tarbaiev on 08.07.16.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <MFBValidator/MFBValidator.h>

@interface MFBNotNilValidationRuleTests : XCTestCase

@end

@implementation MFBNotNilValidationRuleTests

#pragma mark - Test Methods

- (void)test_nilValue_returnsNO
{
    NSString *const Field = @"fieldA";

    id<MFBValidationRule> rule = [MFBValidationRule isNotNilRuleForField:Field];

    id objectMock = OCMClassMock([NSObject class]);
    OCMExpect([objectMock valueForKey:Field]).andReturn(nil);

    XCTAssertFalse([rule evaluateWithObject:objectMock]);

    OCMVerifyAll(objectMock);
}

- (void)test_nonNilValue_returnsYES
{
    NSString *const Field = @"fieldA";

    id<MFBValidationRule> rule = [MFBValidationRule isNotNilRuleForField:Field];

    id objectMock = OCMClassMock([NSObject class]);
    OCMExpect([objectMock valueForKey:Field]).andReturn(@"Some");

    XCTAssertTrue([rule evaluateWithObject:objectMock]);

    OCMVerifyAll(objectMock);
}

@end
