//
//  UINavigationController+Coordinator.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

public extension UINavigationController {
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        performCompletionAfterTransition(completion)
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        performCompletionAfterTransition(completion)
    }

    func setViewControllers(_ viewControllers: UIViewController..., animated: Bool = true) {
        setViewControllers(viewControllers, animated: animated)
    }

    private func performCompletionAfterTransition(_ completion: @escaping () -> Void) {
        guard let transitionCoordinator else {
            completion()
            return
        }
        transitionCoordinator.animate(alongsideTransition: nil) { context in
            if !context.isCancelled {
                completion()
            }
        }
    }
}
