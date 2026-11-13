//
//  ImageCacheManagerTests.swift
//Tests
//

import UIKit
import Testing

@testable import dogapp

@MainActor
@Suite("ImageCacheManager")
struct ImageCacheManagerTests {
    private static let url = DogCeo.BreedImage.stubs[0].url
    private static let size = CGSize(width: 10, height: 10)

    @MainActor
    @Suite("With valid image")
    struct ValidImage {
        private let spy = DataFetchSpy(result: .success(pngData))
        private let manager: ImageCacheManager

        init() {
            self.manager = makeManager(spy: self.spy)
        }

        @Test func nothingIsCachedBeforeLoading() {
            #expect(self.manager.cachedImage(for: url, targetSize: size) == nil)
        }

        @Test func loadingFetchesTheURL() async throws {
            _ = try await self.manager.loadImage(url: url, targetSize: size, scale: 1)

            #expect(self.spy.requestedURLs == [url])
        }

        @Test func imageIsCached() async throws {
            _ = try await self.manager.loadImage(url: url, targetSize: size, scale: 1)

            #expect(self.manager.cachedImage(for: url, targetSize: size) != nil)
        }

        @Test func loadedImageIsDownsampledToTheTargetSize() async throws {
            let image = try await self.manager.loadImage(url: url, targetSize: size, scale: 2)

            #expect(max(image.size.width, image.size.height) * image.scale <= 20)
        }

        @Test func cachedImageIsNotFetchedAgain() async throws {
            _ = try await self.manager.loadImage(url: url, targetSize: size, scale: 1)
            _ = try await self.manager.loadImage(url: url, targetSize: size, scale: 1)

            #expect(self.spy.requestedURLs.count == 1)
        }

        @Test func eachTargetSizeIsCachedSeparately() async throws {
            let largerSize = CGSize(width: 20, height: 20)

            _ = try await self.manager.loadImage(url: url, targetSize: size, scale: 1)
            _ = try await self.manager.loadImage(url: url, targetSize: largerSize, scale: 1)

            #expect(self.spy.requestedURLs.count == 2)
            #expect(self.manager.cachedImage(for: url, targetSize: size) != nil)
            #expect(self.manager.cachedImage(for: url, targetSize: largerSize) != nil)
        }
    }

    @MainActor
    @Suite("With invalid image")
    struct InvalidImage {
        private let manager = makeManager(spy: DataFetchSpy(result: .success(Data("not an image".utf8))))

        @Test func invalidDataThrows() async {
            await #expect(throws: ImageCacheManager.LoadError.self) {
                try await self.manager.loadImage(url: url, targetSize: size, scale: 1)
            }
        }

        @Test func invalidDataIsNotCached() async throws {
            try await #require(throws: ImageCacheManager.LoadError.self) {
                try await self.manager.loadImage(url: url, targetSize: size, scale: 1)
            }

            #expect(self.manager.cachedImage(for: url, targetSize: size) == nil)
        }
    }

    @MainActor
    @Suite("With failing request")
    struct FailingRequest {
        private let manager = makeManager(spy: DataFetchSpy(result: .failure(StubError())))

        @Test func fetchErrorIsRethrown() async {
            await #expect(throws: StubError.self) {
                try await self.manager.loadImage(url: url, targetSize: size, scale: 1)
            }
        }
    }

    // MARK: Helpers

    private static let pngData = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100)).pngData { context in
        UIColor.systemTeal.setFill()
        context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    private static func makeManager(spy: DataFetchSpy) -> ImageCacheManager {
        ImageCacheManager(cache: ImageCache(), fetch: spy.fetch)
    }
}
