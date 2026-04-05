//
//  BaseResultCoordinator.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

public typealias ResultBlock<T> = (T) -> Void

open class BaseResultCoordinator<ResultType> {
    /// Invoked by the coordinator when its flow completes.
    public var onComplete: ResultBlock<ResultType>?

    private let identifier = UUID()

    public private(set) var childCoordinators: [UUID: Any] = [:]

    public init() {}

    /// Starts a child coordinator and retains it until `onComplete`.
    open func coordinate<T>(to coordinator: BaseResultCoordinator<T>) {
        store(coordinator: coordinator)
        let completion = coordinator.onComplete
        coordinator.onComplete = { [weak self, weak coordinator] value in
            completion?(value)
            if let coordinator {
                self?.free(coordinator: coordinator)
            }
        }
        coordinator.start()
    }

    open func start() {
        fatalError("start() must be overridden in subclass")
    }

    public func cleanUpChildCoordinators() {
        childCoordinators.removeAll()
    }

    private func store<T>(coordinator: BaseResultCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: BaseResultCoordinator<T>) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
}

public extension BaseResultCoordinator {
    func onCompleteWhenClose(returning value: ResultType) -> ResultBlock<Void> {
        { [weak self] _ in
            self?.onComplete?(value)
        }
    }
}
