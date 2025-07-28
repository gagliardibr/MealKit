//
//  FiltersResponse.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

struct FilterResponse: Codable {
    let meals: [FilterItemDTO]
}

struct FilterItemDTO: Codable {
    let strCategory: String?
    let strArea: String?
}

