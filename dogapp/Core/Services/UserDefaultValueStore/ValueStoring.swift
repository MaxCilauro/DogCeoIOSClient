//
//  ValueStoring.swift
//
//

import Foundation

@MainActor
protocol ValueStoring<Value>: AnyObject, Observable {
    associatedtype Value: Codable & Identifiable

    var state: LoadingState<[Value], Error> { get }

    func loadIfNeeded() async
    func contains(_ id: Value.ID) -> Bool

    /// Inserts at the front. If a value with the same id exists, it's moved to the front.
    func insert(_ value: Value) async throws
    func remove(_ id: Value.ID) async throws
    func removeAll() async throws
}
