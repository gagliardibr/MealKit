//
//  MealsListViewController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import UIKit
import SDWebImage

final class MealsListViewController: UIViewController {
    private let viewModel: MealsListViewModel
    private let tableView = UITableView()

    init(viewModel: MealsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupAccessibility()
        setupNavigation()
        bindViewModel()
        viewModel.fetchMeals()
    }
}

// MARK: - ViewCode Setup
extension MealsListViewController: ViewCode {
    func addSubviews() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupStyle() {
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
        tableView.rowHeight = 100
        tableView.separatorStyle = .singleLine
    }

    func bindViewModel() {
        viewModel.onMealsFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func setupAccessibility() {
        tableView.accessibilityLabel = "Lista de refeições"
        tableView.accessibilityIdentifier = "mealsTableView"
    }

    func setupNavigation() {
        title = "MealKit"
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MealsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
            return UITableViewCell()
        }
        let meal = viewModel.meals[indexPath.row]
        cell.configure(with: meal)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMeal(at: indexPath.row)
    }
}
