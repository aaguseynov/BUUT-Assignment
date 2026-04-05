//
//  LocationsListViewModel.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

final class LocationsListViewModel {
    private(set) var state: LocationsListState = .loading {
        didSet { onStateChange?() }
    }

    /// True while a fetch is in flight (initial load or pull-to-refresh).
    private(set) var isFetching = false {
        didSet { onStateChange?() }
    }

    var onStateChange: (() -> Void)?

    /// Set by the composition root; delivers the selected domain model (coordinator stays free of view-data mapping).
    var onLocationDetailRequested: ((Location) -> Void)?

    private let useCase: FetchLocationsUseCaseProtocol
    private let strings: any LocationsListStringsProviding
    private let itemMapping: any LocationsListItemMapping

    var navigationTitle: String { strings.navigationTitle }

    var collectionRenderModel: DiffableCollectionRenderModel<LocationListItemViewData> {
        switch state {
        case .loading:
            return DiffableCollectionRenderModel(
                overlay: .loading(message: strings.loadingMessage),
                items: [],
                isListInteractive: false,
                isFetching: isFetching
            )
        case .loaded(let locations):
            return DiffableCollectionRenderModel(
                overlay: .none,
                items: locations.map { itemMapping.viewData(from: $0) },
                isListInteractive: true,
                isFetching: isFetching
            )
        case .empty:
            return DiffableCollectionRenderModel(
                overlay: .message(strings.emptyMessage),
                items: [],
                isListInteractive: true,
                isFetching: isFetching
            )
        case .failed(let message):
            return DiffableCollectionRenderModel(
                overlay: .error(message: message, retryButtonTitle: strings.retryTitle),
                items: [],
                isListInteractive: true,
                isFetching: isFetching
            )
        }
    }

    init(
        useCase: FetchLocationsUseCaseProtocol,
        strings: any LocationsListStringsProviding,
        itemMapping: any LocationsListItemMapping
    ) {
        self.useCase = useCase
        self.strings = strings
        self.itemMapping = itemMapping
    }

    func load() {
        Task { await performLoad() }
    }

    func selectItem(_ item: LocationListItemViewData) {
        guard case .loaded(let locations) = state,
              let location = locations.first(where: { $0.id == item.id })
        else { return }
        onLocationDetailRequested?(location)
    }

    private func performLoad() async {
        let keepListOrEmptyVisible: Bool = {
            switch state {
            case .loaded, .empty: true
            case .loading, .failed: false
            }
        }()

        if !keepListOrEmptyVisible {
            state = .loading
        }

        isFetching = true

        do {
            let items = try await useCase.execute()
            isFetching = false
            state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            isFetching = false
            state = .failed(FetchErrorFormatting.userMessage(for: error))
        }
    }
}
