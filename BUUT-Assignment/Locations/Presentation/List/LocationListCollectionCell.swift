//
//  LocationListCollectionCell.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import UIKit

final class LocationListCollectionCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }
            animatePress(isPressed: isHighlighted)
        }
    }

    private var pressAnimator: UIViewPropertyAnimator?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .natural
        label.numberOfLines = 2
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        // Share fixed cell height with coordinates: title yields vertical space first.
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let coordinatesLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let disclosureIndicator: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = .tertiaryLabel
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        [titleLabel, coordinatesLabel, disclosureIndicator].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            disclosureIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: disclosureIndicator.leadingAnchor, constant: -10),

            coordinatesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            coordinatesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            coordinatesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            coordinatesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: LocationListItemViewData) {
        titleLabel.text = item.title
        coordinatesLabel.text = item.coordinatesLine
        accessibilityLabel = "\(item.title), \(item.coordinatesLine)"
        accessibilityTraits = .button
        accessibilityHint = "Opens the map for this location"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pressAnimator?.stopAnimation(true)
        pressAnimator = nil
        contentView.transform = .identity
        contentView.alpha = 1
        titleLabel.text = nil
        coordinatesLabel.text = nil
        accessibilityLabel = nil
        accessibilityTraits = []
        accessibilityHint = nil
    }

    private func animatePress(isPressed: Bool) {
        pressAnimator?.stopAnimation(false)
        pressAnimator?.finishAnimation(at: .current)
        pressAnimator = nil

        let duration: TimeInterval = isPressed ? 0.22 : 0.4
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        animator.addAnimations { [weak self] in
            guard let self else { return }
            if isPressed {
                self.contentView.transform = CGAffineTransform(scaleX: 0.985, y: 0.985)
                self.contentView.alpha = 0.96
            } else {
                self.contentView.transform = .identity
                self.contentView.alpha = 1
            }
        }
        animator.addCompletion { [weak self] (_ position: UIViewAnimatingPosition) in
            if self?.pressAnimator === animator {
                self?.pressAnimator = nil
            }
        }
        pressAnimator = animator
        animator.startAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let titleWidth = titleLabel.bounds.width
        if titleWidth > 0, titleLabel.preferredMaxLayoutWidth != titleWidth {
            titleLabel.preferredMaxLayoutWidth = titleWidth
        }
        let coordsWidth = coordinatesLabel.bounds.width
        if coordsWidth > 0, coordinatesLabel.preferredMaxLayoutWidth != coordsWidth {
            coordinatesLabel.preferredMaxLayoutWidth = coordsWidth
        }
    }
}
