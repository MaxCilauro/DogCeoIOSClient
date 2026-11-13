//
//  SearchHistoryItem+Stubs.swift
//
//

import Foundation

extension SearchHistoryItem {
    static let stubs: [SearchHistoryItem] = [
        SearchHistoryItem(
            breed: DogCeo.Breed(
                name: "bulldog",
                subBreeds: [
                    "boston",
                    "english",
                    "french"
                ]
            ),
            subBreed: "french"
        ),
        SearchHistoryItem(
            breed: DogCeo.Breed(
                name: "collie",
                subBreeds: ["border"]
            ),
            subBreed: nil
        ),
        SearchHistoryItem(
            breed: DogCeo.Breed(
                name: "akita",
                subBreeds: []
            ),
            subBreed: nil
        ),
    ]
}
