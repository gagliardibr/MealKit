//
//  MealServiceProtocolMock.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 28/07/25.
//

import Foundation
@testable import MealKit

enum MockMealServiceSnapshot {
    static func singleMock() -> MealServiceProtocol {
        let mock = MockMealService()
        mock.mealsToReturn = [.mock(strMeal: "Pizza", strMealThumb: "https://via.placeholder.com/150")]
        return mock
    }

    static func emptyMock() -> MealServiceProtocol {
        let mock = MockMealService()
        mock.mealsToReturn = []
        return mock
    }
}
