//
//  ResultsViewModel.swift
//
//

import Foundation

@Observable
final class ResultsViewModel {
    enum Content: Equatable {
        case searchHistory
        case results(breeds: [BreedSearchResult], variations: [BreedSearchResult])
        case noResults(query: String)
    }

    var query = ""

    let searchHistory: SearchHistoryViewModel

    private var trimmedQuery: String {
        self.query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(searchHistory: SearchHistoryViewModel) {
        self.searchHistory = searchHistory
    }

    func select(_ result: BreedSearchResult) async throws {
        try await self.searchHistory.record(result)
    }

    func content(for breeds: [DogCeo.Breed]) -> Content {
        let query = self.trimmedQuery

        guard !query.isEmpty else {
            return .searchHistory
        }

        let breedResults = breeds.compactMap { breed in
            self.makeResult(
                breed: breed,
                subBreed: nil,
                query: query
            )
        }

        let variationResults = breeds
            .filter { $0.subBreeds.count > 1 }
            .flatMap { breed in
                breed.subBreeds.compactMap { subBreed in
                    self.makeResult(
                        breed: breed,
                        subBreed: subBreed,
                        query: query
                    )
                }
            }

        guard !breedResults.isEmpty || !variationResults.isEmpty else {
            return .noResults(query: query)
        }

        return .results(breeds: breedResults, variations: variationResults)
    }

    private func makeResult(
        breed: DogCeo.Breed,
        subBreed: String?,
        query: String
    ) -> BreedSearchResult? {
        let title = breed.displayName(subBreed: subBreed)

        guard let matchedRange = title.localizedStandardRange(of: query) else {
            return nil
        }

        if let subBreed {
            guard
                let subBreedRange = title.range(of: DogCeo.displayName(for: subBreed)),
                matchedRange.overlaps(subBreedRange)
            else {
                return nil
            }
        }

        return BreedSearchResult(
            breed: breed,
            subBreed: subBreed,
            title: title,
            matchedRange: matchedRange
        )
    }
}
