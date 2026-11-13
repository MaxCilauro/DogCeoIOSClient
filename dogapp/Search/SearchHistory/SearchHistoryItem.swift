//
//  SearchHistoryItem.swift
//
//

import Foundation

struct SearchHistoryItem: Codable, Identifiable, Equatable {
    let breed: DogCeo.Breed
    let subBreed: String?
    let searchedAt: Date

    var id: String {
        [self.breed.name, self.subBreed].compactMap { $0 }.joined(separator: "-")
    }

    var title: String {
        self.breed.displayName(subBreed: self.subBreed)
    }

    init(
        breed: DogCeo.Breed,
        subBreed: String?,
        searchedAt: Date = .now
    ) {
        self.breed = breed
        self.subBreed = subBreed
        self.searchedAt = searchedAt
    }

    init(result: BreedSearchResult) {
        self.init(breed: result.breed, subBreed: result.subBreed)
    }
}
