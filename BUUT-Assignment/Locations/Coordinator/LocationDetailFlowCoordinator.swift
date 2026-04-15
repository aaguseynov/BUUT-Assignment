//
//  LocationDetailFlowCoordinator.swift
//  BUUT-Assignment
//

import UIKit

/// Child flow for a single location’s detail screen. Completion is driven by `UIViewController.onClose` after pop (back button or interactive pop).
///
final class LocationDetailFlowCoordinator: DIAssemblyResultCoordinator<Void> {
    private weak var navigationController: UINavigationController?
    private let location: Location

    init(
        navigationController: UINavigationController,
        container: DIContainer,
        location: Location
    ) {
        self.navigationController = navigationController
        self.location = location
        super.init(container: container)
    }

    override func start() {
        guard let navigationController else { return }

        let viewModel = LocationDetailViewModel(
            location: location,
            coordinatesFormatting: container.resolve(LocationCoordinatesFormatting.self)
        )
        let detailVC = LocationDetailViewController(viewModel: viewModel)

        viewModel.onCloseRequested = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }

        detailVC.onClose = onCompleteWhenClose(returning: ())

        navigationController.pushViewController(detailVC, animated: true)
    }
}
