//
//  Model.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

// MARK: - Delegate

protocol FiltersViewModelDelegate: AnyObject {
    func didApplyMealFilters(_ filters: [String])
}

// MARK: - ViewModel

final class FiltersViewModel {
    private(set) var sections: [FilterSection] = []

    weak var delegate: FiltersViewModelDelegate?
    private let filterService: FilterServiceProtocol

    var onFiltersUpdated: (([FilterSection]) -> Void)?

    // MARK: - Init (com injeção de dependência)

    init(filterService: FilterServiceProtocol = FilterService()) {
        self.filterService = filterService
    }

    // MARK: - Ações

    func fetchFilters() {
        Task {
            async let categories = try? filterService.fetchCategories()
            async let areas = try? filterService.fetchAreas()

            let results = await (categories, areas)

            DispatchQueue.main.async {
                let previousSelections = self.sections.reduce(into: [String: Set<String>]()) { acc, section in
                    let selected = section.items.filter { $0.isSelected }.map { $0.name }
                    acc[section.title] = Set(selected)
                }

                self.sections = [
                    FilterSection(
                        title: "Category",
                        items: (results.0 ?? []).map { item in
                            FilterItem(
                                name: item.name,
                                isSelected: previousSelections["Category"]?.contains(item.name) ?? false
                            )
                        }
                    ),
                    FilterSection(
                        title: "Area",
                        items: (results.1 ?? []).map { item in
                            FilterItem(
                                name: item.name,
                                isSelected: previousSelections["Area"]?.contains(item.name) ?? false
                            )
                        }
                    )
                ]


                self.onFiltersUpdated?(self.sections)
            }
        }
    }

    func toggleFilterSelection(section: Int, index: Int) {
        guard sections.indices.contains(section),
              sections[section].items.indices.contains(index) else { return }

        let wasSelected = sections[section].items[index].isSelected

        // Deseleciona todos os itens da seção
        for i in 0..<sections[section].items.count {
            sections[section].items[i].isSelected = false
        }

        // Toggle
        if !wasSelected {
            sections[section].items[index].isSelected = true
        }

        onFiltersUpdated?(sections)
    }

    func applySelectedFilters() {
        let selected = sections.flatMap { section in
            section.items.filter { $0.isSelected }.map { $0.name }
        }

        delegate?.didApplyMealFilters(selected)
    }
}
