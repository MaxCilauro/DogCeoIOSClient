//
//  SearchHistoryViewModel.swift
//
//

import Foundation

@Observable
final class SearchHistoryViewModel {
    var items: [SearchHistoryItem] {
        self.store.state.value ?? []
    }

    private let store: any ValueStoring<SearchHistoryItem>

    init(store: any ValueStoring<SearchHistoryItem>) {
        self.store = store
    }

    func loadIfNeeded() async {
        await self.store.loadIfNeeded()
    }

    func record(_ result: BreedSearchResult) async throws {
        try await self.store.insert(SearchHistoryItem(result: result))
    }

    func select(_ item: SearchHistoryItem) async throws {
        let searchedAgain = SearchHistoryItem(
            breed: item.breed,
            subBreed: item.subBreed
        )

        try await self.store.insert(searchedAgain)
    }

    func remove(_ item: SearchHistoryItem) async throws {
        try await self.store.remove(item.id)
    }

    func clear() async throws {
        try await self.store.removeAll()
    }
}
