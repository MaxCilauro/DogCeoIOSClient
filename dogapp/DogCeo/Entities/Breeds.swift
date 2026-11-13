//
//  Breeds.swift
//
//

import Foundation

enum DogCeo {
    nonisolated struct Breed: Codable, Sendable, Hashable {
        let name: String
        let subBreeds: [String]
        
        var displayName: String {
            DogCeo.displayName(for: name, subBreed: self.subBreeds.count == 1 ? subBreeds.first : nil)
        }
        
        func displayName(subBreed: String?) -> String {
            guard let subBreed else {
                return self.displayName
            }
            
            return DogCeo.displayName(for: self.name, subBreed: subBreed)
        }
        
        public init(name: String, subBreeds: [String]) {
            self.name = name
            self.subBreeds = subBreeds
        }
    }
    
    
    nonisolated struct BreedsResponse: Decodable {
        let breeds: [Breed]
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            self.breeds = try container.decode([String: [String]].self).map { breed, subBreeds in
                    .init(name: breed, subBreeds: subBreeds.sorted())
            }
            .sorted { $0.displayName < $1.displayName }
        }
    }
}

extension DogCeo.Breed: Identifiable {
    var id: String {
        self.displayName
    }
}
