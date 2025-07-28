//
//  MealsListViewModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation
import Combine

final class MealsListViewModel {
    enum ViewState {
        case loading
        case success
        case empty
        case error(String)
    }

    // MARK: - Published Properties
    @Published private(set) var cellViewModels: [MealCellViewModel] = []
    @Published private(set) var state: ViewState = .loading

    // MARK: - Public
    var coordinator: MealsListCoordinatorDelegate?
    var filtersViewModel: FiltersViewModel!
    var onMealsFetched: (() -> Void)?

    // MARK: - Private
    private let service: MealServiceProtocol
    private var currentCategory: String?
    private var allMeals: [Meal] = []
    private var debounceTask: Task<Void, Never>?

    // MARK: - Init
    init(service: MealServiceProtocol) {
        self.service = service
        self.filtersViewModel = FiltersViewModel()
        self.filtersViewModel.delegate = self
    }

    // MARK: - Data Loading
    func fetchMeals() {
        state = .loading
        Task {
            await performMealFetch(for: currentCategory ?? String())
        }
    }

    func fetchMealsDebounced(for search: String) {
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 400_000_000)

                // Verifica se a task não foi cancelada durante o sleep
                try Task.checkCancellation()

                await self?.performMealFetch(for: search)
            } catch {
                // Task foi cancelada — ignore, não é erro real de fetch
                return
            }
        }
    }

    private func performMealFetch(for query: String) async {
        do {
            let meals = try await service.fetchMeals(for: query)
            self.allMeals = meals
            self.cellViewModels = meals.map(MealCellViewModel.init)
            self.state = meals.isEmpty ? .empty : .success
            self.onMealsFetched?()
        } catch let error as MealServiceError {
            self.state = .error(error.message)
        } catch {
            self.state = .error("Unexpected error: \(error.localizedDescription)")
        }
    }

    // MARK: - Selection
    func didSelectMeal(at index: Int) {
        guard index < allMeals.count else { return }
        let meal = allMeals[index]
        coordinator?.navigateToMealDetail(with: meal)
    }

    // MARK: - Filters
    func applyFilters(_ filters: [String]) {
        currentCategory = filters.first
        fetchMeals()
    }

    func didTapFilter() {
        coordinator?.openFilter()
    }
}

// MARK: - FiltersViewModelDelegate
extension MealsListViewModel: FiltersViewModelDelegate {
    func didApplyMealFilters(_ filters: [String]) {
        applyFilters(filters)
    }
}
