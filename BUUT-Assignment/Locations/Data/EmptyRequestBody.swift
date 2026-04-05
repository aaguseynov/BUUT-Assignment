//
//  EmptyRequestBody.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// GET endpoints still require an `Encodable` body type in `Endpoint`.
struct EmptyRequestBody: Sendable {}

extension EmptyRequestBody: Encodable {
    nonisolated func encode(to encoder: Encoder) throws {
        _ = encoder.container(keyedBy: UnusedKey.self)
    }

    private enum UnusedKey: CodingKey {
        case unused
    }
}
