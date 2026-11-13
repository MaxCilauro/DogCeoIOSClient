//
//  BreedSearchResult.swift
//
//

import Foundation

struct BreedSearchResult: Identifiable, Equatable {
    let breed: DogCeo.Breed
    let subBreed: String?
    let title: String
    let matchedRange: Range<String.Index>

    var id: String {
        [self.breed.name, self.subBreed].compactMap { $0 }.joined(separator: "-")
    }
}
