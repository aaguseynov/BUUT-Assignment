//
//  LocationsListItemMapping.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Maps domain `Location` to list row view data (presentation boundary).
protocol LocationsListItemMapping: Sendable {
    func viewData(from location: Location) -> LocationListItemViewData
}

struct LocationsListItemMapper: LocationsListItemMapping {
    func viewData(from location: Location) -> LocationListItemViewData {
        LocationListItemViewData(
            id: location.id,
            title: location.displayName,
            coordinatesLine: Self.formatCoordinatesLine(latitude: location.latitude, longitude: location.longitude),
            latitude: location.latitude,
            longitude: location.longitude
        )
    }

    private static func formatCoordinatesLine(latitude: Double, longitude: Double) -> String {
        String(format: "%.5f, %.5f", latitude, longitude)
    }
}
