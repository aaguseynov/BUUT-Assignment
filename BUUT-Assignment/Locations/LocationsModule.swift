//
//  LocationsModule.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

struct LocationsModuleInput {}

class LocationsModuleOutput {
    init() {}
}

final class LocationsModule: BaseModule<LocationsModuleInput, LocationsModuleOutput> {
    /// Builds the locations list module when you already have a view model (e.g. tests).
    init(
        viewModel: LocationsListViewModel,
        input: LocationsModuleInput = LocationsModuleInput(),
        output: LocationsModuleOutput = LocationsModuleOutput()
    ) {
        let moduleOutput = output
        let viewController = LocationsListViewController(viewModel: viewModel)
        super.init(view: viewController, input: input, output: moduleOutput)
    }
}
