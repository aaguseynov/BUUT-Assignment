//
//  LocationsEndpoint.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation
import LightweightNetworking

struct LocationsEndpoint: Endpoint {
    typealias Response = LocationsResponseDTO
    typealias Body = EmptyRequestBody

    var baseURL: URL {
        URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main")!
    }
    var path: String { "locations.json" }
    var method: HTTPMethod { .get }
    var body: EmptyRequestBody?
    var timeout: TimeInterval { 10 }

    var headers: [String: String]? {
        [
            "Cache-Control": "no-cache",
            "Pragma": "no-cache",
        ]
    }
}
