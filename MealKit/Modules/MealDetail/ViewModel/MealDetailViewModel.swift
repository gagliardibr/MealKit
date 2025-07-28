//
//  MealDetailViewModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import Foundation

final class MealDetailViewModel {
    private let meal: Meal

    init(meal: Meal) {
        self.meal = meal
    }

    var title: String {
        meal.strMeal ?? String()
    }

    var instructions: String {
        meal.strInstructions ?? String()
    }

    var thumbnailURL: URL? {
        URL(string: meal.strMealThumb ?? String())
    }


    var imageAccessibilityLabel: String {
        "Meal image: \(meal.strMeal ?? "Empty Image")"
    }

    var instructionsAccessibilityLabel: String {
        "Meal preparation instructions"
    }
}
 
