//
//  MealsListViewModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

final class MealsListViewModel {
    // MARK: - Outputs

    var meals: [Meal] = []
    var onMealsFetched: (() -> Void)?
    weak var coordinator: MealsListCoordinating?

    // MARK: - Dependencies

    private let mealService = MealService()

    // MARK: - State

    private var cachedMeals: [Meal] = []
    private var selectedFilters: [String] = []
    private var searchTask: Task<Void, Error>?

    private let debounceInterval: UInt64 = 300_000_000 // 300ms

    lazy var filtersViewModel: FiltersViewModel = {
        let vm = FiltersViewModel()
        vm.delegate = self
        return vm
    }()

    // MARK: - Public Methods

    func fetchMeals(searchTerm: String = "") {
        cancelSearchTask()

        Task {
            do {
                let meals = try await mealService.fetchMeals(for: searchTerm)
                self.cachedMeals = meals
                self.meals = self.applyFilters(to: meals)
                self.onMealsFetched?()
            } catch {
                print("Error fetching meals: \(error)")
            }
        }
    }

    func fetchMealsDebounced(for term: String) {
        cancelSearchTask()

        searchTask = Task {
            try await Task.sleep(nanoseconds: debounceInterval)
            guard !Task.isCancelled else { return }

            fetchMeals(searchTerm: term)
        }
    }

    func applyFilters(_ filters: [String]) {
        selectedFilters = filters
        meals = applyFilters(to: cachedMeals)
        onMealsFetched?()
    }

    func didSelectMeal(at index: Int) {
        let selectedMeal = meals[index]
        coordinator?.showMealDetail(meal: selectedMeal)
    }

    func clearCache() {
        cancelSearchTask()
        cachedMeals = []
        meals = []
        selectedFilters = []
    }

    // MARK: - Private Helpers

    private func cancelSearchTask() {
        searchTask?.cancel()
        searchTask = nil
    }

    private func applyFilters(to meals: [Meal]) -> [Meal] {
        guard !selectedFilters.isEmpty else { return meals }

        return meals.filter { meal in
            selectedFilters.contains(meal.strCategory ?? "") ||
            selectedFilters.contains(meal.strArea ?? "")
        }
    }
}

// MARK: - FiltersViewModelDelegate

extension MealsListViewModel: FiltersViewModelDelegate {
    func didApplyFilters(_ filters: [String]) {
        applyFilters(filters)
    }
}
