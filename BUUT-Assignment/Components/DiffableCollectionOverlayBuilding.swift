//
//  DiffableCollectionOverlayBuilding.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

/// Builds background overlays for `DiffableCollectionComponent` (Open/Closed: new styles without editing the component).
protocol DiffableCollectionOverlayBuilding: AnyObject {
    func makeLoadingOverlay(message: String) -> UIView
    func makeMessageOverlay(text: String) -> UIView
    func makeErrorOverlay(message: String, retryTitle: String, onRetry: @escaping () -> Void) -> UIView
}


final class DefaultDiffableCollectionOverlayBuilder: DiffableCollectionOverlayBuilding {
    func makeLoadingOverlay(message: String) -> UIView {
        CollectionOverlayLoadingView(message: message)
    }

    func makeMessageOverlay(text: String) -> UIView {
        CollectionOverlayMessageView(text: text)
    }

    func makeErrorOverlay(message: String, retryTitle: String, onRetry: @escaping () -> Void) -> UIView {
        CollectionOverlayErrorView(message: message, retryTitle: retryTitle, onRetry: onRetry)
    }
}
