//
//  Assembly.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

public protocol Assembly {
    func assemble(into container: DIContainer)
}

extension DIContainer {
    public func apply(assemblies: [Assembly]) {
        assemblies.forEach { $0.assemble(into: self) }
    }
}
