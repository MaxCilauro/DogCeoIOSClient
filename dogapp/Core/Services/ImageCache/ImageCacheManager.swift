//
//  ImageCacheManager.swift
//
//

import UIKit
import Foundation

final class ImageCacheManager {
    typealias Fetch = (URL) async throws -> Data

    private let cache: ImageCache
    private let fetch: Fetch

    init(cache: ImageCache, fetch: @escaping Fetch) {
        self.cache = cache
        self.fetch = fetch
    }
    
    func cachedImage(for url: URL, targetSize size: CGSize) -> UIImage? {
        let cacheKey = url.storageKey(for: size)

        return self.cache[cacheKey]
    }
    
    func loadImage(
        url: URL,
        targetSize size: CGSize,
        scale: CGFloat
    ) async throws -> UIImage {
        let cacheKey = url.storageKey(for: size)
        
        if let image = self.cache[cacheKey] {
            return image
        }
        
        let data = try await self.fetch(url)
        let image = try await Self.downsample(data, to: size, scale: scale)

        self.cache[cacheKey] = image

        return image
    }
}

extension ImageCacheManager {
    enum LoadError: LocalizedError {
        case invalidImageData

        var errorDescription: String? {
            switch self {
            case .invalidImageData:
                return "The image data could not be decoded."
            }
        }
    }
    
    @concurrent
    nonisolated private static func downsample(
        _ data: Data,
        to size: CGSize,
        scale: CGFloat
    ) async throws -> UIImage {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
            throw LoadError.invalidImageData
        }

        let maxDimensionInPixels = max(size.width, size.height) * scale
        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDimensionInPixels)
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            downsampleOptions as CFDictionary
        ) else {
            throw LoadError.invalidImageData
        }

        return UIImage(cgImage: cgImage)
    }
}
