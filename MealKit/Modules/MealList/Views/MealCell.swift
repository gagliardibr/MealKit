//
//  MealCell.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import UIKit
import SDWebImage

final class MealCell: UITableViewCell {
    static let reuseIdentifier = "MealCell"

    private let mealImageView = UIImageView()
    private let mealTitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mealImageView.image = nil
        mealTitleLabel.text = nil
    }

    func configure(with viewModel: MealCellViewModel) {
        mealTitleLabel.text = viewModel.title
        mealImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"))
    }
}

// MARK: - ViewCode
extension MealCell: ViewCode {
    func addSubviews() {
        contentView.addSubview(mealImageView)
        contentView.addSubview(mealTitleLabel)
    }

    func setupConstraints() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mealImageView.widthAnchor.constraint(equalToConstant: 60),
            mealImageView.heightAnchor.constraint(equalToConstant: 60),
            mealImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            mealTitleLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 16),
            mealTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mealTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func setupStyle() {
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.layer.cornerRadius = 8
        mealImageView.clipsToBounds = true
        mealImageView.accessibilityIdentifier = "mealImageView"

        mealTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        mealTitleLabel.numberOfLines = 0
        mealTitleLabel.accessibilityIdentifier = "mealTitleLabel"
    }

    func bindViewModel() {}
    func setupAccessibility() {}
    func setupNavigation() {}
}
