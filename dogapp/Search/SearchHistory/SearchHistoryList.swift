//
//  SearchHistoryList.swift
//
//

import SwiftUI

struct SearchHistoryList: View {
    @Environment(\.navigateTo) private var navigateTo

    let viewModel: SearchHistoryViewModel

    var body: some View {
        List {
            HStack {
                Text(.recentlySearchedBreeds)
                    .font(.title3.bold())
                Spacer()
                Button(String(localized: .clear), role: .destructive) {
                    Task {
                        try? await self.viewModel.clear()
                    }
                }
                .buttonStyle(.borderless)
            }

            ForEach(self.viewModel.items) { item in
                Button {
                    Task {
                        try? await self.viewModel.select(item)
                        self.navigateTo(.imageGrid(breed: item.breed))
                    }
                } label: {
                    SearchHistoryRow(
                        title: item.title,
                        subtitle: Self.subtitle(for: item)
                    )
                }
            }
            .onDelete { offsets in
                let items = offsets.map { self.viewModel.items[$0] }

                Task {
                    for item in items {
                        try? await self.viewModel.remove(item)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }

    private static func subtitle(for item: SearchHistoryItem) -> String {
        guard item.subBreed != nil else {
            return String(localized: .breed)
        }

        return String(localized: .variationSubtitle(item.breed.displayName))
    }
}

#Preview("Dark") {
    SearchHistoryList(viewModel: .makeStub(items: SearchHistoryItem.stubs))
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    SearchHistoryList(viewModel: .makeStub(items: SearchHistoryItem.stubs))
        .preferredColorScheme(.light)
}
