//
//  MealServiceError.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import Foundation

enum MealServiceError: Error {
    case invalidURL
    case decodingError
    case network(Error)

    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError:
            return "Failed to decode response"
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
