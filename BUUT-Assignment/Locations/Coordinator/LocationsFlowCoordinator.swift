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
        let locationsModule = LocationsModule(viewModel: viewModel)
        locationsModule.output.onLocationDetailRequested = { [weak self] location in
            self?.startDetailChildFlow(for: location)
        }
        navigationController.setViewControllers([locationsModule.view], animated: false)
    }

    private func startDetailChildFlow(for location: Location) {
        guard let navigationController else { return }
        let detailFlow = LocationDetailFlowCoordinator(
            navigationController: navigationController,
            container: container,
            location: location
        )
        coordinate(to: detailFlow)
    }
}
