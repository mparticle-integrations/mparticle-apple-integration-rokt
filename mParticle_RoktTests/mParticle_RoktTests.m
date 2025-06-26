#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Rokt_Widget/Rokt_Widget-Swift.h>
#import <mParticle_Rokt/mParticle_Rokt.h>
#import "MPKitRokt.h"
#import <mParticle_Rokt/mParticle_Rokt-Swift.h>

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

+ (RoktConfig *)convertMPRoktConfig:(MPRoktConfig *)mpRoktConfig;

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
    NSDictionary *attributes = @{@"attr1": @"value1", @"sandbox": @"true"};
    FilteredMParticleUser *user = [[FilteredMParticleUser alloc] init];
    
    // Expected attributes in final call
    NSDictionary *expectedAttributes = @{
        @"sandbox": @"true"
    };

    // Expect Rokt execute call with correct parameters
    OCMExpect([mockRoktSDK executeWithViewName:identifier
                                    attributes:expectedAttributes
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
    
    [MPKitRokt addIdentityAttributes:passedAttributes filteredUser:filteredUser];
    
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

@end
