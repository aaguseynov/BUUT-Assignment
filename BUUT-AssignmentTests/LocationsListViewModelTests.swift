//
//  LocationsListViewModelTests.swift
//  BUUT-AssignmentTests
//

import XCTest
@testable import BUUT_Assignment

private final class MockFetchLocationsUseCase: FetchLocationsUseCaseProtocol, @unchecked Sendable {
    var result: Result<[Location], Error> = .success([])
    private(set) var executeCallCount = 0

    func execute() async throws -> [Location] {
        executeCallCount += 1
        switch result {
        case .success(let locations): return locations
        case .failure(let error): throw error
        }
    }
}

private final class SlowCancellableFetchUseCase: FetchLocationsUseCaseProtocol, @unchecked Sendable {
    func execute() async throws -> [Location] {
        try await Task.sleep(for: .seconds(60))
        return []
    }
}

final class LocationsListViewModelTests: XCTestCase {
    private let strings = DefaultLocationsListStrings()
    private let mapping = LocationsListItemMapper()

    @MainActor
    func testLoad_success_setsLoadedState() async {
        let useCase = MockFetchLocationsUseCase()
        let loc = Location(id: "1", displayName: "City", latitude: 1, longitude: 2)
        useCase.result = .success([loc])
        let sut = LocationsListViewModel(useCase: useCase, strings: strings, itemMapping: mapping)
        sut.load()
        let ok = await waitUntil(sut) { vm in
            if case .loaded(let items) = vm.state { return items == [loc] }
            return false
        }
        XCTAssertTrue(ok, "expected loaded state with one item")
        XCTAssertFalse(sut.isFetching)
    }

    @MainActor
    func testLoad_empty_setsEmptyState() async {
        let useCase = MockFetchLocationsUseCase()
        useCase.result = .success([])
        let sut = LocationsListViewModel(useCase: useCase, strings: strings, itemMapping: mapping)
        sut.load()
        let ok = await waitUntil(sut) { vm in
            if case .empty = vm.state { return true }
            return false
        }
        XCTAssertTrue(ok)
        XCTAssertFalse(sut.isFetching)
    }

    @MainActor
    func testLoad_failure_setsFailedState() async {
        let useCase = MockFetchLocationsUseCase()
        useCase.result = .failure(NSError(domain: "t", code: 1, userInfo: [NSLocalizedDescriptionKey: "boom"]))
        let sut = LocationsListViewModel(useCase: useCase, strings: strings, itemMapping: mapping)
        sut.load()
        let ok = await waitUntil(sut) { vm in
            if case .failed(let msg) = vm.state { return msg == "boom" }
            return false
        }
        XCTAssertTrue(ok)
        XCTAssertFalse(sut.isFetching)
    }

    @MainActor
    func testSelectItem_whenLoaded_emitsLocation() async {
        let useCase = MockFetchLocationsUseCase()
        let loc = Location(id: "id1", displayName: "X", latitude: 0, longitude: 0)
        useCase.result = .success([loc])
        let sut = LocationsListViewModel(useCase: useCase, strings: strings, itemMapping: mapping)
        var received: Location?
        sut.onLocationDetailRequested = { received = $0 }
        sut.load()
        let loaded = await waitUntil(sut) { vm in
            if case .loaded = vm.state { return true }
            return false
        }
        XCTAssertTrue(loaded)
        let item = LocationListItemViewData(
            id: "id1",
            title: "X",
            coordinatesLine: "0.00000, 0.00000",
            latitude: 0,
            longitude: 0
        )
        sut.selectItem(item)
        XCTAssertEqual(received, loc)
    }

    @MainActor
    func testCancelLoad_stopsFetchingIndicator() async {
        let useCase = SlowCancellableFetchUseCase()
        let sut = LocationsListViewModel(useCase: useCase, strings: strings, itemMapping: mapping)
        sut.load()
        let started = await waitUntil(sut) { $0.isFetching }
        XCTAssertTrue(started)
        sut.cancelLoad()
        XCTAssertFalse(sut.isFetching)
    }

    @MainActor
    func testLoad_secondLoadWins() async {
        let useCase = MockFetchLocationsUseCase()
        let first = Location(id: "a", displayName: "A", latitude: 1, longitude: 1)
        let second = Location(id: "b", displayName: "B", latitude: 2, longitude: 2)
        useCase.result = .success([first])
        let sut = LocationsListViewModel(useCase: useCase, strings: strings, itemMapping: mapping)
        sut.load()
        useCase.result = .success([second])
        sut.load()
        let ok = await waitUntil(sut) { vm in
            if case .loaded(let items) = vm.state { return items.map(\.id) == ["b"] }
            return false
        }
        XCTAssertTrue(ok)
    }
}

@MainActor
private func waitUntil(
    _ sut: LocationsListViewModel,
    timeout: TimeInterval = 2,
    _ predicate: @escaping (LocationsListViewModel) -> Bool
) async -> Bool {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
        if predicate(sut) { return true }
        try? await Task.sleep(for: .milliseconds(10))
    }
    return predicate(sut)
}
