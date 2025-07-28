//
//  MealAPI.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import Foundation
@testable import MealKit

extension Meal {
    static func mock(idMeal: String = "1",
                     strMeal: String = "Mock Meal",
                     strMealThumb: String = "https://example.com/image.jpg",
                     strInstructions: String = "Mock instructions",
                     strCategory: String? = "Mock Category",
                     strArea: String? = "Mock Area") -> Meal {
        return Meal(idMeal: idMeal,
                    strMeal: strMeal,
                    strMealThumb: strMealThumb,
                    strInstructions: strInstructions,
                    strCategory: strCategory,
                    strArea: strArea)
    }
}
