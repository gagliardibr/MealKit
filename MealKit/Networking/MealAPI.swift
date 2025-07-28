//
//  MealAPI.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import Foundation

enum MealAPI {
    static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
}

enum MealEndpoint {
    case search(String)
    case filterByCategory(String)
    case filterByArea(String)
    case listCategories
    case listAreas

    var path: String {
        switch self {
        case .search(let query):
            return "search.php?s=\(query.urlEncoded)"
        case .filterByCategory(let category):
            return "filter.php?c=\(category.urlEncoded)"
        case .filterByArea(let area):
            return "filter.php?a=\(area.urlEncoded)"
        case .listCategories:
            return "list.php?c=list"
        case .listAreas:
            return "list.php?a=list"
        }
    }

    var url: URL? {
        URL(string: MealAPI.baseURL + path)
    }
}


extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
