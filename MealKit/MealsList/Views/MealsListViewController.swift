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
        tableView.register(MealCell.self, forCellReuseIdentifier: "MealCell")
    }

    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func setupAccessibility() {
        tableView.accessibilityLabel = "Lista de refeições"
    }

    func setupNavigation() {
        title = "MealKit"
    }
}

extension MealsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealCell else {
            return UITableViewCell()
        }
        let meal = viewModel.meals[indexPath.row]
        cell.configure(with: meal)
        return cell
    }
}
