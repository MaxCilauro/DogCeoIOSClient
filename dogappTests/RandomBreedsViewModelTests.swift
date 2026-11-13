//
//  RandomBreedsViewModelTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("RandomBreedsViewModel")
struct RandomBreedsViewModelTests {

    @MainActor
    @Suite("With rotating shuffler")
    struct WithRotatingShuffler {
        private let viewModel: RandomBreedsViewModel
        private let breeds = Array(DogCeo.Breed.stubs.prefix(3))

        init() {
            var calls = 0

            self.viewModel = RandomBreedsViewModel(
                itemCount: 3,
                shuffler: { breeds in
                    calls += 1
                    let shift = calls % breeds.count

                    return Array(breeds[shift...] + breeds[..<shift])
                }
            )

            self.viewModel.setBreeds(self.breeds)
        }

        @Test func shufflesBreedsOnSet() {
            #expect(self.viewModel.randomBreeds != self.breeds)
        }

        @Test func callingShuffleShufflesBreeds() {
            let currentRandomBreeds = self.viewModel.randomBreeds

            self.viewModel.shuffle()

            #expect(self.viewModel.randomBreeds != currentRandomBreeds)
        }

        @Test func avoidsShuffleWhenSameBreedsAreSet() {
            let currentRandomBreeds = self.viewModel.randomBreeds

            self.viewModel.setBreeds(self.breeds)

            #expect(self.viewModel.randomBreeds == currentRandomBreeds)
        }
    }

    @MainActor
    @Suite("With set Breed count as Item count")
    struct WithStubCount {
        private let breeds: [DogCeo.Breed]
        private let viewModel: RandomBreedsViewModel

        init() {
            self.breeds = DogCeo.Breed.stubs
            self.viewModel = makeViewModel(itemCount: self.breeds.count)

            self.viewModel.setBreeds(self.breeds)
        }

        @Test func picksItemCountBreeds() {
            #expect(self.viewModel.randomBreeds.count == self.breeds.count)
        }
    }

    @MainActor
    @Suite("With Item count higher than feed breeds")
    struct WithHigherCount {
        private let stubs = Array(DogCeo.Breed.stubs.prefix(2))
        private let viewModel = makeViewModel(itemCount: 5)

        @Test func picksItemCountBreeds() {
            self.viewModel.setBreeds(self.stubs)

            #expect(viewModel.randomBreeds.count == self.stubs.count)
        }
    }

    @MainActor
    @Suite("With Item count lower than feed breeds")
    struct WithLowerCount {
        private let viewModel: RandomBreedsViewModel
        private let count = 3

        init() {
            self.viewModel = makeViewModel(itemCount: self.count)
            self.viewModel.setBreeds(DogCeo.Breed.stubs)
        }

        @Test func picksItemCountBreeds() {
            #expect(viewModel.randomBreeds.count == self.count)
        }
    }

    // MARK: Helpers

    private static func makeViewModel(itemCount: Int) -> RandomBreedsViewModel {
        RandomBreedsViewModel(itemCount: itemCount)
    }
}
