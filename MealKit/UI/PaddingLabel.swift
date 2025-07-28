//
//  PaddingLabel.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import UIKit

final class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}
