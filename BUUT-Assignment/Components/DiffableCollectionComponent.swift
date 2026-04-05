//
//  DiffableCollectionComponent.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

/// Owns a `UICollectionView` with diffable data source; not a `UIView` — embed `collectionView` in a parent.
final class DiffableCollectionComponent<Item: Hashable & Sendable>: NSObject, UICollectionViewDelegate where Item: Equatable {

    var onSelectItem: ((Item) -> Void)?
    var onRetry: (() -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = backgroundColor
        cv.alwaysBounceVertical = true
        cv.refreshControl = refreshControl
        cv.delegate = self
        return cv
    }()
    
    private let refreshControl = UIRefreshControl()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>?
    
    private let backgroundColor: UIColor
    private let layout: UICollectionViewLayout
    
    private let cellProvider: (UICollectionView, IndexPath, Item) -> UICollectionViewCell
    private let overlayBuilder: any DiffableCollectionOverlayBuilding

    init(
        layout: UICollectionViewLayout,
        backgroundColor: UIColor = .systemGroupedBackground,
        overlayBuilder: any DiffableCollectionOverlayBuilding = DefaultDiffableCollectionOverlayBuilder(),
        cellProvider: @escaping (UICollectionView, IndexPath, Item) -> UICollectionViewCell
    ) {
        self.cellProvider = cellProvider
        self.overlayBuilder = overlayBuilder
        self.backgroundColor = backgroundColor
        self.layout = layout
        super.init()
        dataSource = UICollectionViewDiffableDataSource<Int, Item>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            guard let self else {
                return UICollectionViewCell()
            }
            return self.cellProvider(collectionView, indexPath, item)
        }
    }

    func setRefreshAction(_ action: UIAction) {
        refreshControl.removeTarget(nil, action: nil, for: .valueChanged)
        refreshControl.addAction(action, for: .valueChanged)
    }

    func render(_ model: DiffableCollectionRenderModel<Item>) {
        if !model.isFetching {
            refreshControl.endRefreshing()
        }

        switch model.overlay {
        case .none:
            collectionView.backgroundView = nil
        case .loading(let message):
            collectionView.backgroundView = overlayBuilder.makeLoadingOverlay(message: message)
        case .message(let text):
            collectionView.backgroundView = overlayBuilder.makeMessageOverlay(text: text)
        case .error(let message, let retryTitle):
            let handler = onRetry
            collectionView.backgroundView = overlayBuilder.makeErrorOverlay(
                message: message,
                retryTitle: retryTitle
            ) {
                handler?()
            }
        }

        collectionView.isUserInteractionEnabled = model.isListInteractive

        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(model.items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        onSelectItem?(item)
    }
    
    func setupSuperview(root view: UIView) {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
