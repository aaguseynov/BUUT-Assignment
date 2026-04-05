//
//  DIAssemblyResultCoordinator.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

/// Base coordinator backed by `DIContainer`. When a child coordinator starts, a child container
/// is created with this container as parent (same idea as Swinject `Assembler(parentAssembler:)` + `apply`).
open class DIAssemblyResultCoordinator<ResultType>: BaseResultCoordinator<ResultType> {
    public var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }

    /// Assemblies registered only for this coordinator (layered on the parent container).
    open func assemblies() -> [Assembly] {
        []
    }

    open override func coordinate<T>(to coordinator: BaseResultCoordinator<T>) {
        if let coordinator = coordinator as? DIAssemblyResultCoordinator<T> {
            let child = container.makeChild()
            child.apply(assemblies: coordinator.assemblies())
            coordinator.container = child
        }
        super.coordinate(to: coordinator)
    }
}
