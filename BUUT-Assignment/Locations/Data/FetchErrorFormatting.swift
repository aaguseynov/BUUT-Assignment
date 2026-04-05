//
//  FetchErrorFormatting.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 06/04/2026.
//

import Foundation
import LightweightNetworking

enum FetchErrorFormatting {
    /// `NetworkError` → `errorDescription`.
    static func userMessage(for error: Error) -> String {
        if let network = error as? NetworkError {
            return network.errorDescription ?? "Unknown error"
        }
        return error.localizedDescription
    }
}
