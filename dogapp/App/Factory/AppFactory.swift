//
//  AppFactory.swift
//
//

import UIKit
import SwiftUI

final class AppFactory: ScreenFactory {
    private let dependencies: any Dependencies

    init(dependencies: any Dependencies) {
        self.dependencies = dependencies
    }

    func makeBreedList() -> UIViewController {
        BreedListViewController(
            viewModel: .init(provider: self.dependencies.breedProvider),
            navigateTo: self.navigateTo(_:from:)
        )
    }

    func makeBreedImageGrid(for breed: DogCeo.Breed) -> UIViewController {
        BreedImageGridViewController(
            viewModel: BreedImageGridViewModel(
                configuration: .breed(breed),
                provider: self.dependencies.makeBreedImagesProvider(for: breed)
            ),
            imageCacheManager: self.dependencies.imageCacheManager,
            navigateTo: self.navigateTo(_:from:)
        )
    }

    func makeFavouritesGrid() -> UIViewController {
        BreedImageGridViewController(
            viewModel: BreedImageGridViewModel(
                configuration: .favourites,
                provider: FavouriteImagesProvider(store: self.dependencies.favouriteStore)
            ),
            imageCacheManager: self.dependencies.imageCacheManager,
            navigateTo: self.navigateTo(_:from:)
        )
    }

    func makeImagePreview(images: [DogCeo.BreedImage], index: Int) -> UIViewController {
        BreedImagePreviewController(
            viewModel: .init(images: images, index: index),
            imageCacheManager: self.dependencies.imageCacheManager,
            store: self.dependencies.favouriteStore
        )
    }

    func makeBreedSearch() -> UIViewController {
        BreedSearchViewController(
            viewModel: .init(
                provider: self.dependencies.breedProvider,
                results: ResultsViewModel(
                    searchHistory: SearchHistoryViewModel(store: self.dependencies.searchHistoryStore)
                ),
                randomPoochies: RandomPoochiesViewModel(
                    rows: 2,
                    columns: 2,
                    provider: self.dependencies.makeRandomImagesProvider(count: 12)
                ),
                randomBreeds: RandomBreedsViewModel(itemCount: 3)
            ),
            imageCacheManager: self.dependencies.imageCacheManager,
            navigateTo: self.navigateTo(_:from:)
        )
    }

    func navigateTo(_ destination: Destination, from controller: UIViewController) {
        switch destination {
        case .imageGrid(breed: let breed):
            let destinationController = self.makeBreedImageGrid(for: breed)

            if let navigationController = controller.navigationController {
                navigationController.pushViewController(destinationController, animated: true)
            } else {
                controller.present(UINavigationController(rootViewController: destinationController), animated: true)
            }

        case .previewImage(images: let images, index: let index):
            let previewViewController = self.makeImagePreview(images: images, index: index)

            previewViewController.modalPresentationStyle = .fullScreen

            controller.present(previewViewController, animated: true)
        }
    }
}
