//
//  LocationMapper.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Maps location DTOs to domain models (stateless; registered weak in the Locations module assembly).
final class LocationMapper: LocationMapping, @unchecked Sendable {
    init() {}

    func map(dto: LocationDTO) -> Location {
        let trimmed = dto.name?.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName: String
        if let trimmed, !trimmed.isEmpty {
            displayName = trimmed
        } else {
            displayName = "Unknown location"
        }
        let id = "\(dto.lat)_\(dto.long)_\(displayName)"
        return Location(
            id: id,
            displayName: displayName,
            latitude: dto.lat,
            longitude: dto.long
        )
    }
}
