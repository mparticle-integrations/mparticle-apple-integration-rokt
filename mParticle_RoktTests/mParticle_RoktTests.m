#import <XCTest/XCTest.h>
#import <Rokt_Widget/Rokt_Widget-Swift.h>
#import "MPKitRokt.h"

@interface MPKitRokt ()

- (MPKitExecStatus *)executeWithViewName:(NSString * _Nullable)viewName
                              attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes
                              placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements
                                  onLoad:(void (^ _Nullable)(void))onLoad
                                onUnLoad:(void (^ _Nullable)(void))onUnLoad
            onShouldShowLoadingIndicator:(void (^ _Nullable)(void))onShouldShowLoadingIndicator
            onShouldHideLoadingIndicator:(void (^ _Nullable)(void))onShouldHideLoadingIndicator
                    onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange
                            filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser;

- (NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable) confirmPlacements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements;

- (NSDictionary<NSString *, NSString *> *) filteredUserAttributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes kitConfiguration:(MPKitConfiguration *)kitConfiguration;
    
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

- (void)testFilteredUserAttributes {
    NSDictionary *attributes = @{
        @"email": @"test@example.com",
        @"name": @"Test User"
    };
    
    NSDictionary *kitConfigDictionary = @{
        
    };
    
    MPKitConfiguration *kitConfig = [[MPKitConfiguration alloc] initWithDictionary: kitConfigDictionary];
    kitConfig.userAttributeFilters = @{
        [MPIHasher hashString:@"email"]: @0  // Filter out email
    };
    
    NSDictionary *filtered = [self.kitInstance filteredUserAttributes:attributes kitConfiguration:kitConfig];
    
    XCTAssertEqual(filtered.count, 1);
    XCTAssertNil(filtered[@"email"]);
    XCTAssertEqualObjects(filtered[@"name"], @"Test User");
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
    RoktEmbeddedView *view = [[RoktEmbeddedView alloc] init];
    NSDictionary *placements = @{@"placement1": view};
    NSDictionary *attributes = @{@"attr1": @"value1"};
    FilteredMParticleUser *user = [[FilteredMParticleUser alloc] init];
    
    MPKitExecStatus *status = [self.kitInstance executeWithViewName:@"TestView"
                                                       attributes:attributes
                                                       placements:placements
                                                           onLoad:nil
                                                         onUnLoad:nil
                                     onShouldShowLoadingIndicator:nil
                                     onShouldHideLoadingIndicator:nil
                                             onEmbeddedSizeChange:nil
                                                     filteredUser:user];
    
    XCTAssertNotNil(status);
    XCTAssertEqual(status.returnCode, MPKitReturnCodeSuccess);
}

@end 
