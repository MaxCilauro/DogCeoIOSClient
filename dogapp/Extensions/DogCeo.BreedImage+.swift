//
//  DogCeo.BreedImage+.swift
//
//

import Foundation

extension DogCeo.BreedImage {
    static func position(index: Int, count: Int) -> String {
        String(localized: .imagePosition(index + 1, count))
    }

    func positionTitle(index: Int, count: Int) -> String {
        String(localized: .imagePositionTitle(self.displayName, Self.position(index: index, count: count)))
    }
}
