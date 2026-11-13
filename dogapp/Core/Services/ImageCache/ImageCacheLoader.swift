//
//  ImageCacheLoader.swift
//
//

import SwiftUI

struct ImageCacheLoader<Content: View>: View {
    @Environment(\.imageCacheManager) private var imageCacheManager
    @Environment(\.displayScale) private var displayScale

    @State private var phase: ImageLoadPhase = .loading
    @State private var phaseURL: URL?
    @State private var size: CGSize = .zero
    @State private var attempt = 0

    let url: URL
    @ViewBuilder let content: (ImageLoadPhase) -> Content

    var body: some View {
        Color.clear
            .overlay {
                self.content(self.currentPhase)
            }
            .onGeometryChange(for: CGSize.self, of: \.size) { size in
                self.size = size
                self.showCachedImage(size: size)
            }
            .task(id: "\(self.url.storageKey(for: self.size))#\(self.attempt)") {
                await self.load()
            }
    }

    private var currentPhase: ImageLoadPhase {
        self.phaseURL == self.url ? self.phase : .loading
    }

    private var isShowingImage: Bool {
        guard case .loaded = self.currentPhase else { return false }

        return true
    }

    private func setPhase(_ phase: ImageLoadPhase) {
        self.phase = phase
        self.phaseURL = self.url
    }

    private func showCachedImage(size: CGSize) {
        if let image = self.imageCacheManager?.cachedImage(for: self.url, targetSize: size) {
            self.setPhase(.loaded(image))
        }
    }

    private func load() async {
        guard let imageCacheManager else {
            assertionFailure("ImageCacheLoader needs an imageCacheManager in the environment.")
            return
        }

        guard self.size != .zero else { return }

        if let image = imageCacheManager.cachedImage(for: self.url, targetSize: self.size) {
            self.setPhase(.loaded(image))
            return
        }

        if !self.isShowingImage {
            self.setPhase(.loading)
        }

        do {
            let image = try await imageCacheManager.loadImage(
                url: self.url,
                targetSize: self.size,
                scale: self.displayScale
            )

            try Task.checkCancellation()

            self.setPhase(.loaded(image))
        } catch {
            guard !Task.isCancelled else { return }

            self.setPhase(
                .failed(error: error) {
                    self.attempt += 1
                }
            )
        }
    }
}

private struct ImageCacheLoaderPreview: View {
    private let imageURL = URL(string: "https://picsum.photos/400")!
    private let brokenURL = URL(string: "https://example.com/missing.jpg")!

    var body: some View {
        HStack(spacing: 12) {
            ForEach([self.imageURL, self.brokenURL], id: \.self) { url in
                ImageCacheLoader(url: url) { phase in
                    switch phase {
                    case .loading:
                        ProgressView()
                    case .loaded(let image):
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    case .failed(_, let retry):
                        Button(.retry, systemImage: "arrow.clockwise", action: retry)
                    }
                }
                .frame(height: 160)
                .background(.fill.tertiary)
                .clipShape(.rect(cornerRadius: 16))
            }
        }
        .padding()
        .environment(\.imageCacheManager, ImageCacheManager(cache: ImageCache(), fetch: URLSession.shared.validatedData(from:)))
    }
}

#Preview("Dark") {
    ImageCacheLoaderPreview()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    ImageCacheLoaderPreview()
        .preferredColorScheme(.light)
}
