//
//  Favourite.swift
//
//

import Foundation

struct Favourite: Codable, Identifiable {
    var id: URL { image.id }
    
    let image: DogCeo.BreedImage
    let savedAt: Date
    
    init(image: DogCeo.BreedImage) {
        self.image = image
        self.savedAt = .now
    }
}
