//
//  Results.swift
//
//

import SwiftUI

struct Results: View {
    @Environment(\.navigateTo) private var navigateTo

    let viewModel: ResultsViewModel
    let breeds: [DogCeo.Breed]

    var body: some View {
        switch self.viewModel.content(for: self.breeds) {
        case .searchHistory:
            SearchHistory(viewModel: self.viewModel.searchHistory)
        case .noResults(let query):
            StatusOverlay(stateCopy: .noResults(query: query))
        case .results(let breedResults, let variationResults):
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    self.section(
                        title: String(localized: .breedsTitle),
                        results: breedResults
                    )
                    self.section(
                        title: String(localized: .variations),
                        results: variationResults
                    )
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
        }
    }

    @ViewBuilder
    private func section(title: String, results: [BreedSearchResult]) -> some View {
        if !results.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.headline)
                    .padding(.horizontal)
                VStack {
                    ForEach(results) { result in
                        Button {
                            Task {
                                try? await self.viewModel.select(result)
                                self.navigateTo(.imageGrid(breed: result.breed))
                            }
                        } label: {
                            BreedItem(title: .highlighted(result.title, match: result.matchedRange))
                        }
                        .buttonStyle(CardButtonStyle())
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview("Results") {
    Results(viewModel: .makeStub(query: "bor"), breeds: DogCeo.Breed.stubs)
}

#Preview("No results") {
    Results(viewModel: .makeStub(query: "zzz"), breeds: DogCeo.Breed.stubs)
}

#Preview("History") {
    Results(
        viewModel: .makeStub(searchHistory: .makeStub(items: SearchHistoryItem.stubs)),
        breeds: DogCeo.Breed.stubs
    )
}

#Preview("Empty history") {
    Results(viewModel: .makeStub(), breeds: DogCeo.Breed.stubs)
}
