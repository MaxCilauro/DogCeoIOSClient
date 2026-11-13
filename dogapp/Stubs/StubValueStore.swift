//
//  StubValueStore.swift
//
//

import Foundation

@Observable
final class StubValueStore<Value: Codable & Identifiable>: ValueStoring {
    private(set) var state: LoadingState<[Value], Error>

    private let writeError: Error?

    init(state: LoadingState<[Value], Error>, writeError: Error? = nil) {
        self.state = state
        self.writeError = writeError
    }

    convenience init(values: [Value] = [], writeError: Error? = nil) {
        self.init(state: .loaded(values), writeError: writeError)
    }

    func loadIfNeeded() async {}

    func contains(_ id: Value.ID) -> Bool {
        self.state.value?.contains { $0.id == id } ?? false
    }

    func insert(_ value: Value) async throws {
        try self.throwWriteErrorIfNeeded()

        let values = self.state.value ?? []

        self.state = .loaded([value] + values.filter { $0.id != value.id })
    }

    func remove(_ id: Value.ID) async throws {
        try self.throwWriteErrorIfNeeded()

        let values = self.state.value ?? []

        self.state = .loaded(values.filter { $0.id != id })
    }

    func removeAll() async throws {
        try self.throwWriteErrorIfNeeded()

        self.state = .loaded([])
    }

    private func throwWriteErrorIfNeeded() throws {
        if let writeError {
            throw writeError
        }
    }
}
