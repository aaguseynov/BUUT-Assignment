//
//  FetchLocationsUseCase.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Single-responsibility application boundary: load locations for presentation.
protocol FetchLocationsUseCaseProtocol: Sendable {
    func execute() async throws -> [Location]
}

struct FetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    private let repository: LocationsRepositoryProtocol

    init(repository: LocationsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Location] {
        try await repository.fetchLocations()
    }
}
