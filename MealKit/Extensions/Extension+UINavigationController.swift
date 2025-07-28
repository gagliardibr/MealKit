//
//  Extension+UINavigationController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import UIKit

extension UINavigationController {
    func applyDefaultAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DesignSystem.Colors.primaryColor
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
        navigationBar.prefersLargeTitles = false
    }
}
