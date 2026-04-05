//
//  LocationMapping.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Abstraction for DTO → domain mapping (Dependency Inversion in the Data layer).
protocol LocationMapping: Sendable {
    func map(dto: LocationDTO) -> Location
}
