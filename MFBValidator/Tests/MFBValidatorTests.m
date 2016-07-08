//
//  MFBValidatorTests.m
//  MFBValidator
//
//  Created by Mykola Tarbaiev on 28.06.16.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MFBValidator.h"

@interface MFBValidatorTestClassA : NSObject
@property (nonatomic) NSString *fieldA1;
@property (nonatomic) NSString *fieldA2;
@end

@implementation MFBValidatorTestClassA
@end

@interface MFBValidatorTestClassB : MFBValidatorTestClassA
@property (nonatomic) NSString *fieldB1;
@end

@implementation MFBValidatorTestClassB
@end

@interface MFBValidatorTestClassA1 : NSObject
@property (nonatomic) NSString *fieldA1;
@end

@implementation MFBValidatorTestClassA1
@end


@interface MFBValidatorTests : XCTestCase

@end

@implementation MFBValidatorTests {
    MFBValidator<NSString *> *_validator;

    NSArray *_validatorMocks;
}

- (void)setUp 
{
    [super setUp];

    _validator = [MFBValidator new];
}


#pragma mark - Test Methods

- (void)test_validateObject_RootClassWithRootClassRuleFailed
{
    NSString *const FailureReason = @"Failure";

    id ruleMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:FailureReason];

    id objectStub = [MFBValidatorTestClassA new];

    OCMExpect([ruleMock evaluateWithObject:objectStub]).andReturn(NO);

    NSString *result = [_validator validateObject:objectStub];

    OCMVerifyAll(ruleMock);

    XCTAssertEqualObjects(result, FailureReason);
}

- (void)test_validateObject_SubclassWithRootClassRuleFailed
{
    NSString *const FailureReason = @"Failure";

    id ruleMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:FailureReason];

    id objectStub = [MFBValidatorTestClassB new];

    OCMExpect([ruleMock evaluateWithObject:objectStub]).andReturn(NO);

    NSString *result = [_validator validateObject:objectStub];

    OCMVerifyAll(ruleMock);

    XCTAssertEqualObjects(result, FailureReason);
}

- (void)test_validateObject_RootClassWithSubclassRule_NoValidationPerformed
{
    id ruleMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleMock
                         forClass:[MFBValidatorTestClassB class]
                          failure:@"Failure"];

    id objectStub = [MFBValidatorTestClassA new];

    OCMReject([ruleMock evaluateWithObject:objectStub]);

    NSString *result = [_validator validateObject:objectStub];

    XCTAssertNil(result);
}

- (void)test_validateObject_SubclassWithRootClassRuleFitAndSubclassRuleFailed_ReturnsSublclassRuleFailure
{
    id ruleAMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleAMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:@"FailureA"];

    NSString *const FailureReasonB = @"FailureB";

    id ruleBMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleBMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:FailureReasonB];

    id objectStub = [MFBValidatorTestClassB new];

    OCMExpect([ruleAMock evaluateWithObject:objectStub]).andReturn(YES);
    OCMExpect([ruleBMock evaluateWithObject:objectStub]).andReturn(NO);

    NSString *result = [_validator validateObject:objectStub];

    OCMVerifyAll(ruleAMock);
    OCMVerifyAll(ruleBMock);

    XCTAssertEqualObjects(result, FailureReasonB);
}

- (void)test_validateObject_SubclassWithRootClassRuleFailedAndSubclassRule_ReturnsRootClassRuleFailure
{
    NSString *const FailureReasonA = @"FailureA";

    id ruleAMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleAMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:FailureReasonA];

    id ruleBMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleBMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:@"FailureB"];

    id objectStub = [MFBValidatorTestClassB new];

    OCMExpect([ruleAMock evaluateWithObject:objectStub]).andReturn(NO);
    OCMReject([ruleBMock evaluateWithObject:objectStub]);

    NSString *result = [_validator validateObject:objectStub];

    OCMVerifyAll(ruleAMock);

    XCTAssertEqualObjects(result, FailureReasonA);
}

- (void)test_validateObject_SubclassWithSubclassRuleFailedAndRootClassRuleFailed_ReturnsSubclassRuleFailure
{
    NSString *const FailureReasonB = @"FailureB";

    id ruleBMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleBMock
                         forClass:[MFBValidatorTestClassB class]
                          failure:FailureReasonB];

    id ruleAMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleAMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:@"FailureA"];

    id objectStub = [MFBValidatorTestClassB new];

    OCMReject([ruleAMock evaluateWithObject:objectStub]);
    OCMExpect([ruleBMock evaluateWithObject:objectStub]).andReturn(NO);

    NSString *result = [_validator validateObject:objectStub];

    OCMVerifyAll(ruleBMock);

    XCTAssertEqualObjects(result, FailureReasonB);
}

- (void)test_validateObject_TwoRulesForSameClassWithSameFailure_LastAddedRuleUsed
{
    NSString *const FailureReason = @"Failure";

    id rule1Mock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:rule1Mock
                         forClass:[MFBValidatorTestClassA class]
                          failure:FailureReason];

    id rule2Mock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:rule2Mock
                         forClass:[MFBValidatorTestClassA class]
                          failure:FailureReason];

    id objectStub = [MFBValidatorTestClassA new];

    OCMReject([rule1Mock evaluateWithObject:objectStub]);
    OCMExpect([rule2Mock evaluateWithObject:objectStub]).andReturn(NO);

    NSString *result = [_validator validateObject:objectStub];

    OCMVerifyAll(rule2Mock);

    XCTAssertEqualObjects(result, FailureReason);
}

- (void)test_validateObject_SubclassWithTwoRulesForRootClassAndSubclassWithSameFailure_SubclassRuleUsedDespiteTheOrder
{
    NSString *const FailureReason = @"Failure";

    id ruleBMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleBMock
                         forClass:[MFBValidatorTestClassB class]
                          failure:FailureReason];

    id ruleAMock = OCMProtocolMock(@protocol(MFBValidationRule));

    [_validator addValidationRule:ruleAMock
                         forClass:[MFBValidatorTestClassA class]
                          failure:FailureReason];

    id objectStub = [MFBValidatorTestClassB new];

    OCMReject([ruleAMock evaluateWithObject:objectStub]);
    OCMExpect([ruleBMock evaluateWithObject:objectStub]).andReturn(NO);

    NSString *result = [_validator validateObject:objectStub];

    OCMVerifyAll(ruleBMock);

    XCTAssertEqualObjects(result, FailureReason);
}

- (void)test_addValidationRule_forMultipleClasses
{
    id validator = OCMPartialMock(_validator);

    id ruleStub = [NSObject new];

    NSString *const Failure = @"Failure";

    NSArray *classes = @[ [NSObject class], [NSString class] ];

    for (Class aClass in classes) {
        OCMExpect([validator addValidationRule:ruleStub forClass:aClass failure:Failure]);
    }

    [validator addValidationRule:ruleStub
                      forClasses:classes
                         failure:Failure];

    OCMVerifyAll(validator);
}

- (void)test_validateObject_SameRuleForUnrelatedClasses_RuleEvaluatedWithInstancesOfBothClasses
{
    NSString *const FailureReason = @"Failure";

    id ruleMock = OCMProtocolMock(@protocol(MFBValidationRule));

    NSArray *classes = @[ [MFBValidatorTestClassA class], [MFBValidatorTestClassA1 class] ];

    [_validator addValidationRule:ruleMock
                       forClasses:classes
                          failure:FailureReason];

    for (Class aClass in classes) {

        id objectStub = [aClass new];

        OCMExpect([ruleMock evaluateWithObject:objectStub]).andReturn(NO);

        NSString *result = [_validator validateObject:objectStub];

        OCMVerifyAll(ruleMock);
        XCTAssertEqualObjects(result, FailureReason);
    }
}

@end
