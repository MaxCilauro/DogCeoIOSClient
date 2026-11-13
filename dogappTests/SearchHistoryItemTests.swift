//
//  SearchHistoryItemTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("SearchHistoryItem")
struct SearchHistoryItemTests {

    @Test func survivesAnEncodeDecodeRoundTrip() throws {
        let data = try JSONEncoder().encode(SearchHistoryItem.stubs)

        let decoded = try JSONDecoder().decode([SearchHistoryItem].self, from: data)

        #expect(decoded == SearchHistoryItem.stubs)
    }

    @Test func titleOfAVariationIncludesTheSubBreed() {
        let item = SearchHistoryItem(
            breed: DogCeo.Breed(name: "bulldog", subBreeds: ["boston", "english", "french"]),
            subBreed: "french"
        )

        #expect(item.title == "French Bulldog")
    }

    @Test func titleOfABreedWithASingleSubBreedMatchesTheBreedName() {
        let item = SearchHistoryItem(
            breed: DogCeo.Breed(name: "collie", subBreeds: ["border"]),
            subBreed: nil
        )

        #expect(item.title == "Border Collie")
    }

    @Test func titleMatchesTheSearchResultItWasCreatedFrom() throws {
        let viewModel = ResultsViewModel.makeStub(query: "collie")
        guard case .results(let breeds, _) = viewModel.content(for: DogCeo.Breed.stubs) else {
            Issue.record("Expected results")
            return
        }
        let result = try #require(breeds.first)

        #expect(SearchHistoryItem(result: result).title == result.title)
    }
}
