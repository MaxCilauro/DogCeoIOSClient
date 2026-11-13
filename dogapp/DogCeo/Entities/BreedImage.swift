//
//  BreedImage.swift
//
//

import Foundation

extension DogCeo {
    
    nonisolated struct BreedImages: Decodable {
        let images: [BreedImage]
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            self.images = try container.decode([BreedImage].self)
        }
    }

    nonisolated struct BreedImage: Codable, Hashable, Sendable {
        let url: URL
        let breed: String
        let subBreed: String?
        
        var displayName: String {
            DogCeo.displayName(for: breed, subBreed: subBreed)
        }
        
        public init(
            url: URL,
            breed: String,
            subBreed: String? = nil
        ) {
            self.url = url
            self.breed = breed
            self.subBreed = subBreed
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let url = try container.decode(URL.self)

            self.url = url
            
            let folder = url.deletingLastPathComponent().lastPathComponent
            let folderSplit = folder.split(separator: "-", maxSplits: 1).map { String($0) }
            
            guard let breed = folderSplit.first else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Image URL has no breed folder: \(url)"
                )
            }
            
            self.breed = breed
            self.subBreed = folderSplit.dropFirst().first
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.url)
        }
    }
}

extension DogCeo.BreedImage: Identifiable {
    var id: URL { self.url }
}
