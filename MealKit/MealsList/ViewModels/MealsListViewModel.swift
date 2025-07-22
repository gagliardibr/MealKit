//
//  MealsListViewModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

class MealsListViewModel {
    var meals: [Meal] = []
    var onUpdate: (() -> Void)?

    func fetchMeals() {
        Task {
            do {
                let result = try await MealService().fetchMeals(for: "chicken")
                DispatchQueue.main.async {
                    self.meals = result
                    self.onUpdate?()
                }
            } catch {
                print("Erro ao buscar refeições: \(error)")
            }
        }
    }
}
