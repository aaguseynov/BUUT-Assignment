//
//  LocationsRepository.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation
import LightweightNetworking

/// Fetches remote JSON and maps into domain models (Data layer).
final class LocationsRepository: LocationsRepositoryProtocol {
    private let networkService: any NetworkService
    private let mapper: any LocationMapping

    init(networkService: any NetworkService, mapper: any LocationMapping) {
        self.networkService = networkService
        self.mapper = mapper
    }

    func fetchLocations() async throws -> [Location] {
        try Task.checkCancellation()
        let response = try await networkService.request(LocationsEndpoint())
        try Task.checkCancellation()
        return response.locations.map { mapper.map(dto: $0) }
    }
}
