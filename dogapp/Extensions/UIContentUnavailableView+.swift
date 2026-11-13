//
//  UIContentUnavailableView+.swift
//
//

import UIKit

extension UIContentUnavailableView {
    static func makeView(stateCopy: StateCopy, retry: UIAction? = nil) -> UIContentUnavailableView {
        var configuration = UIContentUnavailableConfiguration.empty()

        configuration.image = stateCopy.iconName.flatMap { UIImage(systemName: $0) }
        configuration.text = stateCopy.title
        configuration.secondaryText = stateCopy.subtitle

        if let buttonTitle = stateCopy.buttonTitle, let retry {
            configuration.button = .borderedProminent()
            configuration.button.title = buttonTitle
            configuration.buttonProperties.primaryAction = retry
        }

        return UIContentUnavailableView(configuration: configuration)
    }
}
