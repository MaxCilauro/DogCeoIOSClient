//
//  SearchHistory.swift
//
//

import SwiftUI

struct SearchHistory: View {
    let viewModel: SearchHistoryViewModel

    var body: some View {
        Group {
            if self.viewModel.items.isEmpty {
                StatusOverlay(stateCopy: .emptyHistory)
            } else {
                SearchHistoryList(viewModel: self.viewModel)
            }
        }
        .task {
            await self.viewModel.loadIfNeeded()
        }
    }
}

#Preview("History") {
    SearchHistory(viewModel: .makeStub(items: SearchHistoryItem.stubs))
}

#Preview("Empty") {
    SearchHistory(viewModel: .makeStub())
}
