//
//  MainFlowFactory.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import UIKit

protocol MainFlowFactory {
    func makeMainCoordinator(navigation: UINavigationController) -> Coordinator
}
