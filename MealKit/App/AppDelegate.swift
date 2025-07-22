//
//  AppDelegate.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: MealsListViewController())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

