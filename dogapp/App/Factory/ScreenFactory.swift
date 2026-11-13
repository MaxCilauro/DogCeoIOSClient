//
//  ScreenFactory.swift
//
//

import UIKit

protocol ScreenFactory {
    func makeBreedList() -> UIViewController
    func makeBreedImageGrid(for breed: DogCeo.Breed) -> UIViewController
    func makeFavouritesGrid() -> UIViewController
    func makeImagePreview(images: [DogCeo.BreedImage], index: Int) -> UIViewController
    func makeBreedSearch() -> UIViewController

    func navigateTo(_ destination: Destination, from: UIViewController)
}
