//
//  testTextSelectionTests.swift
//  testTextSelectionTests
//
//  Created by James Tang on 29/3/2023.
//

import XCTest
@testable import testTextSelection

final class testTextSelectionTests: XCTestCase {

    func testNormalRange() {
        let result = safeRangeTransformer.handle(("aa", NSRange(location: 0, length: 1)))
        XCTAssertEqual(result, NSRange(location: 0, length: 1))
    }

    func testClipOutOfBounds() {
        let result = safeRangeTransformer.handle(("aa", NSRange(location: 1, length: 2)))
        XCTAssertEqual(result, NSRange(location: 1, length: 1))
    }

    func testFullyOutOfBounds() {
        let result = safeRangeTransformer.handle(("aa", NSRange(location: 2, length: 1)))
        XCTAssertEqual(result, NSRange(location: 0, length: 0))
    }

    func testNegativeLocation() {
        let result = safeRangeTransformer.handle(("aa", NSRange(location: -1, length: 2)))
        XCTAssertEqual(result, NSRange(location: 0, length: 0))
    }

    func testNegativeLocationAndNegativeLength() {
        let result = safeRangeTransformer.handle(("aa", NSRange(location: -1, length: -1)))
        XCTAssertEqual(result, NSRange(location: 0, length: 0))
    }

    func testPositiveLocationAndNegativeLength() {
        let result = safeRangeTransformer.handle(("aa", NSRange(location: 1, length: -1)))
        XCTAssertEqual(result, NSRange(location: 1, length: 0))
    }

    func testPositiveLocationAndNegativeLength2() {
        let result = safeRangeTransformer.handle(("aa", NSRange(location: 1, length: -3)))
        XCTAssertEqual(result, NSRange(location: 1, length: 0))
    }

}
