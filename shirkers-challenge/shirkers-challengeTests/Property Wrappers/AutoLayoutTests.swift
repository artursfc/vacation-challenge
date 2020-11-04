//
//  AutoLayoutTests.swift
//  shirkers-challengeTests
//
//  Created by Artur Carneiro on 04/11/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import XCTest
@testable import shirkers_challenge

final class AutoLayoutTests: XCTestCase {
    @AutoLayout var sut: UIView

    func testTranslatesAutoresizingMaskIntoConstraintsFalse() {
        XCTAssertFalse(sut.translatesAutoresizingMaskIntoConstraints)
    }

    func testFrameZero() {
        XCTAssertEqual(sut.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}
