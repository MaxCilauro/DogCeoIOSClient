//
//  SearchHistoryViewModelTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("SearchHistoryViewModel")
struct SearchHistoryViewModelTests {
    private static let boxer: BreedSearchResult = {
        let title = "Boxer"

        return BreedSearchResult(
            breed: DogCeo.Breed(name: "boxer", subBreeds: []),
            subBreed: nil,
            title: title,
            matchedRange: title.startIndex..<title.endIndex
        )
    }()

    @MainActor
    @Suite("With stored history")
    struct StoredHistory {
        private let viewModel = SearchHistoryViewModel.makeStub(items: SearchHistoryItem.stubs)

        @Test func showsTheStoredItems() {
            #expect(self.viewModel.items == SearchHistoryItem.stubs)
        }

        @Test func recordingAResultPutsItAtTheFront() async throws {
            try await self.viewModel.record(boxer)

            #expect(self.viewModel.items.map(\.id) == [boxer.id] + SearchHistoryItem.stubs.map(\.id))
        }

        @Test func selectingAnItemMovesItToTheFront() async throws {
            let last = try #require(SearchHistoryItem.stubs.last)

            try await self.viewModel.select(last)

            #expect(self.viewModel.items.map(\.id) == [last.id] + SearchHistoryItem.stubs.dropLast().map(\.id))
        }

        @Test func removingRemovesOnlyThatEntry() async throws {
            let first = try #require(SearchHistoryItem.stubs.first)

            try await self.viewModel.remove(first)

            #expect(self.viewModel.items.map(\.id) == SearchHistoryItem.stubs.dropFirst().map(\.id))
        }

        @Test func clearingEmptiesTheHistory() async throws {
            try await self.viewModel.clear()

            #expect(self.viewModel.items.isEmpty)
        }
    }

    @MainActor
    @Suite("With history that failed to load")
    struct FailedHistory {
        private let viewModel = SearchHistoryViewModel.makeStub(store: StubValueStore(state: .failed(StubError())))

        @Test func showsNoItems() {
            #expect(self.viewModel.items.isEmpty)
        }
    }

    @MainActor
    @Suite("With history that cannot be saved")
    struct UnsavableHistory {
        private let viewModel = SearchHistoryViewModel.makeStub(
            store: StubValueStore(values: SearchHistoryItem.stubs, writeError: StubError())
        )
        private let item = SearchHistoryItem.stubs[0]

        @Test func recordingThrows() async {
            await #expect(throws: StubError.self) {
                try await self.viewModel.record(boxer)
            }

            #expect(self.viewModel.items == SearchHistoryItem.stubs)
        }

        @Test func selectingThrows() async {
            await #expect(throws: StubError.self) {
                try await self.viewModel.select(self.item)
            }

            #expect(self.viewModel.items == SearchHistoryItem.stubs)
        }

        @Test func removingThrows() async {
            await #expect(throws: StubError.self) {
                try await self.viewModel.remove(self.item)
            }

            #expect(self.viewModel.items == SearchHistoryItem.stubs)
        }

        @Test func clearingThrows() async {
            await #expect(throws: StubError.self) {
                try await self.viewModel.clear()
            }

            #expect(self.viewModel.items == SearchHistoryItem.stubs)
        }
    }
}
