
//
//  MealAPI.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import Foundation
@testable import MealKit

final class MockMealService: MealServiceProtocol {
    var mealsToReturn: [Meal] = []
    var shouldThrowError: Bool = false

    func fetchMeals(for search: String) async throws -> [Meal] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mealsToReturn
    }

    func fetchMealsFiltered(category: String?, area: String?) async throws -> [Meal] {
        return []
    }

    func clearCache() {}
}
