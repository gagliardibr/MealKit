//
//  MealsListCoordinator.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import UIKit

protocol MealsListCoordinatorDelegate: AnyObject {
    func navigateToMealDetail(with meal: Meal)
    func openFilter()
}

final class MealsListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private var mealsListViewModel: MealsListViewModel?

    private let factory: MealsListFactoryProtocol

    init(navigationController: UINavigationController, factory: MealsListFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        let viewController = factory.makeMealsList(delegate: self)

        if let mealsListVC = viewController as? MealsListViewController {
            self.mealsListViewModel = mealsListVC.viewModel // ✅ ESSENCIAL
        }

        navigationController.pushViewController(viewController, animated: true)
    }

}

extension MealsListCoordinator: MealsListCoordinatorDelegate {
    func navigateToMealDetail(with meal: Meal) {
        let viewModel = MealDetailViewModel(meal: meal)
        let viewController = MealDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openFilter() {
        guard let viewModel = mealsListViewModel?.filtersViewModel else { return }
        
        let filterVC = FiltersViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: filterVC)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        navigationController.present(nav, animated: true)
    }
}
