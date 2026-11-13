//
//  Dependencies.swift
//
//

protocol Dependencies {
    var imageCacheManager: ImageCacheManager { get }

    var favouriteStore: any ValueStoring<Favourite> { get }
    var searchHistoryStore: any ValueStoring<SearchHistoryItem> { get }
    
    var breedProvider: any LoadingProvider<DogCeo.Breed> { get }

    func makeBreedImagesProvider(for breed: DogCeo.Breed) -> any LoadingProvider<DogCeo.BreedImage>
    func makeRandomImagesProvider(count: Int) -> any LoadingProvider<DogCeo.BreedImage>
}
