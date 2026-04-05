//
//  Location.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Domain model for a geographic location (independent of API shape).
struct Location: Sendable, Identifiable {
    let id: String
    let displayName: String
    let latitude: Double
    let longitude: Double
}

nonisolated extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

nonisolated extension Location: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
