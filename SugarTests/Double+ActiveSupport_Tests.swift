//
//  Double+ActiveSupport_Tests.swift
//  Sugar Example
//
//  Created by 朱文杰 on 15/11/22.
//  Copyright © 2015年 朱文杰. All rights reserved.
//

import XCTest
import Foundation
@testable import Sugar

class DoubleActiveSupportTests: XCTestCase {

    func testFromNow() {
        let now = NSDate()
        let t = 2.days.fromNow()
        XCTAssertEqual(now.day + 2, t.day)
    }

    func testAgo() {
        let now = NSDate()
        let t = 2.days.ago()
        XCTAssertEqual(now.day - 2, t.day)
    }

    func testHours() {
        let result = 1.0.hours
        let target = 3600.0
        XCTAssertEqual(result, target)
    }

    func testSeconds() {
        let result = 1.0.seconds
        let target = 1.0
        XCTAssertEqual(result, target)
    }

    func testMinutes() {
        let result = 1.0.minutes
        let target = 60.0
        XCTAssertEqual(result, target)
    }

    func testDays() {
        let result = 1.0.days
        let target = 24.0 * 3600.0
        XCTAssertEqual(result, target)
    }

    func testWeeks() {
        let result = 1.0.weeks
        let target = 24.0 * 3600.0 * 7.0
        XCTAssertEqual(result, target)
    }
}
