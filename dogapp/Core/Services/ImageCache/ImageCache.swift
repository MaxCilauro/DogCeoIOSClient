//
//  ImageCache.swift
//
//


import UIKit
import Foundation

final class ImageCache: @unchecked Sendable {

    private let storage = NSCache<NSString, UIImage>()

    init(countLimit: Int = 300, totalCostLimit: Int = 80 * 1024 * 1024) {
        storage.countLimit = countLimit
        storage.totalCostLimit = totalCostLimit
    }

    subscript(key: NSString) -> UIImage? {
        get {
            storage.object(forKey: key)
        }
        set {
            if let image = newValue {
                storage.setObject(image, forKey: key, cost: image.cost)
            } else {
                storage.removeObject(forKey: key)
            }
        }
    }
}

private extension UIImage {
    var cost: Int {
        guard let cgImage else { return 1 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
