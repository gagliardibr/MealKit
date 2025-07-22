//
//  Services.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//


import Foundation

class MealService {
    func fetchMeals(for search: String) async throws -> [Meal] {
        let query = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealResponse.self, from: data)
        return response.meals ?? []
    }
}
