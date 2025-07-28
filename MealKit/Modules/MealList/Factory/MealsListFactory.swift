//
//  MealsListFactory.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import UIKit

protocol MealsListFactoryProtocol {
    func makeMealsList(delegate: MealsListCoordinatorDelegate) -> UIViewController
    func makeFilters(delegate: FiltersViewModelDelegate) -> UIViewController
}

final class MealsListFactory: MealsListFactoryProtocol {
    func makeMealsList(delegate: MealsListCoordinatorDelegate) -> UIViewController {
        let service = MealService()
        let viewModel = MealsListViewModel(service: service)
        viewModel.coordinator = delegate
        return MealsListViewController(viewModel: viewModel)
    }

    func makeFilters(delegate: FiltersViewModelDelegate) -> UIViewController {
        let viewModel = FiltersViewModel()
        viewModel.delegate = delegate
        return FiltersViewController(viewModel: viewModel)
    }
}
