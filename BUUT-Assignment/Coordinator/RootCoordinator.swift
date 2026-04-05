//
//  RootCoordinator.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

open class RootCoordinator: DIAssemblyResultCoordinator<Void> {

    /// Uses a preconfigured container; does not call `apply(assemblies:)` again.
    public override init(container: DIContainer = DIContainer()) {
        super.init(container: container)
        container.apply(assemblies: assemblies())
    }

    public func removeAll() {
        container.removeAll()
    }
}
