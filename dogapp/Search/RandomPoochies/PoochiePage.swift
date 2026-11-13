//
//  PoochiePage.swift
//
//

import SwiftUI

struct PoochiePage: View {
    let images: [DogCeo.BreedImage]
    let rows: Int
    let columns: Int
    let onSelect: (Int) -> Void
    
    init(
        images: [DogCeo.BreedImage],
        rows: Int = 3,
        columns: Int = 2,
        onSelect: @escaping (Int) -> Void = { _ in }
    ) {
        self.images = images
        self.rows = rows
        self.columns = columns
        self.onSelect = onSelect
    }

    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            ForEach(0..<self.rows, id: \.self) { row in
                GridRow {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.tile(at: row * self.columns + column)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func tile(at index: Int) -> some View {
        if index < self.images.count {
            PoochieTile(breedImage: self.images[index]) {
                self.onSelect(index)
            }
            .frame(height: 130)
        } else {
            Color.clear
                .frame(height: 130)
        }
    }
}

private let previewImage = DogCeo.BreedImage(
    url: URL(string: "https://images.dog.ceo/breeds/hound-blood/n02088466_7167.jpg")!,
    breed: "hound",
    subBreed: "blood"
)

#Preview("Full page") {
    PoochiePage(images: Array(repeating: previewImage, count: 6))
        .padding()
        .environment(\.imageCacheManager, ImageCacheManager(cache: ImageCache(), fetch: URLSession.shared.validatedData(from:)))
}

#Preview("Partial page") {
    PoochiePage(images: Array(repeating: previewImage, count: 4))
        .padding()
        .environment(\.imageCacheManager, ImageCacheManager(cache: ImageCache(), fetch: URLSession.shared.validatedData(from:)))
}
