//
//  Coordinator.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
