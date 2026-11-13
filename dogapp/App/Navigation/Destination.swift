//
//  Destination.swift
//
//

import UIKit

typealias NavigateTo = (Destination, UIViewController) -> Void

enum Destination {
    case previewImage(images: [DogCeo.BreedImage], index: Int)
    case imageGrid(breed: DogCeo.Breed)
}
