//
//  FilterHeaderView.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import UIKit

final class FilterHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "FilterHeaderView"

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

extension FilterHeaderView: ViewCode {
    func addSubviews() {
        addSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func setupStyle() {
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
    }

    func bindViewModel() {}
    func setupAccessibility() {}
    func setupNavigation() {}
}

