//
//  BreedImagePreviewViewModel.swift
//
//

import Foundation

@Observable
final class BreedImagePreviewViewModel {
    let images: [DogCeo.BreedImage]

    private(set) var currentIndex: Int

    init(images: [DogCeo.BreedImage], index: Int) {
        self.images = images
        self.currentIndex = images.indices.contains(index) ? index : 0
    }

    var currentImage: DogCeo.BreedImage {
        self.images[self.currentIndex]
    }

    var title: String {
        self.currentImage.displayName
    }

    var subtitle: String {
        DogCeo.BreedImage.position(index: self.currentIndex, count: self.images.count)
    }

    var caption: String {
        guard let subBreed = self.currentImage.subBreed else {
            return self.title
        }

        return String(localized: .varietyCaption(subBreed.capitalized))
    }

    var positionTitle: String {
        self.currentImage.positionTitle(index: self.currentIndex, count: self.images.count)
    }

    func next() {
        let nextIndex = self.currentIndex + 1
        self.currentIndex = nextIndex < self.images.count ? nextIndex : 0
    }

    func previous() {
        let previousIndex = self.currentIndex - 1
        self.currentIndex = previousIndex >= 0 ? previousIndex : self.images.count - 1
    }
}
