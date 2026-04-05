//
//  LocationDetailViewModel.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

final class LocationDetailViewModel {
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

    init(location: Location) {
        navigationTitle = location.displayName
        annotationTitle = location.displayName
        latitude = location.latitude
        longitude = location.longitude
        coordinatesText = Self.formatCoordinates(latitude: location.latitude, longitude: location.longitude)
        mapLatitudinalMeters = 50_000
        mapLongitudinalMeters = 50_000
        backButtonTitle = "Back"
    }

    func userDidRequestClose() {
        onCloseRequested?()
    }

    private static func formatCoordinates(latitude: Double, longitude: Double) -> String {
        let lat = String(format: "%.6f°", latitude)
        let lon = String(format: "%.6f°", longitude)
        let latHemisphere = latitude >= 0 ? "N" : "S"
        let lonHemisphere = longitude >= 0 ? "E" : "W"
        return "Latitude: \(lat) (\(latHemisphere))\nLongitude: \(lon) (\(lonHemisphere))"
    }
}
