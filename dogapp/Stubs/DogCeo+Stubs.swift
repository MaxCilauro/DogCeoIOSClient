//
//  DogCeo+Stubs.swift
//
//

import Foundation

extension DogCeo.Breed {
    static let stubs: [DogCeo.Breed] = [
        DogCeo.Breed(
            name: "akita",
            subBreeds: []
        ),
        DogCeo.Breed(
            name: "borzoi",
            subBreeds: []
        ),
        DogCeo.Breed(
            name: "bouvier",
            subBreeds: []
        ),
        DogCeo.Breed(
            name: "boxer",
            subBreeds: []
        ),
        DogCeo.Breed(
            name: "bulldog",
            subBreeds: [
                "boston",
                "english",
                "french"
            ]
        ),
        DogCeo.Breed(
            name: "collie",
            subBreeds: ["border"]
        ),
        DogCeo.Breed(
            name: "hound",
            subBreeds: [
                "afghan",
                "basset"
            ]
        ),
        DogCeo.Breed(
            name: "redbone",
            subBreeds: []
        ),
        DogCeo.Breed(
            name: "terrier",
            subBreeds: [
                "border",
                "boston",
                "yorkshire"
            ]
        ),
    ]
}

extension DogCeo.BreedImage {
    static let stubs: [DogCeo.BreedImage] = [
        DogCeo.BreedImage(
            url: URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!,
            breed: "hound",
            subBreed: "afghan"
        ),
        DogCeo.BreedImage(
            url: URL(string: "https://images.dog.ceo/breeds/hound-basset/n02088238_10005.jpg")!,
            breed: "hound",
            subBreed: "basset"
        ),
        DogCeo.BreedImage(
            url: URL(string: "https://images.dog.ceo/breeds/akita/512px-Ainu-Dog.jpg")!,
            breed: "akita"
        ),
        DogCeo.BreedImage(
            url: URL(string: "https://images.dog.ceo/breeds/hound-blood/n02088466_7167.jpg")!,
            breed: "hound",
            subBreed: "blood"
        ),
        DogCeo.BreedImage(
            url: URL(string: "https://images.dog.ceo/breeds/mix/tropik.jpg")!,
            breed: "mix"
        ),
    ]
}
