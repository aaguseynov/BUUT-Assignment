//
//  DefaultLocationCoordinatesFormattingTests.swift
//  BUUT-AssignmentTests
//

import XCTest
@testable import BUUT_Assignment

final class DefaultLocationCoordinatesFormattingTests: XCTestCase {
    @MainActor
    func testFormatCoordinates_positiveLatLon() {
        let sut = DefaultLocationCoordinatesFormatting()
        let text = sut.formatCoordinates(latitude: 55.7558, longitude: 37.6173)
        XCTAssertTrue(text.contains("55.755800°"))
        XCTAssertTrue(text.contains("37.617300°"))
        XCTAssertTrue(text.contains("N"))
        XCTAssertTrue(text.contains("E"))
        XCTAssertTrue(text.contains("Latitude:"))
        XCTAssertTrue(text.contains("Longitude:"))
    }

    @MainActor
    func testFormatCoordinates_negativeLatLon() {
        let sut = DefaultLocationCoordinatesFormatting()
        let text = sut.formatCoordinates(latitude: -33.8688, longitude: -151.2093)
        XCTAssertTrue(text.contains("S"))
        XCTAssertTrue(text.contains("W"))
    }
}
