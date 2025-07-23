//
//  MealDetailViewController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

//
//  MealDetailViewController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

//
//  MealDetailViewController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import UIKit
import SDWebImage

final class MealDetailViewController: UIViewController {
    private let viewModel: MealDetailViewModel
    private let imageView = UIImageView()
    private let textView = UITextView()

    init(viewModel: MealDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupNavigation()
        setupAccessibility()
        bindViewModel()
    }
}

// MARK: - ViewCode
extension MealDetailViewController: ViewCode {
    func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(textView)
    }

    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),

            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    func setupStyle() {
        view.backgroundColor = .systemBackground

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        textView.font = .preferredFont(forTextStyle: .body)
        textView.isEditable = false
        textView.isScrollEnabled = true
    }

    func bindViewModel() {
        title = viewModel.meal.strMeal
        imageView.sd_setImage(with: URL(string: viewModel.meal.strMealThumb), placeholderImage: UIImage(systemName: "photo"))
        textView.text = viewModel.meal.strInstructions
    }

    func setupAccessibility() {
        imageView.accessibilityLabel = "Imagem da refeição"
        textView.accessibilityLabel = "Modo de preparo"
        textView.accessibilityIdentifier = "mealInstructionsTextView"
    }

    func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
    }
}
