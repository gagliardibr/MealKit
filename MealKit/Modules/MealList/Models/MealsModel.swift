//
//  MealsModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

import Foundation

struct MealsResponse: Codable {
    let meals: [Meal]?
}

struct Meal: Codable {
    let idMeal: String?
    let strMeal: String?
    let strMealThumb: String?
    let strInstructions: String?
    let strCategory: String?
    let strArea: String?
}

