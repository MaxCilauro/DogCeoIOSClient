//
//  RandomBreedsViewModel.swift
//
//

import Foundation

@Observable
final class RandomBreedsViewModel {
    private let itemCount: Int

    var randomBreeds: [DogCeo.Breed] = []

    @ObservationIgnored
    private var breeds: [DogCeo.Breed] = []
    private let shuffler: ([DogCeo.Breed]) -> [DogCeo.Breed]

    init(
        itemCount: Int = 3,
        shuffler: @escaping ([DogCeo.Breed]) -> [DogCeo.Breed] = { $0.shuffled() }
    ) {
        self.itemCount = itemCount
        self.shuffler = shuffler
    }

    func setBreeds(_ breeds: [DogCeo.Breed]) {
        guard self.breeds != breeds else {
            return
        }

        self.breeds = breeds
        self.shuffle()
    }

    func shuffle() {
        let shuffledBreeds = self.shuffler(self.breeds)

        self.randomBreeds = Array(shuffledBreeds.prefix(self.itemCount))
    }
}
