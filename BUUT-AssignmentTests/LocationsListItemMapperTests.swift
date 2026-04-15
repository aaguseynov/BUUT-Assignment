//
//  LocationsListItemMapperTests.swift
//  BUUT-AssignmentTests
//

import XCTest
@testable import BUUT_Assignment

final class LocationsListItemMapperTests: XCTestCase {
    @MainActor
    func testViewData_mapsFieldsAndCoordinatesLine() {
        let sut = LocationsListItemMapper()
        let location = Location(
            id: "id1",
            displayName: "Berlin",
            latitude: 52.52,
            longitude: 13.405
        )
        let vd = sut.viewData(from: location)
        XCTAssertEqual(vd.id, "id1")
        XCTAssertEqual(vd.title, "Berlin")
        XCTAssertEqual(vd.latitude, 52.52)
        XCTAssertEqual(vd.longitude, 13.405)
        XCTAssertEqual(vd.coordinatesLine, "52.52000, 13.40500")
    }

    @MainActor
    func testViewData_negativeCoordinates() {
        let sut = LocationsListItemMapper()
        let location = Location(
            id: "x",
            displayName: "South",
            latitude: -12.34,
            longitude: -56.78
        )
        let vd = sut.viewData(from: location)
        XCTAssertEqual(vd.coordinatesLine, "-12.34000, -56.78000")
    }
}
