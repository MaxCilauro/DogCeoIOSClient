//
//  BreedSearch.swift
//
//

import SwiftUI

struct BreedSearch: View {
    let viewModel: BreedSearchViewModel
    let imageCacheManager: ImageCacheManager
    var navigateTo: (Destination) -> Void = { _ in }

    var body: some View {
        ZStack {
            switch self.viewModel.state {
            case .loading:
                ProgressView()
            case .failed:
                StatusOverlay(stateCopy: .genericError) {
                    Task {
                        await self.viewModel.loadIfNeeded()
                    }
                }
            case .loaded(let breeds):
                if self.viewModel.isSearchActive {
                    Results(viewModel: self.viewModel.results, breeds: breeds)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            RandomBreeds(
                                viewModel: self.viewModel.randomBreeds,
                                breeds: breeds
                            )
                            RandomPoochies(viewModel: self.viewModel.randomPoochies)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.navigateTo, self.navigateTo)
        .environment(\.imageCacheManager, self.imageCacheManager)
        .task {
            await self.viewModel.loadIfNeeded()
        }
    }
}

private extension BreedSearch {
    static func makePreview(breedsState: LoadingState<[DogCeo.Breed], Error>) -> BreedSearch {
        BreedSearch(
            viewModel: .init(
                provider: StubProvider(state: breedsState),
                results: .makeStub(),
                randomPoochies: .init(
                    rows: 2,
                    columns: 2,
                    provider: StubProvider(values: DogCeo.BreedImage.stubs),
                ),
                randomBreeds: .init(itemCount: 3)
            ),
            imageCacheManager: ImageCacheManager(cache: ImageCache(), fetch: URLSession.shared.validatedData(from:))
        )
    }
}

#Preview("Loaded") {
    BreedSearch.makePreview(breedsState: .loaded(DogCeo.Breed.stubs))
}

#Preview("Loading") {
    BreedSearch.makePreview(breedsState: .loading)
}

#Preview("Failed") {
    BreedSearch.makePreview(breedsState: .failed(StubError()))
}
