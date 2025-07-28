//
//  Extension+UIColor.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//
import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        var length = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        length = hexSanitized.count
        switch length {
        case 6:
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
            let b = CGFloat(rgb & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        case 8:
            let a = CGFloat((rgb & 0xFF000000) >> 24) / 255
            let r = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            let g = CGFloat((rgb & 0x0000FF00) >> 8) / 255
            let b = CGFloat(rgb & 0x000000FF) / 255
            self.init(red: r, green: g, blue: b, alpha: a)
        default:
            return nil
        }
    }
}

