//
//  ViewCode.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 21/07/25.
//

protocol ViewCode {
    func addSubviews()
    func setupConstraints()
    func setupStyle()
    func bindViewModel()
    func setupAccessibility()
    func setupNavigation()
}

extension ViewCode {
    func setupViewCode() {
        addSubviews()
        setupConstraints()
        setupStyle()
        bindViewModel()
        setupAccessibility()
        setupNavigation()
    }
}

