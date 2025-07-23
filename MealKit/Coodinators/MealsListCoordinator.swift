//
//  MealsListCoordinator.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//


import UIKit

final class MealsListCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MealsListViewModel()
        let viewController = MealsListViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func showMealDetail(meal: Meal) {
        let detailViewModel = MealDetailViewModel(meal: meal)
        let detailVC = MealDetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
