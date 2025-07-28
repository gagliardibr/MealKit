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

    func fetchMeals(for search: String) async throws -> [Meal] {
        let key = NSString(string: search)

        // Use cache only when search is empty
        if search.isEmpty, let cached = cache.object(forKey: key) as? [Meal] {
            return cached
        }

        guard let encoded = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(encoded)") else {
            throw MealServiceError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MealsResponse.self, from: data)
            let meals = response.meals ?? []

            // Save to cache if search is empty
            if search.isEmpty {
                cache.setObject(meals as NSArray, forKey: key)
            }

            return meals
        } catch is DecodingError {
            throw MealServiceError.decodingError
        } catch {
            throw MealServiceError.network(error)
        }
    }
    
    func fetchMealsFiltered(category: String?, area: String?) async throws -> [Meal] {
            var meals: [Meal] = []

            if let category = category {
                if let encoded = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(encoded)") {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let response = try JSONDecoder().decode(MealsResponse.self, from: data)
                    meals = response.meals ?? []
                }
            }

            if let area = area {
                if let encoded = area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?a=\(encoded)") {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let response = try JSONDecoder().decode(MealsResponse.self, from: data)
                    let areaMeals = response.meals ?? []

                    // Interseção entre os filtros (caso ambos sejam aplicados)
                    if !meals.isEmpty {
                        let areaMealIds = Set(areaMeals.map { $0.idMeal })
                        meals = meals.filter { areaMealIds.contains($0.idMeal) }
                    } else {
                        meals = areaMeals
                    }
                }
            }

            return meals
        }

    func clearCache() {
        cache.removeAllObjects()
    }
}
