//
//  LocationsFlowCoordinator.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

final class LocationsFlowCoordinator: DIAssemblyResultCoordinator<Void> {
    private weak var navigationController: UINavigationController?

    override func assemblies() -> [any Assembly] {
        [LocationsAssembly()]
    }

    init(
        navigationController: UINavigationController,
        container: DIContainer
    ) {
        self.navigationController = navigationController
        super.init(container: container)
    }

    override func start() {
        guard let navigationController else { return }
        let viewModel = LocationsListViewModel(
            useCase: container.resolve(FetchLocationsUseCaseProtocol.self),
            strings: container.resolve(LocationsListStringsProviding.self),
            itemMapping: container.resolve(LocationsListItemMapping.self)
        )
        viewModel.onLocationDetailRequested = { [weak self] location in
            self?.presentLocationDetail(for: location)
        }
        let locationsModule = LocationsModule(viewModel: viewModel)
        navigationController.setViewControllers([locationsModule.view], animated: false)
    }

    private func presentLocationDetail(for location: Location) {
        let detailViewModel = LocationDetailViewModel(location: location)
        detailViewModel.onCloseRequested = { [navigationController] in
            navigationController?.popViewController(animated: true)
        }

        let detail = LocationDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detail, animated: true)
    }
}
