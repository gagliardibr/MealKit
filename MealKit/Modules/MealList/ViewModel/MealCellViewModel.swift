//
//  MealCellViewModel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import Foundation

struct MealCellViewModel {
    let title: String
    let imageURL: URL?
    
    init(meal: Meal) {
        self.title = meal.strMeal
        self.imageURL = URL(string: meal.strMealThumb)
    }
}
