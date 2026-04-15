//
//  LocationsListViewModelProtocol.swift
//  BUUT-Assignment
//

import Foundation

/// Presentation API for the locations list screen. ViewController depends on this protocol, not on a concrete view model implementation.
protocol LocationsListViewModelProtocol: AnyObject {
    var navigationTitle: String { get }
    var collectionRenderModel: DiffableCollectionRenderModel<LocationListItemViewData> { get }
    /// Wire to UI refresh (list component re-renders when state changes).
    var onStateChange: (() -> Void)? { get set }
    func load()
    /// Cancels the in-flight fetch (e.g. pull-to-refresh / reload) without starting a new one.
    func cancelLoad()
    func selectItem(_ item: LocationListItemViewData)
}
