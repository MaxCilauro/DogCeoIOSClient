//
//  FavouriteImagesProvider.swift
//
//

import Foundation

@Observable
final class FavouriteImagesProvider: LoadingProvider {
    private let store: any ValueStoring<Favourite>

    init(store: any ValueStoring<Favourite>) {
        self.store = store
    }

    var state: LoadingState<[DogCeo.BreedImage], Error> {
        switch self.store.state {
        case .loading:
            return .loading
        case .loaded(let favourites):
            return .loaded(favourites.map(\.image))
        case .failed(let error):
            return .failed(error)
        }
    }

    func loadIfNeeded() async {
        await self.store.loadIfNeeded()
    }
}
