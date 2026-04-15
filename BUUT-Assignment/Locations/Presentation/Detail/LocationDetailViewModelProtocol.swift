//
//  LocationDetailViewModelProtocol.swift
//  BUUT-Assignment
//

import Foundation

/// Presentation API for the location detail screen. `ViewController` depends on this protocol, not the concrete view model.
protocol LocationDetailViewModelProtocol: AnyObject {
    var navigationTitle: String { get }
    var coordinatesText: String { get }
    var annotationTitle: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var mapLatitudinalMeters: Double { get }
    var mapLongitudinalMeters: Double { get }
    var backButtonTitle: String { get }
    /// Wired by the composition root (coordinator); invoked when the user taps back.
    var onCloseRequested: (() -> Void)? { get set }
    func userDidRequestClose()
}
