//
//  FetchSpy.swift
//Tests
//

import Foundation

@testable import dogapp

@MainActor
final class FetchSpy<Value> {
    struct Response {
        let result: Result<[Value], Error>
        var delay: Duration = .zero
    }

    private(set) var callCount = 0
    var onFetch: (() -> Void)?

    private var responses: [Response]

    init(responses: [Response]) {
        self.responses = responses
    }

    func fetch() async throws -> [Value] {
        self.callCount += 1
        self.onFetch?()

        let response = self.responses.removeFirst()

        if response.delay > .zero {
            try? await Task.sleep(for: response.delay)
        }

        return try response.result.get()
    }

    func waitUntilCalled(times: Int) async {
        while self.callCount < times {
            await Task.yield()
        }
    }
}
