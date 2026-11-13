//
//  RemoteProviderTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("RemoteProvider")
struct RemoteProviderTests {

    @MainActor
    @Suite("Before the first load")
    struct BeforeFirstLoad {
        private let spy = FetchSpy<Int>(responses: [.init(result: .success([1]), delay: .milliseconds(50))])
        private let provider: RemoteProvider<Int>

        init() {
            self.provider = RemoteProvider(self.spy.fetch)
        }

        @Test func initialStateIsLoading() {
            #expect(self.provider.state.isLoading)
        }

        @Test func nothingIsFetchedBeforeLoading() {
            #expect(self.spy.callCount == 0)
        }

        @Test func loadIfNeededReturnsOnceLoaded() async {
            await self.provider.loadIfNeeded()

            #expect(self.provider.state.value == [1])
        }

        @Test func concurrentLoadsFetchOnce() async {
            async let first: Void = self.provider.loadIfNeeded()
            async let second: Void = self.provider.loadIfNeeded()
            _ = await (first, second)

            #expect(self.spy.callCount == 1)
            #expect(self.provider.state.value == [1])
        }
    }

    @MainActor
    @Suite("After a successful load")
    struct Loaded {
        private let spy = FetchSpy<Int>(responses: [
            .init(result: .success([1])),
            .init(result: .success([2])),
        ])
        private let provider: RemoteProvider<Int>

        init() async {
            self.provider = RemoteProvider(self.spy.fetch)

            await self.provider.loadIfNeeded()
        }

        @Test func loadIfNeededDoesNotFetchAgain() async {
            await self.provider.loadIfNeeded()

            #expect(self.spy.callCount == 1)
        }
    }

    @MainActor
    @Suite("After a failed load")
    struct Failed {
        private let spy = FetchSpy<Int>(responses: [
            .init(result: .failure(StubError())),
            .init(result: .success([1])),
        ])
        private let provider: RemoteProvider<Int>

        init() async {
            self.provider = RemoteProvider(self.spy.fetch)

            await self.provider.loadIfNeeded()
        }

        @Test func stateIsFailed() {
            #expect(self.provider.state.isFailed)
        }

        @Test func loadIfNeededRetries() async {
            await self.provider.loadIfNeeded()

            #expect(self.provider.state.value == [1])
        }
    }
}
