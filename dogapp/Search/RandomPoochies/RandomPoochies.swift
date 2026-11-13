//
//  RandomPoochies.swift
//
//

import SwiftUI

struct RandomPoochies: View {
    @Environment(\.navigateTo) private var navigateTo

    @Bindable var viewModel: RandomPoochiesViewModel

    var body: some View {
        ZStack {
            switch self.viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let images):
                VStack(alignment: .leading, spacing: 16) {
                    Text(.randomPoochiesTitle)
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(self.viewModel.pages.indices, id: \.self) { page in
                                PoochiePage(
                                    images: self.viewModel.pages[page],
                                    rows: self.viewModel.rows,
                                    columns: self.viewModel.columns
                                ) { indexInPage in
                                    self.navigateTo(
                                        .previewImage(
                                            images: images,
                                            index: self.viewModel.imageIndex(page: page, indexInPage: indexInPage)
                                        )
                                    )
                                }
                                    .containerRelativeFrame(.horizontal)
                                    .id(page)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, 16, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .scrollPosition(id: self.$viewModel.currentPage)
                    
                    PageIndicator(count: self.viewModel.pages.count, current: self.viewModel.currentPage ?? 0)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom)
            case .failed:
                StatusOverlay(stateCopy: .genericError) {
                    Task {
                        await self.viewModel.loadIfNeeded()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .task {
            await self.viewModel.loadIfNeeded()
        }
    }
}
