//
//  Endpoints.swift
//
//


import Foundation

extension DogCeo.API {
    private static let baseURL: URL = URL(string: "https://dog.ceo/api")!
    
    static let breedsList: URL = baseURL.appendingPathComponent("breeds/list/all")
    
    static func getImages(for breed: String, subBreed: String? = nil) -> URL {
        guard let subBreed else {
            return baseURL.appendingPathComponent("breed/\(breed)/images")
        }
        
        return baseURL.appendingPathComponent("breed/\(breed)/\(subBreed)/images")
    }
    
    static func getRandomImages(count: Int? = nil) -> URL {
        guard let count else {
            return baseURL.appendingPathComponent("breeds/image/random")
        }
        
        return baseURL.appendingPathComponent("breeds/image/random/\(String(count))")
    }
}
