//
//  PoochieTile.swift
//
//

import SwiftUI

struct PoochieTile: View {
    let breedImage: DogCeo.BreedImage
    var onSelect: () -> Void = {}

    var body: some View {
        ImageCacheLoader(url: self.breedImage.url) { phase in
            switch phase {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .failed(_, let retry):
                ImageErrorView(
                    stateCopy: .imageLoadError,
                    retry: retry
                )

            case .loaded(let image):
                Button(action: self.onSelect) {
                    PoochieImage(image: image, breedImage: self.breedImage)
                }
                .buttonStyle(CardButtonStyle())
            }
        }
        .background(.fill.tertiary)
        .clipShape(.rect(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.separator, lineWidth: 1)
        }
        .contentShape(.rect(cornerRadius: 16))
    }
}

private struct PoochieTilePreview: View {
    private let brokenImage = DogCeo.BreedImage(
        url: URL(string: "https://images.dog.ceo/breeds/missing.jpg")!,
        breed: "hound",
        subBreed: "afghan"
    )

    var body: some View {
        HStack(spacing: 10) {
            PoochieTile(breedImage: DogCeo.BreedImage.stubs[0])
                .frame(height: 130)

            PoochieTile(breedImage: self.brokenImage)
                .frame(height: 130)
        }
        .padding()
        .environment(\.imageCacheManager, ImageCacheManager(cache: ImageCache(), fetch: URLSession.shared.validatedData(from:)))
    }
}

#Preview("Dark") {
    PoochieTilePreview()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    PoochieTilePreview()
        .preferredColorScheme(.light)
}
