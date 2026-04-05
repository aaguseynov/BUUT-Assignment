//
//  LocationDetailViewController.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import MapKit
import UIKit

final class LocationDetailViewController: UIViewController {

    private let coordinatesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let base = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: base)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    private var didApplyMapRegion = false

    private let viewModel: LocationDetailViewModel
    
    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.navigationTitle
        coordinatesLabel.text = viewModel.coordinatesText

        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: viewModel.backButtonTitle,
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyMapRegionIfReady()
    }
    
    private func setupSubviews() {
        [coordinatesLabel, mapView].forEach {
            view.addSubview($0)
        }

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            coordinatesLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            coordinatesLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            coordinatesLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),

            mapView.topAnchor.constraint(equalTo: coordinatesLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        let coordinate = CLLocationCoordinate2D(
            latitude: viewModel.latitude,
            longitude: viewModel.longitude
        )

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = viewModel.annotationTitle

        mapView.addAnnotation(annotation)
    }

    @objc private func backTapped() {
        viewModel.userDidRequestClose()
    }

    private func applyMapRegionIfReady() {
        guard !didApplyMapRegion,
              mapView.bounds.width > 1, mapView.bounds.height > 1
        else { return }
        let center = CLLocationCoordinate2D(
            latitude: viewModel.latitude,
            longitude: viewModel.longitude
        )

        let isCoordinatesValid = CLLocationCoordinate2DIsValid(center)
        guard isCoordinatesValid else { return }
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: viewModel.mapLatitudinalMeters,
            longitudinalMeters: viewModel.mapLongitudinalMeters
        )
        mapView.setRegion(region, animated: false)
        didApplyMapRegion = true
    }
}
