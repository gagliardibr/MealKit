//
//  FilterService.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

protocol FilterServiceProtocol {
    func fetchCategories() async throws -> [FilterItem]
    func fetchAreas() async throws -> [FilterItem]
}

final class FilterService: FilterServiceProtocol {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchCategories() async throws -> [FilterItem] {
        try await fetchList(endpoint: .listCategories, keyPath: \.strCategory)
    }

    func fetchAreas() async throws -> [FilterItem] {
        try await fetchList(endpoint: .listAreas, keyPath: \.strArea)
    }

    private func fetchList(
        endpoint: MealEndpoint,
        keyPath: KeyPath<FilterItemDTO, String?>
    ) async throws -> [FilterItem] {
        guard let url = endpoint.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(FilterResponse.self, from: data)

        return response.meals.compactMap { dto in
            guard let name = dto[keyPath: keyPath] else { return nil }
            return FilterItem(name: name, isSelected: false)
        }
    }
}
