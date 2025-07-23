//
//  NetworkError.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case noData
    case custom(String)
}
