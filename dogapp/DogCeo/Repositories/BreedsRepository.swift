//
//  BreedsRepository.swift
//
//

import Foundation

extension DogCeo {
    class Repository: Sendable {
        let URLSession: URLSession
        let decoder: JSONDecoder
        
        init(URLSession: URLSession = .shared, JSONDecoder: JSONDecoder = .init()) {
            self.URLSession = URLSession
            self.decoder = JSONDecoder
        }
        
        @concurrent
        func getBreeds() async throws -> [Breed] {
            let (data, _) = try await self.URLSession.data(from: API.breedsList)
            
            return try decoder.decode(API.Response<BreedsResponse>.self, from: data).message.breeds
        }
        
        @concurrent
        func getImages(for breed: String, subBreed: String? = nil) async throws -> [BreedImage] {
            let (data, _) = try await self.URLSession.data(from: API.getImages(for: breed, subBreed: subBreed))
            
            return try decoder.decode(API.Response<BreedImages>.self, from: data).message.images
        }
        
        @concurrent
        func getRandomImages(count: Int? = nil) async throws -> [BreedImage] {
            let (data, _) = try await self.URLSession.data(from: API.getRandomImages(count: count))

            var seen = Set<DogCeo.BreedImage>()
            let images = try decoder.decode(API.Response<BreedImages>.self, from: data).message.images

            return images.filter { seen.insert($0).inserted }
        }
    }
}
