//
//  AppCoordinator.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    internal let navigationController: UINavigationController
    internal var childCoordinators: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        let mealsFactory = MealsListFactory()
        let mealsCoordinator = MealsListCoordinator(
            navigationController: navigationController,
            factory: mealsFactory
        )
        childCoordinators.append(mealsCoordinator)
        mealsCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
