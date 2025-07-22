//
//  ViewController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import UIKit

class MealsListViewController: UIViewController {
    private let viewModel = MealsListViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        viewModel.fetchMeals()
    }
}

// MARK: - ViewCode
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func setupAccessibility() {
        tableView.accessibilityLabel = "Lista de receitas"
    }

    func setupNavigation() {
        title = "Receitas"
    }
}

// MARK: - UITableViewDataSource

extension MealsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meal = viewModel.meals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = meal.strMeal
        return cell
    }
}
