//
//  CollectionOverlayLoadingView.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

/// Loading state with a large spinner and caption, similar to Apple list placeholders.
final class CollectionOverlayLoadingView: UIView {
    init(message: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = message
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [indicator, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = CollectionOverlayLayoutMetrics.symbolToTextSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
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
