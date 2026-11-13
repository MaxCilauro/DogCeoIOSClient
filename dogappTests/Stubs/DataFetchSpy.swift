//
//  DataFetchSpy.swift
//Tests
//

import Foundation

@MainActor
final class DataFetchSpy {
    private(set) var requestedURLs: [URL] = []

    private let result: Result<Data, Error>

    init(result: Result<Data, Error>) {
        self.result = result
    }

    func fetch(_ url: URL) async throws -> Data {
        self.requestedURLs.append(url)

        return try self.result.get()
    }
}
