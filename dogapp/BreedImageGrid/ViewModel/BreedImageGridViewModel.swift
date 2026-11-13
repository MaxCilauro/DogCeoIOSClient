//
//  BreedImageGridViewModel.swift
//
//

import Foundation
import Observation

@Observable
final class BreedImageGridViewModel {

    typealias State = LoadingState<[DogCeo.BreedImage], Error>

    var title: String {
        self.configuration.title
    }

    var subtitle: String? {
        switch self.state {
        case .loading:
            return self.configuration.loadingSubtitle
        case .loaded(let images):
            return images.isEmpty ? nil : String(localized: .pictureCount(images.count))
        case .failed:
            return nil
        }
    }

    var emptyStateCopy: StateCopy {
        self.configuration.emptyStateCopy
    }

    var errorStateCopy: StateCopy {
        self.configuration.errorStateCopy
    }

    var state: State {
        provider.state
    }

    private let configuration: Configuration
    private let provider: any LoadingProvider<DogCeo.BreedImage>

    init(
        configuration: Configuration,
        provider: any LoadingProvider<DogCeo.BreedImage>
    ) {
        self.configuration = configuration
        self.provider = provider
    }

    func positionTitle(for image: DogCeo.BreedImage, at index: Int) -> String {
        image.positionTitle(index: index, count: self.state.value?.count ?? 0)
    }

    func loadIfNeeded() async {
        await self.provider.loadIfNeeded()
    }
}
