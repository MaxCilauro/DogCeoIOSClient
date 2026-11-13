//
//  Dependencies.swift
//
//

import Foundation

final class AppDependencies: Dependencies {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let imageCache = ImageCache()
    private let urlSession = URLSession(configuration: .default)
    private let userDefaults: UserDefaults
    
    private lazy var dogCeoRepository = DogCeo.Repository(URLSession: self.urlSession, JSONDecoder: self.decoder)

    private(set) lazy var favouriteStore: any ValueStoring<Favourite> = UserDefaultValueStore<Favourite>(
        key: "DOGGIE_FAVOURITES.v1",
        userDefaults: self.userDefaults,
        jsonDecoder: self.decoder,
        jsonEncoder: self.encoder
    )
    private(set) lazy var searchHistoryStore: any ValueStoring<SearchHistoryItem> = UserDefaultValueStore<SearchHistoryItem>(
        key: "SEARCH_HISTORY.v1",
        limit: 15,
        userDefaults: self.userDefaults,
        jsonDecoder: self.decoder,
        jsonEncoder: self.encoder
    )
    private(set) lazy var breedProvider: any LoadingProvider<DogCeo.Breed> = RemoteProvider(self.dogCeoRepository.getBreeds)
    private(set) lazy var imageCacheManager = ImageCacheManager(
        cache: self.imageCache,
        fetch: self.urlSession.validatedData(from:)
    )
    
    init(userDefaultSuiteName: String = "com.yaku.dogapp.storage") {
        guard let userDefaults = UserDefaults(suiteName: userDefaultSuiteName) else {
           fatalError("Invalid UserDefaults suite name")
       }
        
        self.userDefaults = userDefaults
    }

    func makeBreedImagesProvider(for breed: DogCeo.Breed) -> any LoadingProvider<DogCeo.BreedImage> {
        RemoteProvider {
            try await self.dogCeoRepository.getImages(for: breed.name)
        }
    }

    func makeRandomImagesProvider(count: Int) -> any LoadingProvider<DogCeo.BreedImage> {
        RemoteProvider {
            try await self.dogCeoRepository.getRandomImages(count: count)
        }
    }
}

