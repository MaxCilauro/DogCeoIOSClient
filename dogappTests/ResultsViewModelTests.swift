//
//  ResultsViewModelTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("ResultsViewModel")
struct ResultsViewModelTests {

    @MainActor
    @Suite("With breeds to search")
    struct WithBreeds {
        private let viewModel = ResultsViewModel.makeStub()

        private var content: ResultsViewModel.Content {
            self.viewModel.content(for: DogCeo.Breed.stubs)
        }

        // MARK: Blank query

        @Test(arguments: ["", "   "])
        func blankQueryShowsTheHistory(query: String) {
            self.viewModel.query = query

            #expect(self.content == .searchHistory)
        }

        // MARK: Sections

        @Test func breedNameMatchGoesToBreeds() {
            self.viewModel.query = "akita"

            #expect(self.content.breedTitles == ["Akita"])
            #expect(self.content.variationTitles == [])
        }

        @Test func subBreedMatchGoesToVariations() {
            self.viewModel.query = "french"

            #expect(self.content.breedTitles == [])
            #expect(self.content.variationTitles == ["French Bulldog"])
        }

        @Test func queryCanMatchBothSections() {
            self.viewModel.query = "bor"

            #expect(self.content.breedTitles == ["Borzoi", "Border Collie"])
            #expect(self.content.variationTitles == ["Border Terrier"])
        }

        @Test func breedMatchDoesNotShowItsVariations() {
            self.viewModel.query = "terrier"

            #expect(self.content.breedTitles == ["Terrier"])
            #expect(self.content.variationTitles == [])
        }

        @Test func variationMatchesWhenTheQuerySpansSubBreedAndBreed() {
            self.viewModel.query = "border ter"

            #expect(self.content.breedTitles == [])
            #expect(self.content.variationTitles == ["Border Terrier"])
        }

        @Test func breedWithASingleSubBreedIsOnlyInBreeds() {
            self.viewModel.query = "collie"

            #expect(self.content.breedTitles == ["Border Collie"])
            #expect(self.content.variationTitles == [])
        }

        // MARK: Matching

        @Test func matchesInTheMiddleOfAWord() {
            self.viewModel.query = "bone"

            #expect(self.content.breedTitles == ["Redbone"])
        }

        @Test func matchingIgnoresCaseAndDiacritics() {
            self.viewModel.query = "BÓXER"

            #expect(self.content.breedTitles == ["Boxer"])
        }

        @Test func queryIsTrimmed() {
            self.viewModel.query = "  akita  "

            #expect(self.content.breedTitles == ["Akita"])
        }

        @Test func matchedRangeCoversTheQueryInTheTitle() throws {
            self.viewModel.query = "bone"

            let redbone = try #require(self.content.breeds.first)

            #expect(redbone.title[redbone.matchedRange] == "bone")
        }

        // MARK: No results

        @Test func noMatchesShowsNoResultsWithTheTrimmedQuery() {
            self.viewModel.query = " zzz "

            #expect(self.content == .noResults(query: "zzz"))
        }
    }

    @MainActor
    @Suite("With no breeds to search")
    struct WithoutBreeds {
        private let viewModel = ResultsViewModel.makeStub(query: "akita")

        @Test func queryShowsNoResults() {
            #expect(self.viewModel.content(for: []) == .noResults(query: "akita"))
        }
    }

    @MainActor
    @Suite("With stored search history")
    struct WithSearchHistory {
        private let store = StubValueStore(values: SearchHistoryItem.stubs)
        private let viewModel: ResultsViewModel

        private var content: ResultsViewModel.Content {
            self.viewModel.content(for: DogCeo.Breed.stubs)
        }

        init() {
            self.viewModel = .makeStub(searchHistory: .makeStub(store: self.store))
        }

        @Test func queryShowsResultsInsteadOfTheHistory() {
            self.viewModel.query = "akita"

            #expect(self.content.breedTitles == ["Akita"])
        }

        @Test func selectingAResultRecordsItInTheHistory() async throws {
            self.viewModel.query = "boxer"
            let boxer = try #require(self.content.breeds.first)

            try await self.viewModel.select(boxer)

            #expect(self.store.state.value?.first?.title == "Boxer")
            #expect(self.store.state.value?.count == SearchHistoryItem.stubs.count + 1)
        }

        @Test func selectingAVariationRecordsItsSubBreed() async throws {
            self.viewModel.query = "english"
            let englishBulldog = try #require(self.content.variations.first)

            try await self.viewModel.select(englishBulldog)

            let item = try #require(self.store.state.value?.first)
            #expect(item.breed.name == "bulldog")
            #expect(item.subBreed == "english")
            #expect(item.title == "English Bulldog")
            #expect(self.store.state.value?.count == SearchHistoryItem.stubs.count + 1)
        }
    }

    @MainActor
    @Suite("With search history that cannot be saved")
    struct UnsavableSearchHistory {
        private let viewModel = ResultsViewModel.makeStub(
            query: "boxer",
            searchHistory: .makeStub(store: StubValueStore<SearchHistoryItem>(writeError: StubError()))
        )

        @Test func selectingAResultThrows() async throws {
            let boxer = try #require(self.viewModel.content(for: DogCeo.Breed.stubs).breeds.first)

            await #expect(throws: StubError.self) {
                try await self.viewModel.select(boxer)
            }
        }
    }
}

// MARK: Helpers

private extension ResultsViewModel.Content {
    var breeds: [BreedSearchResult] {
        guard case .results(let breeds, _) = self else {
            return []
        }

        return breeds
    }

    var variations: [BreedSearchResult] {
        guard case .results(_, let variations) = self else {
            return []
        }

        return variations
    }

    var breedTitles: [String] {
        self.breeds.map(\.title)
    }

    var variationTitles: [String] {
        self.variations.map(\.title)
    }
}
