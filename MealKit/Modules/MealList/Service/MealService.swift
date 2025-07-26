//
//  MealService.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

import Foundation

final class MealService {
    private let cache = NSCache<NSString, NSArray>()

    func fetchMeals(for search: String) async throws -> [Meal] {
        let key = NSString(string: search)

        // Usa o cache somente se a busca for vazia
        if search.isEmpty, let cachedMeals = cache.object(forKey: key) as? [Meal] {
            return cachedMeals
        }

        let encoded = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(encoded)") else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealsResponse.self, from: data)
        let meals = response.meals ?? []

        // Salva no cache se for busca vazia
        if search.isEmpty {
            cache.setObject(meals as NSArray, forKey: key)
        }

        return meals
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
