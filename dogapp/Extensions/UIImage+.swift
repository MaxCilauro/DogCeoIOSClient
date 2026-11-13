//
//  UIImage+.swift
//
//

import UIKit

extension UIImage {

    static let loadingPlaceholder: UIImage? = {
        let frameCount = 24
        let minimumAlpha: CGFloat = 0.12
        let maximumAlpha: CGFloat = 0.24

        let frames = (0..<frameCount).map { index in
            let progress = CGFloat(index) / CGFloat(frameCount)
            let wave = 0.5 - 0.5 * cos(2 * .pi * progress)

            return UIImage.solid(.placeholderGrey(alpha: minimumAlpha + (maximumAlpha - minimumAlpha) * wave))
        }

        return UIImage.animatedImage(with: frames, duration: 1.6)
    }()

    /// A 1×1 solid image; aspect fill stretches it to any size without visible scaling.
    private static func solid(_ color: UIColor) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1

        return UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1), format: format).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}

private extension UIColor {

    static func placeholderGrey(alpha: CGFloat) -> UIColor {
        UIColor(white: 0.47, alpha: alpha)
    }
}
