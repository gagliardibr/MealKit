//
//  Untitled.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
