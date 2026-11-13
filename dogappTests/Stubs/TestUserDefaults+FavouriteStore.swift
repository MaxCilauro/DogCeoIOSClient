//
//  TestUserDefaults+FavouriteStore.swift
//Tests
//

import Foundation

@testable import dogapp

extension TestUserDefaults {
    static let corruptData = Data("not json".utf8)

    private static let favouritesKey = "DOGGIE_FAVOURITES.v1"

    var favouritesData: Data? {
        get {
            self.userDefaults.data(forKey: Self.favouritesKey)
        }
        set {
            self.userDefaults.set(newValue, forKey: Self.favouritesKey)
        }
    }

    func makeFavouriteStore(limit: Int? = nil) -> UserDefaultValueStore<Favourite> {
        UserDefaultValueStore(key: Self.favouritesKey, limit: limit, userDefaults: self.userDefaults)
    }
}
