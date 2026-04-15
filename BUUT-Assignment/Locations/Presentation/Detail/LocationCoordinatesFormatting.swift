//
//  LocationCoordinatesFormatting.swift
//  BUUT-Assignment
//

import Foundation

/// Formats latitude/longitude for the detail screen (presentation).
protocol LocationCoordinatesFormatting: Sendable {
    func formatCoordinates(latitude: Double, longitude: Double) -> String
}

struct DefaultLocationCoordinatesFormatting: LocationCoordinatesFormatting {
    func formatCoordinates(latitude: Double, longitude: Double) -> String {
        let lat = String(format: "%.6f°", latitude)
        let lon = String(format: "%.6f°", longitude)
        let latHemisphere = latitude >= 0 ? "N" : "S"
        let lonHemisphere = longitude >= 0 ? "E" : "W"
        return "Latitude: \(lat) (\(latHemisphere))\nLongitude: \(lon) (\(lonHemisphere))"
    }
}
