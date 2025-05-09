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
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{@(MPIdentityCustomerId): @"testCustomerID",
                                                             @(MPIdentityEmail): @"testEmail@gmail.com",
                                                             @(MPIdentityFacebook): @"testFacebook",
                                                             @(MPIdentityFacebookCustomAudienceId): @"testCustomAudienceID",
                                                             @(MPIdentityGoogle): @"testGoogle",
                                                             @(MPIdentityMicrosoft): @"testMicrosoft",
                                                             @(MPIdentityOther): @"testOther",
                                                             @(MPIdentityTwitter): @"testTwitter",
                                                             @(MPIdentityYahoo): @"testYahoo",
                                                             @(MPIdentityOther2): @"testOther2",
                                                             @(MPIdentityOther3): @"testOther3",
                                                             @(MPIdentityOther4): @"testOther4",
                                                             @(MPIdentityOther5): @"testOther5",
                                                             @(MPIdentityOther6): @"testOther6",
                                                             @(MPIdentityOther7): @"testOther7",
                                                             @(MPIdentityOther8): @"testOther8",
                                                             @(MPIdentityOther9): @"testOther9",
                                                             @(MPIdentityOther10): @"testOther10",
                                                             @(MPIdentityMobileNumber): @"1(234)-567-8910",
                                                             @(MPIdentityPhoneNumber2): @"1(234)-567-2222",
                                                             @(MPIdentityPhoneNumber3): @"1(234)-567-3333",
                                                             @(MPIdentityIOSAdvertiserId): @"testAdvertID",
                                                             @(MPIdentityIOSVendorId): @"testVendorID",
                                                             @(MPIdentityPushToken): @"testPushToken",
                                                             @(MPIdentityDeviceApplicationStamp): @"Test DAS"};

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockfilteredUser = OCMPartialMock(filteredUser);
    [[[mockfilteredUser stub] andReturn:testIdentities] userIdentities];
    
    MPKitRokt *kit = [[MPKitRokt alloc] init];
    [kit addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    XCTAssertEqualObjects(passedAttributes[@"customerid"], @"testCustomerID");
    XCTAssertEqualObjects(passedAttributes[@"email"], @"testEmail@gmail.com");
    XCTAssertEqualObjects(passedAttributes[@"facebook"], @"testFacebook");
    XCTAssertEqualObjects(passedAttributes[@"facebookcustomaudienceid"], @"testCustomAudienceID");
    XCTAssertEqualObjects(passedAttributes[@"google"], @"testGoogle");
    XCTAssertEqualObjects(passedAttributes[@"microsoft"], @"testMicrosoft");
    XCTAssertEqualObjects(passedAttributes[@"other"], @"testOther");
    XCTAssertEqualObjects(passedAttributes[@"twitter"], @"testTwitter");
    XCTAssertEqualObjects(passedAttributes[@"yahoo"], @"testYahoo");
    XCTAssertEqualObjects(passedAttributes[@"other2"], @"testOther2");
    XCTAssertEqualObjects(passedAttributes[@"other3"], @"testOther3");
    XCTAssertEqualObjects(passedAttributes[@"other4"], @"testOther4");
    XCTAssertEqualObjects(passedAttributes[@"other5"], @"testOther5");
    XCTAssertEqualObjects(passedAttributes[@"other6"], @"testOther6");
    XCTAssertEqualObjects(passedAttributes[@"other7"], @"testOther7");
    XCTAssertEqualObjects(passedAttributes[@"other8"], @"testOther8");
    XCTAssertEqualObjects(passedAttributes[@"other9"], @"testOther9");
    XCTAssertEqualObjects(passedAttributes[@"other10"], @"testOther10");
    XCTAssertEqualObjects(passedAttributes[@"mobile_number"], @"1(234)-567-8910");
    XCTAssertEqualObjects(passedAttributes[@"phone_number_2"], @"1(234)-567-2222");
    XCTAssertEqualObjects(passedAttributes[@"phone_number_3"], @"1(234)-567-3333");
    XCTAssertEqualObjects(passedAttributes[@"ios_idfa"], @"testAdvertID");
    XCTAssertEqualObjects(passedAttributes[@"ios_idfv"], @"testVendorID");
    XCTAssertEqualObjects(passedAttributes[@"push_token"], @"testPushToken");
    XCTAssertEqualObjects(passedAttributes[@"device_application_stamp"], @"Test DAS");
}

- (void)testAddIdentityAttributesWithExistingAttributes {
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    [passedAttributes setObject:@"bar" forKey:@"foo"];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{@(MPIdentityCustomerId): @"testCustomerID",
                                                             @(MPIdentityEmail): @"testEmail@gmail.com",
                                                             @(MPIdentityFacebook): @"testFacebook",
                                                             @(MPIdentityFacebookCustomAudienceId): @"testCustomAudienceID",
                                                             @(MPIdentityGoogle): @"testGoogle",
                                                             @(MPIdentityMicrosoft): @"testMicrosoft",
                                                             @(MPIdentityOther): @"testOther",
                                                             @(MPIdentityTwitter): @"testTwitter",
                                                             @(MPIdentityYahoo): @"testYahoo",
                                                             @(MPIdentityOther2): @"testOther2",
                                                             @(MPIdentityOther3): @"testOther3",
                                                             @(MPIdentityOther4): @"testOther4",
                                                             @(MPIdentityOther5): @"testOther5",
                                                             @(MPIdentityOther6): @"testOther6",
                                                             @(MPIdentityOther7): @"testOther7",
                                                             @(MPIdentityOther8): @"testOther8",
                                                             @(MPIdentityOther9): @"testOther9",
                                                             @(MPIdentityOther10): @"testOther10",
                                                             @(MPIdentityMobileNumber): @"1(234)-567-8910",
                                                             @(MPIdentityPhoneNumber2): @"1(234)-567-2222",
                                                             @(MPIdentityPhoneNumber3): @"1(234)-567-3333",
                                                             @(MPIdentityIOSAdvertiserId): @"testAdvertID",
                                                             @(MPIdentityIOSVendorId): @"testVendorID",
                                                             @(MPIdentityPushToken): @"testPushToken",
                                                             @(MPIdentityDeviceApplicationStamp): @"Test DAS"};

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockfilteredUser = OCMPartialMock(filteredUser);
    [[[mockfilteredUser stub] andReturn:testIdentities] userIdentities];
    
    MPKitRokt *kit = [[MPKitRokt alloc] init];
    [kit addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    XCTAssertEqualObjects(passedAttributes[@"foo"], @"bar");
    XCTAssertEqualObjects(passedAttributes[@"customerid"], @"testCustomerID");
    XCTAssertEqualObjects(passedAttributes[@"email"], @"testEmail@gmail.com");
    XCTAssertEqualObjects(passedAttributes[@"facebook"], @"testFacebook");
    XCTAssertEqualObjects(passedAttributes[@"facebookcustomaudienceid"], @"testCustomAudienceID");
    XCTAssertEqualObjects(passedAttributes[@"google"], @"testGoogle");
    XCTAssertEqualObjects(passedAttributes[@"microsoft"], @"testMicrosoft");
    XCTAssertEqualObjects(passedAttributes[@"other"], @"testOther");
    XCTAssertEqualObjects(passedAttributes[@"twitter"], @"testTwitter");
    XCTAssertEqualObjects(passedAttributes[@"yahoo"], @"testYahoo");
    XCTAssertEqualObjects(passedAttributes[@"other2"], @"testOther2");
    XCTAssertEqualObjects(passedAttributes[@"other3"], @"testOther3");
    XCTAssertEqualObjects(passedAttributes[@"other4"], @"testOther4");
    XCTAssertEqualObjects(passedAttributes[@"other5"], @"testOther5");
    XCTAssertEqualObjects(passedAttributes[@"other6"], @"testOther6");
    XCTAssertEqualObjects(passedAttributes[@"other7"], @"testOther7");
    XCTAssertEqualObjects(passedAttributes[@"other8"], @"testOther8");
    XCTAssertEqualObjects(passedAttributes[@"other9"], @"testOther9");
    XCTAssertEqualObjects(passedAttributes[@"other10"], @"testOther10");
    XCTAssertEqualObjects(passedAttributes[@"mobile_number"], @"1(234)-567-8910");
    XCTAssertEqualObjects(passedAttributes[@"phone_number_2"], @"1(234)-567-2222");
    XCTAssertEqualObjects(passedAttributes[@"phone_number_3"], @"1(234)-567-3333");
    XCTAssertEqualObjects(passedAttributes[@"ios_idfa"], @"testAdvertID");
    XCTAssertEqualObjects(passedAttributes[@"ios_idfv"], @"testVendorID");
    XCTAssertEqualObjects(passedAttributes[@"push_token"], @"testPushToken");
    XCTAssertEqualObjects(passedAttributes[@"device_application_stamp"], @"Test DAS");
}

@end 
