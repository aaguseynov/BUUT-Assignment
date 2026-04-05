//
//  FeatureModule.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

/// Interface implemented by all feature modules.
public protocol FeatureModule: AnyObject {

    associatedtype Input

    associatedtype Output
    
    /// The module’s root view controller.
    var view: UIViewController { get }

    /// Module input (commands / dependencies from outside).
    var input: Input { get }

    /// Module output (callbacks / events to the outside).
    var output: Output { get }
}

/// Default module implementation; concrete modules usually subclass this.
open class BaseModule<Input, Output>: FeatureModule {

    // MARK: - Public
    
    public let view: UIViewController
    public let output: Output
    public let input: Input

    // MARK: - Init
    
    public init(
        view: UIViewController,
        input: Input,
        output: Output
    ) {
        self.view = view
        self.input = input
        self.output = output
    }
}
