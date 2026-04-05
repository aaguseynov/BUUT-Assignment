//
//  CollectionOverlayMessageView.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

/// Empty or informational state in the style of system empty views (symbol + text).
final class CollectionOverlayMessageView: UIView {
    init(text: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: CollectionOverlayLayoutMetrics.symbolPointSize,
            weight: .medium,
            scale: .medium
        )
        let symbolView = UIImageView(image: UIImage(systemName: "mappin.slash", withConfiguration: symbolConfig))
        symbolView.tintColor = .tertiaryLabel
        symbolView.contentMode = .scaleAspectFit
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.setContentHuggingPriority(.required, for: .vertical)
        symbolView.isAccessibilityElement = false

        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [symbolView, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = CollectionOverlayLayoutMetrics.symbolToTextSpacing
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
