//
//  FilterCell.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import UIKit

final class FilterCell: UICollectionViewCell {
    static let reuseIdentifier = "FilterCell"

    private let titleLabel = PaddingLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        updateStyle(isSelected: isSelected)
    }

    private func updateStyle(isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = DesignSystem.Colors.primaryColor
            titleLabel.textColor = .white
            contentView.layer.borderColor = UIColor.clear.cgColor
        } else {
            contentView.backgroundColor = UIColor.systemBackground
            titleLabel.textColor = .label
            contentView.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
}

// MARK: - ViewCode

extension FilterCell: ViewCode {
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func setupStyle() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.clipsToBounds = true
        backgroundColor = .clear

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityIdentifier = "filterCell"
    }

    func setupNavigation() {}
    func bindViewModel() {}
}

