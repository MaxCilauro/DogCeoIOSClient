//
//  UIImageView+.swift
//
//

import UIKit

extension UIImageView {
    func configureSymbol(named symbolName: String) {
        self.image = UIImage(systemName: symbolName)
        self.contentMode = .center
        self.tintColor = .tertiaryLabel
        self.preferredSymbolConfiguration = .init(pointSize: 44, weight: .regular)
    }
    
    static func makeViewForLoader(
        image: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        accessibilityLabel: String,
        accessibilityValue: String? = nil,
        accessibilityTraits: UIAccessibilityTraits = .image
    ) -> UIImageView {
        let view = UIImageView()

        view.clipsToBounds = true
        view.isAccessibilityElement = true

        view.image = image
        view.contentMode = contentMode
        view.accessibilityTraits = accessibilityTraits
        view.accessibilityLabel = accessibilityLabel
        view.accessibilityValue = accessibilityValue
        
        return view
    }
}
