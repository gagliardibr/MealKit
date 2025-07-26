//
//  FilterService.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

final class FilterService {
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"

    func fetchCategories() async throws -> [String] {
        let url = URL(string: "\(baseURL)/list.php?c=list")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FilterResponse.self, from: data)
        return response.meals.map { $0.strCategory ?? String()}
    }

    func fetchAreas() async throws -> [String] {
        let url = URL(string: "\(baseURL)/list.php?a=list")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FilterResponse.self, from: data)
        return response.meals.map { $0.strArea ?? String()}
    }
}
