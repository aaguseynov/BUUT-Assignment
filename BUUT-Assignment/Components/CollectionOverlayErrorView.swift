//
//  CollectionOverlayErrorView.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

/// Error state with symbol, message, and a bordered prominent retry button.
final class CollectionOverlayErrorView: UIView {
    init(message: String, retryTitle: String, onRetry: @escaping () -> Void) {
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: CollectionOverlayLayoutMetrics.symbolPointSize,
            weight: .medium,
            scale: .medium
        )
        let symbolView = UIImageView(
            image: UIImage(systemName: "exclamationmark.triangle.fill", withConfiguration: symbolConfig)
        )
        symbolView.tintColor = .secondaryLabel
        symbolView.contentMode = .scaleAspectFit
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.setContentHuggingPriority(.required, for: .vertical)
        symbolView.isAccessibilityElement = false

        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        var buttonConfig = UIButton.Configuration.borderedProminent()
        buttonConfig.title = retryTitle
        buttonConfig.buttonSize = .large
        buttonConfig.cornerStyle = .large
        let button = UIButton(configuration: buttonConfig)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { _ in onRetry() }, for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [symbolView, label, button])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = CollectionOverlayLayoutMetrics.symbolToTextSpacing
        stack.setCustomSpacing(CollectionOverlayLayoutMetrics.textToButtonSpacing, after: label)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            symbolView.heightAnchor.constraint(equalToConstant: 48),

            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: CollectionOverlayLayoutMetrics.horizontalInset
            ),
            stack.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -CollectionOverlayLayoutMetrics.horizontalInset
            ),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
