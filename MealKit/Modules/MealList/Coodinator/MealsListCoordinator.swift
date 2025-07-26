//
//  MealsListCoordinator.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//


import UIKit

protocol MealsListCoordinating: AnyObject {
    func showMealDetail(meal: Meal)
}

final class MealsListCoordinator: Coordinator, MealsListCoordinating {
    private(set) var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MealsListViewModel()
        viewModel.coordinator = self
        let viewController = MealsListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    func showMealDetail(meal: Meal) {
        let viewModel = MealDetailViewModel(meal: meal)
        let viewController = MealDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
