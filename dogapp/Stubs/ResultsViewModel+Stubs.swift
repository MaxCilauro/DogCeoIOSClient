//
//  ResultsViewModel+Stubs.swift
//
//

import SwiftUI

extension ResultsViewModel {
    static func makeStub(
        query: String = "",
        searchHistory: SearchHistoryViewModel = .makeStub()
    ) -> ResultsViewModel {
        let viewModel = ResultsViewModel(searchHistory: searchHistory)
        viewModel.query = query

        return viewModel
    }
}
