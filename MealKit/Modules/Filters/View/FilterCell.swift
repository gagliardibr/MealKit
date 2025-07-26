//
//  FilterCardCell.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import UIKit

final class FilterCell: UICollectionViewCell {
    static let reuseIdentifier = "FilterCell"

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemRed : .systemGray5
            titleLabel.textColor = isSelected ? .white : .label
        }
    }

    func configure(with text: String, selected: Bool) {
        titleLabel.text = text
        isSelected = selected
    }

    private func setupUI() {
        layer.cornerRadius = 16
        backgroundColor = .systemGray5
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
