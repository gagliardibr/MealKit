//
//  MealAPI.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import XCTest
import Combine
@testable import MealKit

final class MealsListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: MealsListViewModel!
    private var mockService: MockMealService!

    override func setUp() {
        super.setUp()
        mockService = MockMealService()
        viewModel = MealsListViewModel(service: mockService)
    }

    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func test_fetchMeals_success_setsViewStateToSuccess_andPopulatesCellViewModels() async {
        mockService.mealsToReturn = [.mock(idMeal: "1", strMeal: "Pizza")]

        let expectation = expectation(description: "State becomes .success")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchMeals()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(viewModel.cellViewModels.count, 1)
        XCTAssertEqual(viewModel.cellViewModels.first?.title, "Pizza")
    }

    func test_fetchMeals_empty_setsStateToEmpty() async {
        mockService.mealsToReturn = []

        let expectation = expectation(description: "State becomes .empty")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .empty = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchMeals()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(viewModel.cellViewModels.count, 0)
    }

    func test_fetchMeals_error_setsStateToError() async {
        mockService.shouldThrowError = true

        let expectation = expectation(description: "State becomes .error")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .error(_) = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchMeals()
        await fulfillment(of: [expectation], timeout: 2)
    }
}
