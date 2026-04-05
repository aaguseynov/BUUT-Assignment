//
//  LocationListItemViewData.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// UI-facing row model for the locations list (produced by the view model).
struct LocationListItemViewData: Sendable {
    let id: String
    let title: String
    /// Formatted coordinates for display next to / under the title.
    let coordinatesLine: String
    let latitude: Double
    let longitude: Double
}

nonisolated extension LocationListItemViewData: Equatable {
    static func == (lhs: LocationListItemViewData, rhs: LocationListItemViewData) -> Bool {
        lhs.id == rhs.id
    }
}

nonisolated extension LocationListItemViewData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
