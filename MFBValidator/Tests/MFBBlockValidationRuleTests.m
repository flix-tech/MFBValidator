//
//  MFBBlockValidationRuleTests.m
//  MFBValidator
//
//  Created by Mykola Tarbaiev on 07.07.16.
//  Copyright © 2016 Flix.TECH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <MFBValidator/MFBValidator.h>

@interface MFBBlockValidationRuleTests : XCTestCase

@end

@implementation MFBBlockValidationRuleTests

#pragma mark - Test Methods

- (void)test_blockInvokedWithFieldValue_blockResultReturned
{
    NSString *const Field = @"fieldA";

    for (NSNumber *validationResult in @[ @YES, @NO ]) {

        __block BOOL BlockInvoked = NO;

        XCTAssertFalse(BlockInvoked);

        id<MFBValidationRule> rule = [MFBValidationRule ruleForField:Field
                                                               block:^BOOL(id  _Nullable value) {
                                                                   BlockInvoked = YES;
                                                                   return validationResult.boolValue;
                                                               }];


        id objectMock = OCMPartialMock([NSObject new]);

        id valueStub = [NSObject new];

        OCMExpect([objectMock valueForKey:Field]).andReturn(valueStub);

        XCTAssertEqual([rule evaluateWithObject:objectMock], validationResult.boolValue);
        
        OCMVerifyAll(objectMock);
        XCTAssertTrue(BlockInvoked);
    }
}

@end
