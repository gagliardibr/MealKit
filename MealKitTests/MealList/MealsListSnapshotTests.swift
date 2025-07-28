//
//  MealsListSnapshotTests.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 28/07/25.
//

import XCTest
import SnapshotTesting
@testable import MealKit

final class MealsListSnapshotTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        let viewModel = MealsListViewModel(service: MockMealServiceSnapshot.singleMock())
           let sut = MealsListViewController(viewModel: viewModel)
        
        withSnapshotTesting(record: false) {
            assertSnapshot(of: sut, as: .image(on: .iPhone13))
        }
    }

    func test_mealsList_withOneItem_lightMode() {
        let viewModel = MealsListViewModel(service: MockMealServiceSnapshot.singleMock())
        let sut = MealsListViewController(viewModel: viewModel)

        // Render no frame de iPhone
        assertSnapshot(of: sut, as: .image(on: .iPhone13))
    }

    func test_mealsList_empty_darkMode() {
        let viewModel = MealsListViewModel(service: MockMealServiceSnapshot.emptyMock())
        let sut = MealsListViewController(viewModel: viewModel)
        
        assertSnapshot(of: sut, as: .image(on: .iPhone13, traits: .init(userInterfaceStyle: .dark)))
    }
}
