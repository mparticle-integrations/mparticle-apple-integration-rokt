//
//  mParticle_RoktTests.swift
//  mParticle_RoktTests
//
//  Created by Danial on 3/11/25.
//  Copyright © 2025 mParticle. All rights reserved.
//

import XCTest
@testable import mParticle_Rokt

final class mParticle_RoktTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStarted() throws {
        let roktKit = MPKitRokt()
        let _ = roktKit.didFinishLaunching(withConfiguration: ["accountId":"12345"])
        XCTAssertTrue(roktKit.started);
    }

}
