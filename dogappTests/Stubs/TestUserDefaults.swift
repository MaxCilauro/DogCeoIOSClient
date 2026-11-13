//
//  TestUserDefaults.swift
//Tests
//

import Testing
import Foundation

@MainActor
final class TestUserDefaults {
    let userDefaults: UserDefaults

    private let suiteName: String

    init() throws {
        let suiteName = "TestUserDefaults.\(UUID().uuidString)"

        self.suiteName = suiteName
        self.userDefaults = try #require(UserDefaults(suiteName: suiteName))
    }

    deinit {
        UserDefaults().removePersistentDomain(forName: self.suiteName)
    }
}
