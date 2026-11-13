//
//  UserDefaultValueStoreTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("UserDefaultValueStore")
struct UserDefaultValueStoreTests {
    private static let afghan = makeFavourite(
        url: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg",
        breed: "hound",
        subBreed: "afghan"
    )
    private static let basset = makeFavourite(
        url: "https://images.dog.ceo/breeds/hound-basset/n02088238_10005.jpg",
        breed: "hound",
        subBreed: "basset"
    )
    private static let akita = makeFavourite(
        url: "https://images.dog.ceo/breeds/akita/512px-Ainu-Dog.jpg",
        breed: "akita"
    )

    @MainActor
    @Suite("With no stored values")
    struct EmptyStore {
        private let defaults: TestUserDefaults
        private let store: UserDefaultValueStore<Favourite>

        init() throws {
            self.defaults = try TestUserDefaults()
            self.store = self.defaults.makeFavouriteStore()
        }

        // MARK: Load

        @Test func initialStateIsLoading() {
            #expect(self.store.state.isLoading)
        }

        @Test func loadIsEmpty() async {
            await self.store.loadIfNeeded()

            #expect(ids(in: self.store) == [])
        }

        @Test func loadedStoreContainsNothing() async {
            await self.store.loadIfNeeded()

            #expect(!self.store.contains(afghan.id))
        }

        // MARK: Insert

        @Test func insertMakesValueContained() async throws {
            try await self.store.insert(afghan)

            #expect(self.store.contains(afghan.id))
        }

        @Test func insertsArePersistedNewestFirst() async throws {
            try await self.store.insert(afghan)
            try await self.store.insert(basset)

            #expect(await persistedIDs(in: self.defaults) == [basset.id, afghan.id])
        }

        @Test func insertingTheSameValueTwiceStoresItOnce() async throws {
            try await self.store.insert(afghan)
            try await self.store.insert(afghan)

            #expect(ids(in: self.store) == [afghan.id])
        }

        @Test func insertPutsNewestFirst() async throws {
            try await self.store.insert(afghan)
            try await self.store.insert(basset)
            try await self.store.insert(akita)

            #expect(ids(in: self.store) == [akita.id, basset.id, afghan.id])
        }
    }

    @MainActor
    @Suite("With stored values")
    struct StoredValues {
        private let defaults: TestUserDefaults
        private let store: UserDefaultValueStore<Favourite>

        init() throws {
            self.defaults = try TestUserDefaults()

            self.defaults.favouritesData = try JSONEncoder().encode([basset, afghan])
            self.store = self.defaults.makeFavouriteStore()
        }

        // MARK: Load

        @Test func loadReturnsStoredValues() async {
            await self.store.loadIfNeeded()

            #expect(ids(in: self.store) == [basset.id, afghan.id])
        }

        @Test func containsIsFalseBeforeLoading() {
            #expect(!self.store.contains(afghan.id))
        }

        @Test func containsMatchesById() async {
            await self.store.loadIfNeeded()

            let sameImage = Favourite(image: afghan.image)

            #expect(self.store.contains(sameImage.id))
        }

        // MARK: Insert

        @Test func insertingAnExistingValueMovesItToTheFront() async throws {
            try await self.store.insert(afghan)

            #expect(ids(in: self.store) == [afghan.id, basset.id])
        }

        // MARK: Remove

        @Test func removeMakesValueNotContained() async throws {
            try await self.store.remove(afghan.id)

            #expect(!self.store.contains(afghan.id))
            #expect(self.store.contains(basset.id))
        }

        @Test func removeIsPersisted() async throws {
            try await self.store.remove(afghan.id)

            #expect(await persistedIDs(in: self.defaults) == [basset.id])
        }

        @Test func removingAnUnknownValueKeepsTheOthers() async throws {
            try await self.store.remove(akita.id)

            #expect(ids(in: self.store) == [basset.id, afghan.id])
        }

        // MARK: Remove all

        @Test func removeAllEmptiesTheStore() async throws {
            try await self.store.removeAll()

            #expect(ids(in: self.store) == [])
        }

        @Test func removeAllIsPersisted() async throws {
            try await self.store.removeAll()

            #expect(await persistedIDs(in: self.defaults) == [])
        }
    }

    @MainActor
    @Suite("With a limit of two values")
    struct LimitOfTwo {
        private let defaults: TestUserDefaults
        private let store: UserDefaultValueStore<Favourite>

        init() throws {
            self.defaults = try TestUserDefaults()

            self.defaults.favouritesData = try JSONEncoder().encode([basset, afghan])
            self.store = self.defaults.makeFavouriteStore(limit: 2)
        }

        @Test func insertBeyondTheLimitDropsTheOldest() async throws {
            try await self.store.insert(akita)

            #expect(ids(in: self.store) == [akita.id, basset.id])
        }

        @Test func limitIsPersisted() async throws {
            try await self.store.insert(akita)

            #expect(await persistedIDs(in: self.defaults) == [akita.id, basset.id])
        }

        @Test func movingAnExistingValueToTheFrontDropsNothing() async throws {
            try await self.store.insert(afghan)

            #expect(ids(in: self.store) == [afghan.id, basset.id])
        }
    }

    @MainActor
    @Suite("With corrupt stored data")
    struct CorruptStoredData {
        private let defaults: TestUserDefaults
        private let store: UserDefaultValueStore<Favourite>

        init() throws {
            self.defaults = try TestUserDefaults()
            self.defaults.favouritesData = TestUserDefaults.corruptData
            self.store = self.defaults.makeFavouriteStore()
        }

        @Test func loadFails() async {
            await self.store.loadIfNeeded()

            #expect(self.store.state.isFailed)
        }

        @Test func insertThrowsAndKeepsTheData() async {
            await #expect(throws: (any Error).self) {
                try await self.store.insert(afghan)
            }

            #expect(self.defaults.favouritesData == TestUserDefaults.corruptData)
            #expect(!self.store.contains(afghan.id))
        }

        @Test func removeThrowsAndKeepsTheData() async {
            await #expect(throws: (any Error).self) {
                try await self.store.remove(afghan.id)
            }

            #expect(self.defaults.favouritesData == TestUserDefaults.corruptData)
        }
    }

    // MARK: Helpers

    private static func makeFavourite(url: String, breed: String, subBreed: String? = nil) -> Favourite {
        Favourite(image: DogCeo.BreedImage(url: URL(string: url)!, breed: breed, subBreed: subBreed))
    }

    private static func ids(in store: UserDefaultValueStore<Favourite>) -> [URL]? {
        store.state.value?.map(\.id)
    }

    private static func persistedIDs(in defaults: TestUserDefaults) async -> [URL]? {
        let reloadedStore = defaults.makeFavouriteStore()
        await reloadedStore.loadIfNeeded()

        return ids(in: reloadedStore)
    }
}
