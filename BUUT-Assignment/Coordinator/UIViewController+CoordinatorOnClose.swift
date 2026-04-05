//
//  UIViewController+CoordinatorOnClose.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import ObjectiveC
import UIKit

private var onCloseKey: UInt8 = 0

public extension UIViewController {
    /// Called when the view controller is removed from the hierarchy (`pop` / `dismiss`). Call `installCoordinatorOnCloseSwizzling()` once at app launch.
    var onClose: ResultBlock<Void>? {
        get {
            objc_getAssociatedObject(self, &onCloseKey) as? ResultBlock<Void>
        }
        set {
            objc_setAssociatedObject(self, &onCloseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    static func installCoordinatorOnCloseSwizzling() {
        _ = CoordinatorOnCloseSwizzler.once
    }

    @objc func coord_onClose_viewDidDisappear(_ animated: Bool) {
        coord_onClose_viewDidDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            onClose?(())
        }
    }
}

private enum CoordinatorOnCloseSwizzler {
    static let once: Void = {
        let original = #selector(UIViewController.viewDidDisappear(_:))
        let swizzled = #selector(UIViewController.coord_onClose_viewDidDisappear(_:))
        guard
            let originalMethod = class_getInstanceMethod(UIViewController.self, original),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzled)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
}
