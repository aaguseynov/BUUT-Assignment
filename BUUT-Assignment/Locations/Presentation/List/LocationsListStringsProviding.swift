//
//  LocationsListStringsProviding.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Copy / localization for the locations list screen (SRP: strings separate from state logic).
protocol LocationsListStringsProviding: Sendable {
    var navigationTitle: String { get }
    var loadingMessage: String { get }
    var emptyMessage: String { get }
    var retryTitle: String { get }
}

struct DefaultLocationsListStrings: LocationsListStringsProviding {
    var navigationTitle: String { "Locations" }
    var loadingMessage: String { "Loading locations…" }
    var emptyMessage: String { "No locations" }
    var retryTitle: String { "Retry" }
}
