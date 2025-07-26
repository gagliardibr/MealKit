//
//  FiltersResponse.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

struct FilterResponse: Decodable {
    let meals: [Filter]
}

struct Filter: Decodable {
    let strCategory: String?
    let strArea: String?
}
