//
//  SearchHistoryViewModel+Stubs.swift
//
//

import SwiftUI

extension SearchHistoryViewModel {
    static func makeStub(
        items: [SearchHistoryItem] = [],
        store: (any ValueStoring<SearchHistoryItem>)? = nil
    ) -> SearchHistoryViewModel {
        SearchHistoryViewModel(store: store ?? StubValueStore(values: items))
    }
}
