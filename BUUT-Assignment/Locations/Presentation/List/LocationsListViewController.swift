//
//  LocationsListViewController.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

final class LocationsListViewController: UIViewController {
    private let viewModel: LocationsListViewModel
    private let listComponent: DiffableCollectionComponent<LocationListItemViewData>

    init(viewModel: LocationsListViewModel) {
        self.viewModel = viewModel
        let cellRegistration = UICollectionView.CellRegistration<LocationListCollectionCell, LocationListItemViewData> { cell, _, item in
            cell.configure(with: item)
        }
        self.listComponent = DiffableCollectionComponent(
            layout: Self.makeLocationsListLayout()
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        super.init(nibName: nil, bundle: nil)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.navigationTitle
        viewModel.onStateChange = { [weak self] in
            self?.syncFromViewModel()
        }
        syncFromViewModel()
        viewModel.load()
    }
    
    private func setupSubviews() {
        listComponent.setupSuperview(root: view)

        listComponent.setRefreshAction(UIAction { [weak self] _ in
            self?.viewModel.load()
        })

        listComponent.onRetry = { [weak self] in
            self?.viewModel.load()
        }

        listComponent.onSelectItem = { [weak self] item in
            self?.viewModel.selectItem(item)
        }
    }

    private func syncFromViewModel() {
        listComponent.render(viewModel.collectionRenderModel)
    }

    private static func makeLocationsListLayout() -> UICollectionViewLayout {
        let rowHeight: CGFloat = 88
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(rowHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(rowHeight)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
