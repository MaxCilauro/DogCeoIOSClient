//
//  BreedListViewModel.swift
//
//

import Foundation

@Observable
final class BreedListViewModel {
    var state: LoadingState<[DogCeo.Breed], Error> {
        self.provider.state
    }

    var subtitle: String? {
        switch self.state {
        case .loading, .failed:
            return nil
        case .loaded(let breeds):
            let breedCount = String(localized: .breedCount(breeds.count))
            let varietyCount = String(localized: .varietyCount(breeds.subBreedCount))

            return String(localized: .breedsSummary(breedCount, varietyCount))
        }
    }

    private let provider: any LoadingProvider<DogCeo.Breed>

    init(provider: any LoadingProvider<DogCeo.Breed>) {
        self.provider = provider
    }

    func loadIfNeeded() async {
        await self.provider.loadIfNeeded()
    }
}
