//
//  RandomPoochiesViewModel.swift
//
//

import Foundation

@Observable
final class RandomPoochiesViewModel {

    let rows: Int
    let columns: Int

    var imagesPerPageCount: Int {
        self.rows * self.columns
    }
    
    var pages: [[DogCeo.BreedImage]] {
        self.makePages()
    }

    var currentPage: Int? = 0
    var state: LoadingState<[DogCeo.BreedImage], Error> {
        self.provider.state
    }
    
    private let provider: any LoadingProvider<DogCeo.BreedImage>
    
    init(
        rows: Int = 3,
        columns: Int = 2,
        provider: any LoadingProvider<DogCeo.BreedImage>
    ) {
        self.rows = rows
        self.columns = columns
        self.provider = provider
    }
    
    func loadIfNeeded() async {
        await self.provider.loadIfNeeded()
    }

    func imageIndex(page: Int, indexInPage: Int) -> Int {
        page * self.imagesPerPageCount + indexInPage
    }
    
    private func makePages() -> [[DogCeo.BreedImage]] {
        let images = self.state.value ?? []
        
        var pages: [[DogCeo.BreedImage]] = []
        var currentPage: [DogCeo.BreedImage] = []
        
        for image in images {
            currentPage.append(image)

            if currentPage.count == self.imagesPerPageCount {
                pages.append(currentPage)
                currentPage = []
            }
        }
        
        if !currentPage.isEmpty {
            pages.append(currentPage)
        }
        
        return pages
    }
}
