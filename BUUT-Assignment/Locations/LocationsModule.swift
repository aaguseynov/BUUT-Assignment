//
//  LocationsModule.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

/// Data and commands flowing **into** the feature from the parent (coordinator, tests). Extend when parent-driven reload, filters, or deeplinks are needed.
struct LocationsModuleInput {
    static let `default` = LocationsModuleInput()
    init() {}
}

/// Events and signals flowing **out** of the feature to the parent. Implemented by the list view model so `module.output` and presentation share one object.
protocol LocationsModuleOutput: AnyObject {
    /// User chose a row; parent should navigate (e.g. push detail).
    var onLocationDetailRequested: ((Location) -> Void)? { get set }
}

final class LocationsModule: BaseModule<LocationsModuleInput, LocationsModuleOutput> {
    /// Builds the locations list module when you already have a view model (e.g. tests). `viewModel` is also the module **output**.
    init(
        viewModel: LocationsListViewModelProtocol & LocationsModuleOutput,
        input: LocationsModuleInput = .default
    ) {
        let viewController = LocationsListViewController(viewModel: viewModel)
        super.init(view: viewController, input: input, output: viewModel)
    }
}
