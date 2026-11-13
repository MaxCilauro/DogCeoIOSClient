//
//  AttributedStringHighlightTests.swift
//Tests
//

import Testing
import SwiftUI

@testable import dogapp

@MainActor
@Suite("AttributedString highlighting")
struct AttributedStringHighlightTests {
    private nonisolated static let matches = ["Border", "der Co", "Collie", "Border Collie"]

    private let title = "Border Collie"

    @Test(arguments: matches)
    func keepsTheText(match: String) throws {
        let attributed = try self.makeAttributedString(highlighting: match)

        #expect(String(attributed.characters) == self.title)
    }

    @Test(arguments: matches)
    func matchIsColoredPrimary(match: String) throws {
        let attributed = try self.makeAttributedString(highlighting: match)

        #expect(self.text(in: attributed, colored: .primary) == match)
    }

    @Test(arguments: matches)
    func restIsColoredSecondary(match: String) throws {
        let attributed = try self.makeAttributedString(highlighting: match)

        #expect(self.text(in: attributed, colored: .secondary) == self.title.replacingOccurrences(of: match, with: ""))
    }

    // MARK: Helpers

    private func makeAttributedString(highlighting match: String) throws -> AttributedString {
        let range = try #require(self.title.range(of: match))

        return AttributedString(self.title, highlighting: range)
    }

    private func text(in attributed: AttributedString, colored color: Color) -> String {
        attributed.runs
            .filter { $0.foregroundColor == color }
            .map { String(attributed[$0.range].characters) }
            .joined()
    }
}
