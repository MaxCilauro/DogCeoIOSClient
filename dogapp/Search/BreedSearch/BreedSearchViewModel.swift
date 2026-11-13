//
//  BreedSearchViewModel.swift
//
//

import Foundation

@Observable
final class BreedSearchViewModel {
    var isSearchActive = false

    let results: ResultsViewModel
    let randomPoochies: RandomPoochiesViewModel
    let randomBreeds: RandomBreedsViewModel

    var state: LoadingState<[DogCeo.Breed], Error> {
        self.provider.state
    }

    private let provider: any LoadingProvider<DogCeo.Breed>

    init(
        provider: any LoadingProvider<DogCeo.Breed>,
        results: ResultsViewModel,
        randomPoochies: RandomPoochiesViewModel,
        randomBreeds: RandomBreedsViewModel
    ) {
        self.provider = provider
        self.results = results
        self.randomPoochies = randomPoochies
        self.randomBreeds = randomBreeds
    }

    func loadIfNeeded() async {
        await self.provider.loadIfNeeded()
    }
}
