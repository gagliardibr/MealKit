//
//  MealService.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

protocol MealServiceProtocol {
    func fetchMeals(for search: String) async throws -> [Meal]
}

final class MealService: MealServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchMeals(for search: String) async throws -> [Meal] {
        let query = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(MealsResponse.self, from: data)
            return decoded.meals ?? []
        } catch {
            throw NetworkError.decodingError
        }
    }
}
