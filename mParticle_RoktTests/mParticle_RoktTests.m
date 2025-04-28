#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Rokt_Widget/Rokt_Widget-Swift.h>
#import "MPKitRokt.h"

@interface MPKitRokt ()

- (MPKitExecStatus *)executeWithViewName:(NSString * _Nullable)viewName
                              attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes
                              placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements
                               callbacks:(MPRoktEventCallback * _Nullable)callbacks
                            filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser;

- (NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable) confirmPlacements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements;

- (NSDictionary<NSString *, NSString *> *) filteredUserAttributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes kitConfiguration:(MPKitConfiguration *)kitConfiguration;

- (void)addIdentityAttributes:(NSMutableDictionary<NSString *, NSString *> * _Nullable)attributes filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser;
    
@end

@interface mParticle_RoktTests : XCTestCase

@property (nonatomic, strong) MPKitRokt *kitInstance;
@property (nonatomic, strong) NSDictionary *configuration;

@end

@implementation mParticle_RoktTests

- (void)setUp {
    [super setUp];
    self.kitInstance = [[MPKitRokt alloc] init];
    self.configuration = @{@"accountId": @"test_account_id"};
}

- (void)tearDown {
    self.kitInstance = nil;
    self.configuration = nil;
    [super tearDown];
}

- (void)testKitCode {
    XCTAssertEqualObjects([MPKitRokt kitCode], @181);
}

- (void)testStarted {
    XCTAssertFalse(self.kitInstance.started);
    
    [self.kitInstance didFinishLaunchingWithConfiguration:self.configuration];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertTrue(self.kitInstance.started);
    });
}

- (void)testDidFinishLaunchingWithConfiguration_Success {
    MPKitExecStatus *status = [self.kitInstance didFinishLaunchingWithConfiguration:self.configuration];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
}

- (void)testDidFinishLaunchingWithConfiguration_MissingAccountId {
    MPKitExecStatus *status = [self.kitInstance didFinishLaunchingWithConfiguration:@{}];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeRequirementsNotMet);
}

- (void)testConfirmPlacements_ValidPlacements {
    RoktEmbeddedView *view = [[RoktEmbeddedView alloc] init];
    NSDictionary *placements = @{@"placement1": view};
    
    NSDictionary *result = [self.kitInstance confirmPlacements:placements];
    
    XCTAssertEqual(result.count, 1);
    XCTAssertEqualObjects(result[@"placement1"], view);
}

- (void)testConfirmPlacements_InvalidPlacements {
    NSDictionary *placements = @{@"placement1": @"invalid"};
    
    NSDictionary *result = [self.kitInstance confirmPlacements:placements];
    
    XCTAssertEqual(result.count, 0);
}

- (void)testSetUserIdentity_Email {
    MPKitExecStatus *status = [self.kitInstance setUserIdentity:@"test@example.com" identityType:MPUserIdentityEmail];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
}

- (void)testSetUserIdentity_CustomerId {
    MPKitExecStatus *status = [self.kitInstance setUserIdentity:@"12345" identityType:MPUserIdentityCustomerId];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
}

- (void)testSetUserIdentity_UnsupportedType {
    MPKitExecStatus *status = [self.kitInstance setUserIdentity:@"test" identityType:MPUserIdentityFacebook];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeUnavailable);
}

- (void)testLogEvent {
    MPEvent *event = [[MPEvent alloc] initWithName:@"Test Event" type:MPEventTypeOther];
    
    MPKitExecStatus *status = [self.kitInstance logEvent:event];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
}

- (void)testExecuteWithViewName {
    id mockRoktSDK = OCMClassMock([Rokt class]);

    RoktEmbeddedView *view = [[RoktEmbeddedView alloc] init];
    NSString *viewName = @"TestView";
    NSDictionary *placements = @{@"placement1": view};
    NSDictionary *attributes = @{@"attr1": @"value1", @"sandbox": @"true"};
    FilteredMParticleUser *user = [[FilteredMParticleUser alloc] init];
    
    // Expected attributes in final call
    NSDictionary *expectedAttributes = @{
        @"sandbox": @"true"
    };

    // Expect Rokt execute call with correct parameters
    OCMExpect([mockRoktSDK executeWithViewName:@"TestView"
                                   attributes:expectedAttributes
                                   placements:placements
                                       onLoad:nil
                                     onUnLoad:nil
                 onShouldShowLoadingIndicator:nil
                 onShouldHideLoadingIndicator:nil
                         onEmbeddedSizeChange:nil]);
    
    MPKitExecStatus *status = [self.kitInstance executeWithViewName:viewName
                                                         attributes:attributes
                                                         placements:placements
                                                          callbacks:nil
                                                       filteredUser:user];

    // Verify
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
    OCMVerifyAll(mockRoktSDK);
}

- (void)testAddIdentityAttributes {
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{@(MPIdentityEmail): @"testEmail@gmail.com",
                                                             @(MPIdentityOther): @"testUserName",
                                                             @(MPIdentityMobileNumber): @"1(234)-567-8910"};
    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockfilteredUser = OCMPartialMock(filteredUser);
    [[[mockfilteredUser stub] andReturn:testIdentities] userIdentities];
    
    MPKitRokt *kit = [[MPKitRokt alloc] init];
    [kit addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    XCTAssertEqualObjects(passedAttributes[@"email"], @"testEmail@gmail.com");
    XCTAssertEqualObjects(passedAttributes[@"other"], @"testUserName");
    XCTAssertEqualObjects(passedAttributes[@"mobile_number"], @"1(234)-567-8910");
}

@end 
