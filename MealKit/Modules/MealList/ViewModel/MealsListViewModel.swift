//
//  MealsListViewModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

final class MealsListViewModel {
    var meals: [Meal] = []
    var onMealsFetched: (() -> Void)?
    weak var coordinator: MealsListCoordinating?

    private let mealService = MealService()
    private var cachedMeals: [Meal] = []

    private var selectedFilters: [String] = []

    func fetchMeals(searchTerm: String = "") {
        Task {
            do {
                let result = try await mealService.fetchMeals(for: searchTerm)
                self.cachedMeals = result
                self.meals = applyFiltersToMeals(result)
                onMealsFetched?()
            } catch {
                print("Error fetching meals: \(error)")
            }
        }
    }

    func didSelectMeal(at index: Int) {
        let selectedMeal = meals[index]
        coordinator?.showMealDetail(meal: selectedMeal)
    }

    func clearCache() {
        cachedMeals = []
        meals = []
    }

    func applyFilters(_ filters: [String]) {
        selectedFilters = filters
        self.meals = applyFiltersToMeals(cachedMeals)
        onMealsFetched?()
    }

    private func applyFiltersToMeals(_ meals: [Meal]) -> [Meal] {
        guard !selectedFilters.isEmpty else { return meals }

        return meals.filter { meal in
            selectedFilters.contains(meal.strCategory ?? "") ||
            selectedFilters.contains(meal.strArea ?? "")
        }
    }
}
