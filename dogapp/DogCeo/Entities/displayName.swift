//
//  displayNameFormat.swift
//
//

import Foundation

extension DogCeo {

    nonisolated static func displayName(for breed: String, subBreed: String? = nil) -> String {
        let breedName = breed.capitalized

        guard let subBreed else {
            return breedName
        }
        
        return "\(subBreed.capitalized) \(breedName)"
    }
}
