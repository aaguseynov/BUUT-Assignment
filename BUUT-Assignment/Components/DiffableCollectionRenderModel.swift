//
//  DiffableCollectionRenderModel.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Snapshot for a single-section diffable collection (overlays + items). Configured by the feature layer.
struct DiffableCollectionRenderModel<Item: Hashable & Sendable>: Equatable where Item: Equatable {
    enum Overlay: Equatable {
        case none
        case loading(message: String)
        case message(String)
        case error(message: String, retryButtonTitle: String)
    }

    var overlay: Overlay
    var items: [Item]
    var isListInteractive: Bool
    /// When `false`, the embedded refresh control should end refreshing.
    var isFetching: Bool
}
