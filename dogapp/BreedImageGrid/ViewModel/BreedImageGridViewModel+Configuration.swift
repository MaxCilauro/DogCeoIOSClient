//
//  BreedImageGridViewModel+Configuration.swift
//
//

import Foundation

extension BreedImageGridViewModel {
    struct Configuration {
        let title: String
        let loadingSubtitle: String
        let emptyStateCopy: StateCopy
        let errorStateCopy: StateCopy
    }
}

extension BreedImageGridViewModel.Configuration {
    static func breed(_ breed: DogCeo.Breed) -> Self {
        .init(
            title: breed.displayName,
            loadingSubtitle: String(localized: .fetchingPoochies),
            emptyStateCopy: .emptyBreedsImages,
            errorStateCopy: .breedImagesFetchError
        )
    }

    static let favourites = Self(
        title: String(localized: .favouritesTitle),
        loadingSubtitle: String(localized: .fetchingFavourites),
        emptyStateCopy: .emptyFavourites,
        errorStateCopy: .favouriteFetchError
    )
}
