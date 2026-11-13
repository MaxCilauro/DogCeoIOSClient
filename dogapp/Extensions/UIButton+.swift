//
//  UIButton+.swift
//
//

import UIKit

extension UIButton {
    static func makeRetryButton(using copy: StateCopy, action: @escaping () -> Void) -> UIButton {
        var configuration = UIButton.Configuration.plain()

        configuration.image = copy.iconName.flatMap { UIImage(systemName: $0) }
        configuration.imagePlacement = .top
        configuration.imagePadding = 6
        configuration.title = copy.buttonTitle
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = .preferredFont(forTextStyle: .footnote)
            return attributes
        }
        configuration.baseForegroundColor = .secondaryLabel
        configuration.background.backgroundColor = .tertiarySystemFill

        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in action() })
        button.accessibilityLabel = copy.title
        button.accessibilityHint = copy.buttonTitle

        return button
    }
}
