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
        case idle
        case loading
        case success
        case empty
        case error(String)
    }

    // MARK: - Published Properties
    @Published private(set) var cellViewModels: [MealCellViewModel] = []
    @Published private(set) var state: ViewState = .idle

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
            do {
                let meals = try await service.fetchMeals(for: currentCategory ?? "")
                allMeals = meals
                cellViewModels = meals.map { MealCellViewModel(meal: $0) }
                state = meals.isEmpty ? .empty : .success
                onMealsFetched?()
            } catch let error as MealServiceError {
                state = .error(error.message)
            } catch {
                state = .error("Unexpected error: \(error.localizedDescription)")
            }
        }
    }

    func fetchMealsDebounced(for search: String) {
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 400_000_000) // 0.4 segundos
            guard let self = self else { return }

            do {
                let meals = try await self.service.fetchMeals(for: search)
                self.cellViewModels = meals.map { MealCellViewModel(meal: $0) }
                self.state = meals.isEmpty ? .empty : .success
                self.onMealsFetched?()
            } catch let error as MealServiceError {
                self.state = .error(error.message)
            } catch {
                self.state = .error("Unexpected error: \(error.localizedDescription)")
            }
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
    func didApplyFilters(_ filters: [String]) {
        currentCategory = filters.first
        fetchMeals()
    }
}
