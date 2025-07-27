//
//  Model.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

protocol FiltersViewModelDelegate: AnyObject {
    func didApplyFilters(_ filters: [String])
}


final class FiltersViewModel {
    weak var delegate: FiltersViewModelDelegate?

    enum FilterSection: Int, CaseIterable {
        case category
        case area

        var title: String {
            switch self {
            case .category: return "Categories"
            case .area: return "Areas"
            }
        }
    }

    private let service = FilterService()

    private(set) var categories: [String] = []
    private(set) var areas: [String] = []

    private(set) var selectedCategories: Set<String> = []
    private(set) var selectedAreas: Set<String> = []

    var isLoading = false

    func fetchFilters(completion: @escaping () -> Void) {
        Task {
            isLoading = true
            async let categories = try? service.fetchCategories()
            async let areas = try? service.fetchAreas()
            self.categories = await categories ?? []
            self.areas = await areas ?? []
            isLoading = false
            completion()
        }
    }

    func toggleSelection(in section: FilterSection, item: String) {
        switch section {
        case .category:
            if selectedCategories.contains(item) {
                selectedCategories.remove(item)
            } else {
                selectedCategories = [item]
                selectedAreas.removeAll()
            }
        case .area:
            if selectedAreas.contains(item) {
                selectedAreas.remove(item)
            } else {
                selectedAreas = [item]
                selectedCategories.removeAll()
            }
        }
    }

    func isSelected(in section: FilterSection, item: String) -> Bool {
        switch section {
        case .category:
            return selectedCategories.contains(item)
        case .area:
            return selectedAreas.contains(item)
        }
    }

    func item(at indexPath: IndexPath) -> String {
        switch FilterSection(rawValue: indexPath.section)! {
        case .category:
            return categories[indexPath.item]
        case .area:
            return areas[indexPath.item]
        }
    }

    func numberOfItems(in section: FilterSection) -> Int {
        switch section {
        case .category:
            return categories.count
        case .area:
            return areas.count
        }
    }

    func applySelectedFilters() {
        let allFilters = Array(selectedCategories.union(selectedAreas))
        delegate?.didApplyFilters(allFilters)
    }
    
    func clearFilters() {
        selectedAreas = []
        selectedCategories = []
    }
}
