//
//  LocationsRepositoryProtocol.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Abstraction over location data sources (Dependency Inversion).
protocol LocationsRepositoryProtocol: Sendable {
    func fetchLocations() async throws -> [Location]
}
