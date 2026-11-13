//
//  DogCeo.Breed+.swift
//
//

extension Array where Element == DogCeo.Breed {
    var subBreedCount: Int {
        self.reduce(0) { partialResult, breed in
            partialResult + breed.subBreeds.count
        }
    }
}
