//
//  FilterModels.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

// Usado na View
struct FilterSection {
    let title: String
    var items: [FilterItem]
}

struct FilterItem {
    let name: String
    var isSelected: Bool
}

// Usado na camada de rede (DTO)
struct FilterResponse: Codable {
    let meals: [FilterItemDTO]
}

struct FilterItemDTO: Codable {
    let strCategory: String?
    let strArea: String?
}
