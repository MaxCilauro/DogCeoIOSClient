//
//  RandomPoochiesViewModelTests.swift
//Tests
//

import Testing
import Foundation

@testable import dogapp

@MainActor
@Suite("RandomPoochiesViewModel")
struct RandomPoochiesViewModelTests {

    @Test(arguments: [
        (page: 0, indexInPage: 0, expected: 0),
        (page: 0, indexInPage: 3, expected: 3),
        (page: 1, indexInPage: 0, expected: 4),
        (page: 2, indexInPage: 1, expected: 9),
    ])
    func imageIndexInATwoByTwoGrid(page: Int, indexInPage: Int, expected: Int) {
        let viewModel = self.makeViewModel(rows: 2, columns: 2)

        #expect(viewModel.imageIndex(page: page, indexInPage: indexInPage) == expected)
    }

    @Test func imageIndexUsesRowsTimesColumnsPerPage() {
        let viewModel = self.makeViewModel(rows: 3, columns: 2)

        #expect(viewModel.imageIndex(page: 1, indexInPage: 1) == 7)
    }

    // MARK: Helpers

    private func makeViewModel(rows: Int, columns: Int) -> RandomPoochiesViewModel {
        RandomPoochiesViewModel(
            rows: rows,
            columns: columns,
            provider: StubProvider(values: [])
        )
    }
}
