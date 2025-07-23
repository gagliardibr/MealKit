//
//  AppCoordinator.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showMealsList()
    }

    private func showMealsList() {
        let coordinator = MealsListCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
