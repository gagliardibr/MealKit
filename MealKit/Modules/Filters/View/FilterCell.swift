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
    private let padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // Ajusta tamanho baseado no conteúdo, mantendo fixo
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        attributes.size = contentView.systemLayoutSizeFitting(targetSize,
                                                              withHorizontalFittingPriority: .defaultLow,
                                                              verticalFittingPriority: .required)
        return attributes
    }

    func configure(with title: String, selected: Bool) {
        titleLabel.text = title
        isSelected = selected
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.clipsToBounds = true
        backgroundColor = .clear

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.top),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding.bottom),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.left),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding.right)
        ])

        updateStyle()
    }

    private func updateStyle() {
        if isSelected {
            contentView.backgroundColor = DesignSystem.Colors.primaryBackground
            titleLabel.textColor = .white
            contentView.layer.borderColor = UIColor.clear.cgColor
        } else {
            contentView.backgroundColor = UIColor.systemBackground
            titleLabel.textColor = .label
            contentView.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
}
