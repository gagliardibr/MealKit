//
//  DesignSystem.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 23/07/25.
//

import UIKit

// DesignSystem.swift

import UIKit

enum DesignSystem {
    enum Colors {
        static let primaryBackground = UIColor(hex: "#7B2D26")
        static let searchTextBackground = UIColor.white.withAlphaComponent(0.2)
        static let searchPlaceholder = UIColor.white.withAlphaComponent(0.7)
        static let searchText = UIColor.white
        static let icon = UIColor.white
    }

    enum Layout {
        static let searchBarHeight: CGFloat = 44
        static let animationDuration: TimeInterval = 0.5
        static let springDamping: CGFloat = 0.85
        static let springVelocity: CGFloat = 0.8
        static let animationOffsetY: CGFloat = -20
    }

    enum Fonts {
        static let body = UIFont.systemFont(ofSize: 16)
        static let title = UIFont.boldSystemFont(ofSize: 20)
    }
}
