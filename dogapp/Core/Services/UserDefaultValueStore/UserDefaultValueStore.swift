//
//  UserDefaultValueStore.swift
//
//

import Foundation

@Observable
final class UserDefaultValueStore<Value: Codable & Identifiable>: ValueStoring {

    private(set) var state: LoadingState<[Value], Error> = .loading
    
    private let userDefaults: UserDefaults
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    
    private let key: String
    private let limit: Int?

    init(
        key: String,
        limit: Int? = nil,
        userDefaults: UserDefaults = .standard,
        jsonDecoder: JSONDecoder = .init(),
        jsonEncoder: JSONEncoder = .init()
    ) {
        self.key = key
        self.limit = limit
        self.userDefaults = userDefaults
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }
    
    func loadIfNeeded() async {
        guard !self.state.isLoaded else { return }
        
        self.state = .loading

        let data = self.userDefaults.data(forKey: self.key)
        do {
            let values = try data.map { try self.jsonDecoder.decode([Value].self, from: $0) } ?? []
            self.state = .loaded(values)
        } catch {
            self.state = .failed(error)
        }
    }
    
    func contains(_ id: Value.ID) -> Bool {
        guard case .loaded(let values) = self.state else {
            return false
        }
        
        return values.contains { $0.id == id }
    }
    
    func insert(_ value: Value) async throws {
        let values = try await self.loadedValues()
        
        let updatedValues = [value] + values.filter { $0.id != value.id }

        guard let limit = self.limit else {
            try self.save(updatedValues)
            return
        }

        try self.save(Array(updatedValues.prefix(limit)))
    }

    func remove(_ id: Value.ID) async throws {
        let values = try await self.loadedValues()
        let updatedValues = values.filter { $0.id != id }

        try self.save(updatedValues)
    }

    func removeAll() async throws {
        try self.save([])
    }
    
    private func save(_ values: [Value]) throws {
        let data = try self.jsonEncoder.encode(values)
        self.userDefaults.set(data, forKey: self.key)
        self.state = .loaded(values)
    }
    
    private func loadedValues() async throws -> [Value] {
        await self.loadIfNeeded()

        switch self.state {
        case .loaded(let values):
            return values
        case .failed(let error):
            throw error
        case .loading:
            throw ValueStoreError.notLoaded
        }
    }
}

extension UserDefaultValueStore {
    enum ValueStoreError: LocalizedError {
        case notLoaded
        
        var errorDescription: String? {
            switch self {
            case .notLoaded:
                return "Value is loading. Try again later."
            }
        }
    }
}
