//
//  StubProvider.swift
//
//

import Foundation

@Observable
final class StubProvider<Value>: LoadingProvider {
    private(set) var state: LoadingState<[Value], Error>

    init(state: LoadingState<[Value], Error>) {
        self.state = state
    }

    convenience init(values: [Value]) {
        self.init(state: .loaded(values))
    }

    func loadIfNeeded() async {}

    func refresh() async {}
}
