//
//  LocationDetailViewModel.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

final class LocationDetailViewModel: LocationDetailViewModelProtocol {
    let navigationTitle: String
    let coordinatesText: String
    let annotationTitle: String
    let latitude: Double
    let longitude: Double
    let mapLatitudinalMeters: Double
    let mapLongitudinalMeters: Double
    let backButtonTitle: String

    /// Wired by the composition root (coordinator); the view model invokes this when the user closes the screen.
    var onCloseRequested: (() -> Void)?

    init(location: Location, coordinatesFormatting: any LocationCoordinatesFormatting) {
        navigationTitle = location.displayName
        annotationTitle = location.displayName
        latitude = location.latitude
        longitude = location.longitude
        coordinatesText = coordinatesFormatting.formatCoordinates(
            latitude: location.latitude,
            longitude: location.longitude
        )
        mapLatitudinalMeters = 50_000
        mapLongitudinalMeters = 50_000
        backButtonTitle = "Back"
    }

    func userDidRequestClose() {
        onCloseRequested?()
    }
}
