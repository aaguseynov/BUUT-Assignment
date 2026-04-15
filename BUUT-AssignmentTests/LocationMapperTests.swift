//
//  LocationMapperTests.swift
//  BUUT-AssignmentTests
//

import XCTest
@testable import BUUT_Assignment

final class LocationMapperTests: XCTestCase {
    @MainActor
    func testMap_trimsNameAndBuildsId() {
        let sut = LocationMapper()
        let dto = LocationDTO(name: "  Paris  ", lat: 48.8566, long: 2.3522)
        let location = sut.map(dto: dto)
        XCTAssertEqual(location.displayName, "Paris")
        XCTAssertEqual(location.latitude, 48.8566)
        XCTAssertEqual(location.longitude, 2.3522)
        XCTAssertEqual(location.id, "48.8566_2.3522_Paris")
    }

    @MainActor
    func testMap_emptyName_becomesUnknownLocation() {
        let sut = LocationMapper()
        let dto = LocationDTO(name: "   ", lat: 0, long: 0)
        let location = sut.map(dto: dto)
        XCTAssertEqual(location.displayName, "Unknown location")
        XCTAssertEqual(location.id, "0.0_0.0_Unknown location")
    }

    @MainActor
    func testMap_nilName_becomesUnknownLocation() {
        let sut = LocationMapper()
        let dto = LocationDTO(name: nil, lat: -33.8688, long: 151.2093)
        let location = sut.map(dto: dto)
        XCTAssertEqual(location.displayName, "Unknown location")
        XCTAssertEqual(location.id, "-33.8688_151.2093_Unknown location")
    }
}
