//
//  MealsListViewModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

final class MealsListViewModel {
    var meals: [Meal] = []
    var coordinator: MealsListCoordinator?
    var onMealsFetched: (() -> Void)?

    func fetchMeals(searchTerm: String = "") {
        Task {
            do {
                let result = try await MealService().fetchMeals(for: searchTerm)
                self.meals = result
                onMealsFetched?()
            } catch {
                print("Erro ao buscar refeições: \(error)")
            }
        }
    }

    func didSelectMeal(at index: Int) {
        let selectedMeal = meals[index]
        print(selectedMeal)
    }
}
