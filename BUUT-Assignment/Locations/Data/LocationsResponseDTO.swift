//
//  LocationsResponseDTO.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

struct LocationsResponseDTO: Sendable {
    let locations: [LocationDTO]
}

extension LocationsResponseDTO: Decodable {
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        locations = try container.decode([LocationDTO].self, forKey: .locations)
    }

    private enum CodingKeys: String, CodingKey {
        case locations
    }
}

struct LocationDTO: Sendable {
    let name: String?
    let lat: Double
    let long: Double
}

extension LocationDTO: Decodable {
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        lat = try container.decode(Double.self, forKey: .lat)
        long = try container.decode(Double.self, forKey: .long)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case lat
        case long
    }
}
