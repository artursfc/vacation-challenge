//
//  UserDefaultsAccessTests.swift
//  shirkers-challengeTests
//
//  Created by Artur Carneiro on 04/11/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import XCTest
@testable import shirkers_challenge

final class UserDefaultsAccessTests: XCTestCase {
    @UserDefaultsAccess(key: "test-string",
                        defaultValue: "default-value",
                        userDefaults: UserDefaultsMock.shared)
    var sutString: String

    @UserDefaultsAccess(key: "test-int",
                        defaultValue: 99,
                        userDefaults: UserDefaultsMock.shared)
    var sutInt: Int

    func testWrapper() {
        XCTAssertEqual(sutString, "default-value")
        
        sutString = "get-value"
        XCTAssertEqual(sutString, "get-value")

        XCTAssertEqual(sutInt, 99)

        sutInt = 20
        XCTAssertEqual(sutInt, 20)
    }
}
