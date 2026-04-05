//
//  ApplicationCoordinator.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

final class ApplicationCoordinator: RootCoordinator {
    private weak var window: UIWindow?

    init(window: UIWindow) {
        super.init()
        self.window = window
    }

    override func assemblies() -> [Assembly] {
        [AppAssembly()]
    }

    override func start() {
        guard let window else { return }

        let navigationController = UINavigationController()
        let locationsCoordinator = LocationsFlowCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        coordinate(to: locationsCoordinator)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
