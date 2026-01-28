#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Rokt_Widget/Rokt_Widget-Swift.h>
#import <mParticle_Rokt/mParticle_Rokt.h>
#import "MPKitRokt.h"

NSInteger const kMPRoktKitCode = 181;
NSString * const kMPHashedEmailUserIdentityType = @"hashedEmailUserIdentityType";

@interface MPKitRokt ()

- (MPKitExecStatus *)executeWithIdentifier:(NSString * _Nullable)identifier
                              attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes
                           embeddedViews:(NSDictionary<NSString *, MPRoktEmbeddedView *> * _Nullable)embeddedViews
                                  config:(MPRoktConfig * _Nullable)mpRoktConfig
                               callbacks:(MPRoktEventCallback * _Nullable)callbacks
                            filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser;
- (MPKitExecStatus *)setWrapperSdk:(MPWrapperSdk)wrapperSdk version:(nonnull NSString *)wrapperSdkVersion;

- (MPKitExecStatus *)purchaseFinalized:(NSString *)placementId
                         catalogItemId:(NSString *)catalogItemId
                               success:(NSNumber *)success;

- (NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable) confirmEmbeddedViews:(NSDictionary<NSString *, MPRoktEmbeddedView *> * _Nullable)embeddedViews;

+ (void)addIdentityAttributes:(NSMutableDictionary<NSString *, NSString *> * _Nullable)attributes filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser;

+ (void)handleHashedEmail:(NSMutableDictionary<NSString *, NSString *> * _Nullable)attributes;

+ (NSDictionary *)getKitConfig;

+ (NSNumber *)getRoktHashedEmailUserIdentityType;

+ (RoktConfig *)convertMPRoktConfig:(MPRoktConfig *)mpRoktConfig;

+ (NSDictionary<NSString *, NSString *> *)transformValuesToString:(NSDictionary<NSString *, id> * _Nullable)originalDictionary;

+ (NSDictionary<NSString *, NSString *> *)mapAttributes:(NSDictionary<NSString *, NSString *> * _Nullable)attributes filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser;

+ (NSDictionary<NSString *, NSString *> *)confirmSandboxAttribute:(NSDictionary<NSString *, NSString *> * _Nullable)attributes;

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

- (void)testConfirmEmbeddedViews_ValidEmbeddedViews {
    MPRoktEmbeddedView *view = [[MPRoktEmbeddedView alloc] init];
    NSDictionary *embeddedViews = @{@"placement1": view};
    
    NSDictionary *result = [self.kitInstance confirmEmbeddedViews:embeddedViews];
    
    XCTAssertEqual(result.count, 1);
    XCTAssertTrue([result[@"placement1"] isKindOfClass:[RoktEmbeddedView class]]);
}

- (void)testConfirmEmbeddedViews_InvalidEmbeddedViews {
    NSDictionary *embeddedViews = @{@"placement1": @"invalid"};
    
    NSDictionary *result = [self.kitInstance confirmEmbeddedViews:embeddedViews];
    
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

- (void)testLogBaseEvent {
    MPEvent *event = [[MPEvent alloc] initWithName:@"Test Event" type:MPEventTypeOther];
    
    MPKitExecStatus *status = [self.kitInstance logBaseEvent:event];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
}

- (void)testExecuteWithIdentifier {
    id mockRoktSDK = OCMClassMock([Rokt class]);

    MPRoktEmbeddedView *view = [[MPRoktEmbeddedView alloc] init];
    NSString *identifier = @"TestView";
    NSDictionary *embeddedViews = @{@"placement1": view};
    NSDictionary *attributes = @{@"attr1": @"value1", @"sandbox": @"false"};
    FilteredMParticleUser *user = [[FilteredMParticleUser alloc] init];

    // Expect Rokt execute call and verify sandbox attribute is preserved
    // Note: attributes may include additional device identifiers (idfa, idfv, mpid)
    OCMExpect([mockRoktSDK executeWithViewName:identifier
                                    attributes:[OCMArg checkWithBlock:^BOOL(NSDictionary *attrs) {
                                        return [attrs[@"sandbox"] isEqualToString:@"false"];
                                    }]
                                    placements:OCMOCK_ANY
                                        config:nil
                                        onLoad:nil
                                      onUnLoad:nil
                  onShouldShowLoadingIndicator:nil
                  onShouldHideLoadingIndicator:nil
                          onEmbeddedSizeChange:nil]);
    
    MPKitExecStatus *status = [self.kitInstance executeWithIdentifier:identifier
                                                         attributes:attributes
                                                      embeddedViews:embeddedViews
                                                             config:nil
                                                          callbacks:nil
                                                       filteredUser:user];

    // Verify
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
    OCMVerifyAll(mockRoktSDK);
}

- (void)testExecuteSandboxDetection {
    id mockRoktSDK = OCMClassMock([Rokt class]);

    MPRoktEmbeddedView *view = [[MPRoktEmbeddedView alloc] init];
    NSString *identifier = @"TestView";
    NSDictionary *embeddedViews = @{@"placement1": view};
    NSDictionary *attributes = @{@"attr1": @"value1"};  // No sandbox attribute provided
    FilteredMParticleUser *user = [[FilteredMParticleUser alloc] init];

    // Expect Rokt execute call and verify sandbox attribute is auto-detected
    // In development environment, sandbox should be "true"
    // Note: attributes may include additional device identifiers (idfa, idfv, mpid)
    OCMExpect([mockRoktSDK executeWithViewName:identifier
                                    attributes:[OCMArg checkWithBlock:^BOOL(NSDictionary *attrs) {
                                        return attrs[@"sandbox"] != nil;  // Sandbox should be auto-added
                                    }]
                                    placements:OCMOCK_ANY
                                        config:nil
                                        onLoad:nil
                                      onUnLoad:nil
                  onShouldShowLoadingIndicator:nil
                  onShouldHideLoadingIndicator:nil
                          onEmbeddedSizeChange:nil]);
    
    MPKitExecStatus *status = [self.kitInstance executeWithIdentifier:identifier
                                                         attributes:attributes
                                                      embeddedViews:embeddedViews
                                                             config:nil
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
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:@(MPIdentityOther)] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    XCTAssertEqualObjects(passedAttributes[@"customerid"], @"testCustomerID");
    XCTAssertEqualObjects(passedAttributes[@"email"], @"testEmail@gmail.com");
    XCTAssertEqualObjects(passedAttributes[@"facebook"], @"testFacebook");
    XCTAssertEqualObjects(passedAttributes[@"facebookcustomaudienceid"], @"testCustomAudienceID");
    XCTAssertEqualObjects(passedAttributes[@"google"], @"testGoogle");
    XCTAssertEqualObjects(passedAttributes[@"microsoft"], @"testMicrosoft");
    XCTAssertNil(passedAttributes[@"other"]);
    XCTAssertEqualObjects(passedAttributes[@"emailsha256"], @"testOther");
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

- (void)testAddIdentityAttributesUnassigned {
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
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
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
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:@(MPIdentityOther)] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    XCTAssertEqualObjects(passedAttributes[@"foo"], @"bar");
    XCTAssertEqualObjects(passedAttributes[@"customerid"], @"testCustomerID");
    XCTAssertEqualObjects(passedAttributes[@"email"], @"testEmail@gmail.com");
    XCTAssertEqualObjects(passedAttributes[@"facebook"], @"testFacebook");
    XCTAssertEqualObjects(passedAttributes[@"facebookcustomaudienceid"], @"testCustomAudienceID");
    XCTAssertEqualObjects(passedAttributes[@"google"], @"testGoogle");
    XCTAssertEqualObjects(passedAttributes[@"microsoft"], @"testMicrosoft");
    XCTAssertNil(passedAttributes[@"other"]);
    XCTAssertEqualObjects(passedAttributes[@"emailsha256"], @"testOther");
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

- (void)testAddIdentityAttributesWithExistingAttributesAndOther {
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
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:@(MPIdentityOther4)] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    XCTAssertEqualObjects(passedAttributes[@"foo"], @"bar");
    XCTAssertEqualObjects(passedAttributes[@"customerid"], @"testCustomerID");
    XCTAssertEqualObjects(passedAttributes[@"email"], @"testEmail@gmail.com");
    XCTAssertEqualObjects(passedAttributes[@"facebook"], @"testFacebook");
    XCTAssertEqualObjects(passedAttributes[@"facebookcustomaudienceid"], @"testCustomAudienceID");
    XCTAssertEqualObjects(passedAttributes[@"google"], @"testGoogle");
    XCTAssertEqualObjects(passedAttributes[@"microsoft"], @"testMicrosoft");
    XCTAssertEqualObjects(passedAttributes[@"other"], @"testOther");
    XCTAssertEqualObjects(passedAttributes[@"emailsha256"], @"testOther4");
    XCTAssertEqualObjects(passedAttributes[@"twitter"], @"testTwitter");
    XCTAssertEqualObjects(passedAttributes[@"yahoo"], @"testYahoo");
    XCTAssertEqualObjects(passedAttributes[@"other2"], @"testOther2");
    XCTAssertEqualObjects(passedAttributes[@"other3"], @"testOther3");
    XCTAssertNil(passedAttributes[@"other4"]);
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

- (void)testConvertMPRoktConfig {
    MPRoktConfig *mpConfig = [[MPRoktConfig alloc] init];
    mpConfig.colorMode = MPColorModeDark;
    mpConfig.cacheDuration = @(100);
    mpConfig.cacheAttributes = @{@"test": @"tested"};
    
    // RoktConfig does not expose any of it's properties so we are only able to confirm that it was successfully initialized
    RoktConfig *roktConfig = [MPKitRokt convertMPRoktConfig:mpConfig];
    
    XCTAssert(roktConfig);
}

- (void)runSetWrapperSdkTestWithProvidedMPWrapperType:(MPWrapperSdk)providedMPWrapperType expectedRoktFrameworkType:(RoktFrameworkType)expectedRoktFrameworkType {
    id mockRoktSDK = OCMClassMock([Rokt class]);

    // Expect Rokt execute call with correct parameters
    OCMExpect([mockRoktSDK setFrameworkTypeWithFrameworkType:expectedRoktFrameworkType]);

    MPKitExecStatus *status = [self.kitInstance setWrapperSdk:providedMPWrapperType
                                                         version:@""];

    // Verify
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
    OCMVerifyAll(mockRoktSDK);
    [mockRoktSDK stopMocking];
}

- (void)testSetWrapperSdk {
    [self runSetWrapperSdkTestWithProvidedMPWrapperType:MPWrapperSdkNone expectedRoktFrameworkType:RoktFrameworkTypeIOS];
    [self runSetWrapperSdkTestWithProvidedMPWrapperType:MPWrapperSdkUnity expectedRoktFrameworkType:RoktFrameworkTypeIOS];
    [self runSetWrapperSdkTestWithProvidedMPWrapperType:MPWrapperSdkReactNative expectedRoktFrameworkType:RoktFrameworkTypeReactNative];
    [self runSetWrapperSdkTestWithProvidedMPWrapperType:MPWrapperSdkCordova expectedRoktFrameworkType:RoktFrameworkTypeCordova];
    [self runSetWrapperSdkTestWithProvidedMPWrapperType:MPWrapperSdkXamarin expectedRoktFrameworkType:RoktFrameworkTypeIOS];
    [self runSetWrapperSdkTestWithProvidedMPWrapperType:MPWrapperSdkFlutter expectedRoktFrameworkType:RoktFrameworkTypeFlutter];
}

- (void)testPurchaseFinalized {
    if (@available(iOS 15.0, *)) {
        id mockRoktSDK = OCMClassMock([Rokt class]);
        
        // Set up test parameters
        NSString *placementId = @"testonversion";
        NSString *catalogItemId = @"testcatalogItemId";
        BOOL success = YES;
        
        // Expect Rokt reportConversion call with correct parameters
        OCMExpect([mockRoktSDK purchaseFinalizedWithPlacementId:placementId
                                                  catalogItemId:catalogItemId
                                                        success:success]);
        
        MPKitExecStatus *status = [self.kitInstance purchaseFinalized:placementId
                                                        catalogItemId:catalogItemId
                                                              success:@(success)];
        
        // Verify
        XCTAssertNotNil(status);
        XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
        OCMVerifyAll(mockRoktSDK);
    }
}

- (void)testEvents_Success {
    id mockRoktSDK = OCMClassMock([Rokt class]);

    NSString *identifier = @"TestViewName";
    __block BOOL callbackCalled = NO;
    __block MPRoktEvent *receivedEvent = nil;

    // Mock the Rokt SDK call and simulate triggering the callback with a mock event
    OCMStub([mockRoktSDK eventsWithViewName:identifier onEvent:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        // Get the callback block from the invocation
        void (^onEventCallback)(RoktEvent *) = nil;
        [invocation getArgument:&onEventCallback atIndex:3]; // Index 3 is the second parameter (onEvent)

        // Create a dummy ShowLoadingIndicator for testing
        id mockRoktEvent = [[ShowLoadingIndicator alloc] init];

        // Simulate the callback being called
        if (onEventCallback) {
            onEventCallback(mockRoktEvent);
        }
    });

    // Execute the method under test
    MPKitExecStatus *status = [self.kitInstance events:identifier onEvent:^(MPRoktEvent * _Nonnull event) {
        callbackCalled = YES;
        receivedEvent = event;
    }];

    // Verify the Rokt SDK method was called
    OCMVerify([mockRoktSDK eventsWithViewName:identifier onEvent:[OCMArg any]]);

    // Verify the return status
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
    XCTAssertEqualObjects(status.integrationId, @181);

    // Verify the callback was called with the mapped event
    XCTAssertTrue(callbackCalled);
    XCTAssertNotNil(receivedEvent);
    XCTAssertEqual([receivedEvent class], [MPRoktShowLoadingIndicator class]);

    [mockRoktSDK stopMocking];
}

- (void)testEvents_MappingReturnsNil {
    id mockRoktSDK = OCMClassMock([Rokt class]);

    NSString *identifier = @"TestViewName";
    __block BOOL callbackCalled = NO;

    // Mock the Rokt SDK call and simulate triggering the callback with a mock event
    OCMStub([mockRoktSDK eventsWithViewName:identifier onEvent:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        // Get the callback block from the invocation
        void (^onEventCallback)(RoktEvent *) = nil;
        [invocation getArgument:&onEventCallback atIndex:3];

        // Create a mock RoktEvent for testing
        id mockRoktEvent = OCMClassMock([RoktEvent class]);

        // Simulate the callback being called
        if (onEventCallback) {
            onEventCallback(mockRoktEvent);
        }
    });

    // Execute the method under test
    MPKitExecStatus *status = [self.kitInstance events:identifier onEvent:^(MPRoktEvent * _Nonnull event) {
        callbackCalled = YES;
    }];

    // Verify the Rokt SDK method was called
    OCMVerify([mockRoktSDK eventsWithViewName:identifier onEvent:[OCMArg any]]);

    // Verify the return status
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);

    // Verify the callback was NOT called since mapping returned nil
    XCTAssertFalse(callbackCalled);

    [mockRoktSDK stopMocking];
}

- (void)testEvents_NilIdentifier {
    id mockRoktSDK = OCMClassMock([Rokt class]);

    NSString *identifier = @"";
    __block BOOL callbackCalled = NO;

    // The Rokt SDK should still be called even with nil identifier
    OCMExpect([mockRoktSDK eventsWithViewName:@"" onEvent:[OCMArg any]]);

    // Execute the method under test
    MPKitExecStatus *status = [self.kitInstance events:identifier onEvent:^(MPRoktEvent * _Nonnull event) {
        callbackCalled = YES;
    }];

    // Verify the Rokt SDK method was called
    OCMVerify([mockRoktSDK eventsWithViewName:@"" onEvent:[OCMArg any]]);

    // Verify the return status
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);

    [mockRoktSDK stopMocking];
}

- (void)testHandleHashedEmailOtherOverride {
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    [passedAttributes setObject:@"foo@gmail.com" forKey:@"email"];
    [passedAttributes setObject:@"test@gmail.com" forKey:@"other"];
    
    [MPKitRokt handleHashedEmail:passedAttributes];
    
    XCTAssertEqualObjects(passedAttributes[@"email"], @"foo@gmail.com");
    XCTAssertEqualObjects(passedAttributes[@"other"], @"test@gmail.com");
    XCTAssertNil(passedAttributes[@"emailsha256"]);
    XCTAssertTrue(passedAttributes.allKeys.count == 2);
}

- (void)testHandleHashedEmailHashedOverride {
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    [passedAttributes setObject:@"foo@gmail.com" forKey:@"email"];
    [passedAttributes setObject:@"foo-value" forKey:@"other"];
    [passedAttributes setObject:@"test2@gmail.com" forKey:@"emailsha256"];
    
    [MPKitRokt handleHashedEmail:passedAttributes];
    
    XCTAssertNil(passedAttributes[@"email"]);
    XCTAssertEqualObjects(passedAttributes[@"other"], @"foo-value");
    XCTAssertEqualObjects(passedAttributes[@"emailsha256"], @"test2@gmail.com");
    XCTAssertTrue(passedAttributes.allKeys.count == 2);
}

- (void)testTransformValuesToString {
    NSMutableDictionary<NSString *, id> *passedAttributes = [[NSMutableDictionary alloc] init];
    [passedAttributes setObject:@"foo@gmail.com" forKey:@"email"];
    [passedAttributes setObject:@"test@gmail.com" forKey:@"other"];
    [passedAttributes setObject:@"test2@gmail.com" forKey:@"emailsha256"];
    [passedAttributes setObject:[NSNull null] forKey:@"testCrash"];

    
    NSDictionary<NSString *, NSString *> *finalAtt = [MPKitRokt transformValuesToString:passedAttributes];
    
    XCTAssertEqualObjects(finalAtt[@"testCrash"], @"null");
    XCTAssertEqualObjects(finalAtt[@"email"], @"foo@gmail.com");
    XCTAssertEqualObjects(finalAtt[@"other"], @"test@gmail.com");
    XCTAssertEqualObjects(finalAtt[@"emailsha256"], @"test2@gmail.com");
    XCTAssertTrue(finalAtt.allKeys.count == 4);
}

- (void)testGetRoktHashedEmailUserIdentityTypeOther4 {
    // Test case 1: When kit configuration exists with hashed email identity type
    NSDictionary *roktKitConfig = @{
        @"id": @(kMPRoktKitCode),
        @"as": @{
            kMPHashedEmailUserIdentityType: @"other4"
        }
    };
    
    // Mock the MParticle shared instance and kit container
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:roktKitConfig] getKitConfig];
    
    // Call the method and verify result
    NSNumber *result = [MPKitRokt getRoktHashedEmailUserIdentityType];
    XCTAssertEqualObjects(result, @(MPIdentityOther4), @"Should return MPIdentityOther4 when configured with 'other4'");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testGetRoktHashedEmailUserIdentityTypeConfigNil {
    // Test case 2: When kit config nil
    // Mock the MParticle shared instance and kit container
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getKitConfig];
    
    NSNumber *defaultResult = [MPKitRokt getRoktHashedEmailUserIdentityType];
    XCTAssertNil(defaultResult, @"Should return nil when when no configuration exists");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testGetRoktHashedEmailUserIdentityTypeNil {
    // Mock the MParticle shared instance and kit container
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    // Test case 3: When kit config exists but no hashed email identity type specified
    NSDictionary *roktKitConfigNoHash = @{
        @"id": @(kMPRoktKitCode),
        @"as": @{
            // No kMPHashedEmailUserIdentityType specified
        }
    };
    [[[mockMPKitRoktClass stub] andReturn:roktKitConfigNoHash] getKitConfig];
    
    NSNumber *noHashResult = [MPKitRokt getRoktHashedEmailUserIdentityType];
    XCTAssertNil(noHashResult, @"Should return nil when hashed email identity type not specified");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testMapAttributesWithNewConfigurationStructure {
    // Test the mapAttributes method with the new nested configuration structure
    NSDictionary *roktKitConfig = @{
        @"id": @(kMPRoktKitCode),
        @"as": @{
            @"placementAttributesMapping": @"[{\"jsmap\":null,\"map\":\"f.name\",\"maptype\":\"UserAttributeClass.Name\",\"value\":\"firstname\"},{\"jsmap\":null,\"map\":\"zip\",\"maptype\":\"UserAttributeClass.Name\",\"value\":\"billingzipcode\"},{\"jsmap\":null,\"map\":\"l.name\",\"maptype\":\"UserAttributeClass.Name\",\"value\":\"lastname\"}]"
        }
    };
    
    // Mock the kit configuration
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:roktKitConfig] getKitConfig];
    
    // Create test input attributes
    NSDictionary<NSString *, NSString *> *inputAttributes = @{
        @"f.name": @"John",
        @"zip": @"12345",
        @"l.name": @"Doe",
        @"email": @"john.doe@example.com"
    };
    
    // Create mock filtered user
    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockFilteredUser = OCMPartialMock(filteredUser);
    [[[mockFilteredUser stub] andReturn:@{}] userAttributes];
    
    // Call mapAttributes method
    NSDictionary<NSString *, NSString *> *result = [MPKitRokt mapAttributes:inputAttributes filteredUser:mockFilteredUser];
    
    // Verify the mapping worked correctly
    XCTAssertEqualObjects(result[@"firstname"], @"John", @"f.name should be mapped to firstname");
    XCTAssertEqualObjects(result[@"billingzipcode"], @"12345", @"zip should be mapped to billingzipcode");
    XCTAssertEqualObjects(result[@"lastname"], @"Doe", @"l.name should be mapped to lastname");
    XCTAssertEqualObjects(result[@"email"], @"john.doe@example.com", @"email should remain unchanged");
    
    // Verify original keys are removed
    XCTAssertNil(result[@"f.name"], @"Original f.name key should be removed");
    XCTAssertNil(result[@"zip"], @"Original zip key should be removed");
    XCTAssertNil(result[@"l.name"], @"Original l.name key should be removed");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testMapAttributesWithNoConfiguration {
    // Test mapAttributes when no kit configuration exists
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getKitConfig];
    
    NSDictionary<NSString *, NSString *> *inputAttributes = @{
        @"email": @"test@example.com",
        @"name": @"Test User"
    };
    
    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    
    // Call mapAttributes method
    NSDictionary<NSString *, NSString *> *result = [MPKitRokt mapAttributes:inputAttributes filteredUser:filteredUser];
    
    // Should return original attributes unchanged
    XCTAssertEqualObjects(result, inputAttributes, @"Should return original attributes when no configuration exists");
    
    [mockMPKitRoktClass stopMocking];
}

#pragma mark - Device Identifier Tests (IDFA/IDFV)

- (void)testAddIdentityAttributesWithDeviceIdentifiers {
    // Test that IDFA and IDFV device identifiers are added from filteredUser
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{
        @(MPIdentityEmail): @"test@example.com"
    };

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockFilteredUser = OCMPartialMock(filteredUser);
    [[[mockFilteredUser stub] andReturn:testIdentities] userIdentities];
    [[[mockFilteredUser stub] andReturn:@"test-idfa-value"] idfa];
    [[[mockFilteredUser stub] andReturn:@"test-idfv-value"] idfv];
    [[[mockFilteredUser stub] andReturn:@(12345)] userId];
    
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    // Verify device identifiers are added
    XCTAssertEqualObjects(passedAttributes[@"idfa"], @"test-idfa-value", @"IDFA should be added from filteredUser.idfa");
    XCTAssertEqualObjects(passedAttributes[@"idfv"], @"test-idfv-value", @"IDFV should be added from filteredUser.idfv");
    XCTAssertEqualObjects(passedAttributes[@"mpid"], @"12345", @"MPID should be added from filteredUser.userId");
    XCTAssertEqualObjects(passedAttributes[@"email"], @"test@example.com", @"Email should still be added");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testAddIdentityAttributesWithNilIdfa {
    // Test behavior when IDFA is nil (e.g., ATT permission not granted)
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{
        @(MPIdentityEmail): @"test@example.com"
    };

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockFilteredUser = OCMPartialMock(filteredUser);
    [[[mockFilteredUser stub] andReturn:testIdentities] userIdentities];
    [[[mockFilteredUser stub] andReturn:nil] idfa];  // IDFA nil when ATT not authorized
    [[[mockFilteredUser stub] andReturn:@"test-idfv-value"] idfv];
    [[[mockFilteredUser stub] andReturn:@(12345)] userId];
    
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    // Verify IDFA is nil but IDFV is still added
    XCTAssertNil(passedAttributes[@"idfa"], @"IDFA should be nil when not authorized");
    XCTAssertEqualObjects(passedAttributes[@"idfv"], @"test-idfv-value", @"IDFV should still be added");
    XCTAssertEqualObjects(passedAttributes[@"mpid"], @"12345", @"MPID should still be added");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testAddIdentityAttributesWithNilIdfv {
    // Test behavior when IDFV is nil
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{
        @(MPIdentityEmail): @"test@example.com"
    };

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockFilteredUser = OCMPartialMock(filteredUser);
    [[[mockFilteredUser stub] andReturn:testIdentities] userIdentities];
    [[[mockFilteredUser stub] andReturn:@"test-idfa-value"] idfa];
    [[[mockFilteredUser stub] andReturn:nil] idfv];  // IDFV nil
    [[[mockFilteredUser stub] andReturn:@(12345)] userId];
    
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    // Verify IDFV is nil but IDFA is still added
    XCTAssertEqualObjects(passedAttributes[@"idfa"], @"test-idfa-value", @"IDFA should still be added");
    XCTAssertNil(passedAttributes[@"idfv"], @"IDFV should be nil");
    XCTAssertEqualObjects(passedAttributes[@"mpid"], @"12345", @"MPID should still be added");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testAddIdentityAttributesWithBothDeviceIdentifiersNil {
    // Test behavior when both IDFA and IDFV are nil
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{
        @(MPIdentityEmail): @"test@example.com"
    };

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockFilteredUser = OCMPartialMock(filteredUser);
    [[[mockFilteredUser stub] andReturn:testIdentities] userIdentities];
    [[[mockFilteredUser stub] andReturn:nil] idfa];
    [[[mockFilteredUser stub] andReturn:nil] idfv];
    [[[mockFilteredUser stub] andReturn:@(12345)] userId];
    
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    // Verify both device identifiers are nil
    XCTAssertNil(passedAttributes[@"idfa"], @"IDFA should be nil");
    XCTAssertNil(passedAttributes[@"idfv"], @"IDFV should be nil");
    // Other identities should still be added
    XCTAssertEqualObjects(passedAttributes[@"email"], @"test@example.com", @"Email should still be added");
    XCTAssertEqualObjects(passedAttributes[@"mpid"], @"12345", @"MPID should still be added");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testAddIdentityAttributesDeviceIdentifiersDoNotOverrideUserIdentities {
    // Test that device IDFA/IDFV (idfa/idfv keys) coexist with user identity IDFA/IDFV (ios_idfa/ios_idfv keys)
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{
        @(MPIdentityEmail): @"test@example.com",
        @(MPIdentityIOSAdvertiserId): @"user-identity-idfa",
        @(MPIdentityIOSVendorId): @"user-identity-idfv"
    };

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockFilteredUser = OCMPartialMock(filteredUser);
    [[[mockFilteredUser stub] andReturn:testIdentities] userIdentities];
    [[[mockFilteredUser stub] andReturn:@"device-idfa"] idfa];
    [[[mockFilteredUser stub] andReturn:@"device-idfv"] idfv];
    [[[mockFilteredUser stub] andReturn:@(12345)] userId];
    
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    // Verify both device identifiers and user identity identifiers are present with different keys
    XCTAssertEqualObjects(passedAttributes[@"idfa"], @"device-idfa", @"Device IDFA should be added with 'idfa' key");
    XCTAssertEqualObjects(passedAttributes[@"idfv"], @"device-idfv", @"Device IDFV should be added with 'idfv' key");
    XCTAssertEqualObjects(passedAttributes[@"ios_idfa"], @"user-identity-idfa", @"User identity IDFA should be added with 'ios_idfa' key");
    XCTAssertEqualObjects(passedAttributes[@"ios_idfv"], @"user-identity-idfv", @"User identity IDFV should be added with 'ios_idfv' key");
    XCTAssertEqualObjects(passedAttributes[@"mpid"], @"12345", @"MPID should be added");
    
    [mockMPKitRoktClass stopMocking];
}

- (void)testAddIdentityAttributesMpidWithNilUserId {
    // Test behavior when userId is nil
    NSMutableDictionary<NSString *, NSString *> *passedAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary<NSNumber *, NSString *> *testIdentities = @{
        @(MPIdentityEmail): @"test@example.com"
    };

    FilteredMParticleUser *filteredUser = [[FilteredMParticleUser alloc] init];
    id mockFilteredUser = OCMPartialMock(filteredUser);
    [[[mockFilteredUser stub] andReturn:testIdentities] userIdentities];
    [[[mockFilteredUser stub] andReturn:@"test-idfa"] idfa];
    [[[mockFilteredUser stub] andReturn:@"test-idfv"] idfv];
    [[[mockFilteredUser stub] andReturn:nil] userId];  // nil userId
    
    id mockMPKitRoktClass = OCMClassMock([MPKitRokt class]);
    [[[mockMPKitRoktClass stub] andReturn:nil] getRoktHashedEmailUserIdentityType];
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
    // Verify MPID is nil when userId is nil
    XCTAssertNil(passedAttributes[@"mpid"], @"MPID should be nil when userId is nil");
    // Other identifiers should still be added
    XCTAssertEqualObjects(passedAttributes[@"idfa"], @"test-idfa", @"IDFA should still be added");
    XCTAssertEqualObjects(passedAttributes[@"idfv"], @"test-idfv", @"IDFV should still be added");
    
    [mockMPKitRoktClass stopMocking];
}

@end
