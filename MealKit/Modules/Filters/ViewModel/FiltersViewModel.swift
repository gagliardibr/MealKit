//
//  Model.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import Foundation

struct FilterSection {
    let title: String
    var items: [FilterItem]
}

struct FilterItem {
    let name: String
    var isSelected: Bool
}

protocol FiltersViewModelDelegate: AnyObject {
    func didApplyFilters(_ filters: [String])
}

final class FiltersViewModel {
    private(set) var sections: [FilterSection] = []

    weak var delegate: FiltersViewModelDelegate?
    private let filterService = FilterService()

    var onFiltersUpdated: (([FilterSection]) -> Void)?

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
                        items: (results.0 ?? []).map { name in
                            FilterItem(name: name, isSelected: previousSelections["Category"]?.contains(name) ?? false)
                        }
                    ),
                    FilterSection(
                        title: "Area",
                        items: (results.1 ?? []).map { name in
                            FilterItem(name: name, isSelected: previousSelections["Area"]?.contains(name) ?? false)
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

        // Verifica se o item já estava selecionado
        let wasSelected = sections[section].items[index].isSelected

        // Deselect todos os itens
        for i in 0..<sections[section].items.count {
            sections[section].items[i].isSelected = false
        }

        // Só seleciona de novo se ele não estava selecionado antes (toggle)
        if !wasSelected {
            sections[section].items[index].isSelected = true
        }

        onFiltersUpdated?(sections)
    }
    
    func applySelectedFilters() {
        let selected = sections.flatMap { section in
            section.items.filter { $0.isSelected }.map { $0.name }
        }

        delegate?.didApplyFilters(selected)
    }
}
