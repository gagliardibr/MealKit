//
//  MealService.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

protocol MealServiceProtocol {
    func fetchMeals(for search: String) async throws -> [Meal]
    func fetchMealsFiltered(category: String?, area: String?) async throws -> [Meal]
    func clearCache()
}

final class MealService: MealServiceProtocol {
    private let cache = NSCache<NSString, NSArray>()
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchMeals(for search: String) async throws -> [Meal] {
        let key = NSString(string: search)

        if search.isEmpty, let cached = cache.object(forKey: key) as? [Meal] {
            return cached
        }

        let meals = try await fetchMeals(from: .search(search))

        if search.isEmpty {
            cache.setObject(meals as NSArray, forKey: key)
        }

        return meals
    }

    func fetchMealsFiltered(category: String?, area: String?) async throws -> [Meal] {
        async let categoryMeals: [Meal] = {
            if let category = category {
                return try await fetchMeals(from: .filterByCategory(category))
            }
            return []
        }()

        async let areaMeals: [Meal] = {
            if let area = area {
                return try await fetchMeals(from: .filterByArea(area))
            }
            return []
        }()

        let (catMeals, arMeals) = try await (categoryMeals, areaMeals)

        if !catMeals.isEmpty && !arMeals.isEmpty {
            let areaIDs = Set(arMeals.map(\.idMeal))
            return catMeals.filter { areaIDs.contains($0.idMeal) }
        }

        return !catMeals.isEmpty ? catMeals : arMeals
    }

    func clearCache() {
        cache.removeAllObjects()
    }

    // MARK: - Private

    private func fetchMeals(from endpoint: MealEndpoint) async throws -> [Meal] {
        guard let url = endpoint.url else {
            throw MealServiceError.invalidURL
        }

        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(MealsResponse.self, from: data)
        return response.meals ?? []
    }
}
