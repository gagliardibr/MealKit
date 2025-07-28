//
//  FilterService.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

protocol FilterServiceProtocol {
    func fetchCategories() async throws -> [String]
    func fetchAreas() async throws -> [String]
}

final class FilterService: FilterServiceProtocol {
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"

    func fetchCategories() async throws -> [String] {
        let urlString = "\(baseURL)/list.php?c=list"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FilterResponse.self, from: data)
        return response.meals.compactMap { $0.strCategory }
    }

    func fetchAreas() async throws -> [String] {
        let urlString = "\(baseURL)/list.php?a=list"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FilterResponse.self, from: data)
        return response.meals.compactMap { $0.strArea }
    }
}
