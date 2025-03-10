#import <XCTest/XCTest.h>
#import "MPKitRokt.h"

@interface mParticle_RoktTests : XCTestCase

@end

@implementation mParticle_RoktTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModuleID {
    XCTAssertEqualObjects([MPKitRokt kitCode], @1234);
}

- (void)testStarted {
    MPKitRokt *roktKit = [[MPKitRokt alloc] init];
    [roktKit didFinishLaunchingWithConfiguration:@{@"partnerId":@"12345"}];
    XCTAssertTrue(roktKit.started);
}

@end
