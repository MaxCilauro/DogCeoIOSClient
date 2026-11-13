//
//  StubScreenFactory.swift
//
//

import UIKit

struct StubScreenFactory: ScreenFactory {
    func makeBreedList() -> UIViewController {
        UIViewController()
    }

    func makeBreedImageGrid(for breed: DogCeo.Breed) -> UIViewController {
        UIViewController()
    }

    func makeFavouritesGrid() -> UIViewController {
        UIViewController()
    }

    func makeImagePreview(images: [DogCeo.BreedImage], index: Int) -> UIViewController {
        UIViewController()
    }

    func makeBreedSearch() -> UIViewController {
        UIViewController()
    }
    
    func navigateTo(_ destination: Destination, from: UIViewController) {
        
    }
}
