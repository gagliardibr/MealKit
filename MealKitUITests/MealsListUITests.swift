//
//  MealsListUITests.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 28/07/25.
//

import XCTest

final class MealsListUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_searchButton_showsSearchBar() {
        // Acessa o botão da lupa
        let searchButton = app.buttons["searchButton"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()

        // Verifica se a search bar apareceu
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 1.5))
    }

    func test_tableView_displaysFirstMealCell() {
        let firstCell = app.tables.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
    }

    func test_filterButton_opensSheet() {
        let filterButton = app.buttons["filterButton"]
        XCTAssertTrue(filterButton.exists)
        filterButton.tap()

        let navBar = app.navigationBars["Filters"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 1.5))
    }
}
