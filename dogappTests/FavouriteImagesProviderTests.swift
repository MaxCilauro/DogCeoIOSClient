//
//  FavouriteImagesProviderTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("FavouriteImagesProvider")
struct FavouriteImagesProviderTests {
    private static let afghan = DogCeo.BreedImage(
        url: URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!,
        breed: "hound",
        subBreed: "afghan"
    )
    private static let basset = DogCeo.BreedImage(
        url: URL(string: "https://images.dog.ceo/breeds/hound-basset/n02088238_10005.jpg")!,
        breed: "hound",
        subBreed: "basset"
    )

    @MainActor
    @Suite("With no stored favourites")
    struct EmptyStore {
        private let defaults: TestUserDefaults
        private let store: UserDefaultValueStore<Favourite>
        private let provider: FavouriteImagesProvider

        init() throws {
            self.defaults = try TestUserDefaults()
            self.store = self.defaults.makeFavouriteStore()
            self.provider = FavouriteImagesProvider(store: self.store)
        }

        @Test func initialStateIsLoading() {
            #expect(self.provider.state.isLoading)
        }

        @Test func firstLoadOfFavouritesIsEmpty() async {
            await self.provider.loadIfNeeded()

            #expect(self.provider.state.value == [])
        }

        @Test func addsImagesNewestFirst() async throws {
            await self.provider.loadIfNeeded()

            try await self.store.insert(.init(image: afghan))
            try await self.store.insert(.init(image: basset))

            #expect(self.provider.state.value == [basset, afghan])
        }
    }

    @MainActor
    @Suite("With stored favourites")
    struct StoreWithFavourites {
        private let defaults: TestUserDefaults
        private let store: UserDefaultValueStore<Favourite>
        private let provider: FavouriteImagesProvider

        private let favourite = Favourite(image: basset)

        init() async throws {
            self.defaults = try TestUserDefaults()

            self.defaults.favouritesData = try JSONEncoder().encode([self.favourite])

            self.store = self.defaults.makeFavouriteStore()
            self.provider = FavouriteImagesProvider(store: self.store)
        }

        @Test func loadRetrievesStoredFavourites() async {
            await self.provider.loadIfNeeded()

            #expect(self.provider.state.value == [basset])
        }

        @Test func insertingWithoutPreloadUpdatesStateToLoaded() async throws {
            try await self.store.insert(.init(image: afghan))

            #expect(self.provider.state.isLoaded)
            #expect(self.provider.state.value == [afghan, basset])
        }

        @Test func removalUpdatesState() async throws {
            await self.provider.loadIfNeeded()

            try await self.store.insert(.init(image: afghan))
            try #require(self.provider.state.value == [afghan, basset])

            try await self.store.remove(afghan.id)

            #expect(self.provider.state.value == [basset])
        }

        @Test func removingWithoutPreloadUpdatesStateToLoaded() async throws {
            try await self.store.remove(self.favourite.id)

            #expect(self.provider.state.isLoaded)
            #expect(self.provider.state.value == [])
        }
    }

    @MainActor
    @Suite("With corrupt stored data")
    struct CorruptStoredData {
        private let defaults: TestUserDefaults
        private let provider: FavouriteImagesProvider

        init() throws {
            self.defaults = try TestUserDefaults()
            self.defaults.favouritesData = TestUserDefaults.corruptData
            self.provider = FavouriteImagesProvider(store: self.defaults.makeFavouriteStore())
        }

        @Test func loadWithCorruptStoredDataFails() async {
            await self.provider.loadIfNeeded()

            #expect(self.provider.state.isFailed)
        }
    }
}
