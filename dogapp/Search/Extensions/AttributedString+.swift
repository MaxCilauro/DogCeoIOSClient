//
//  AttributedString+.swift
//
//

import SwiftUI

extension AttributedString {
    init(_ text: String, highlighting range: Range<String.Index>) {
        var prefix = AttributedString(text[..<range.lowerBound])
        var match = AttributedString(text[range])
        var suffix = AttributedString(text[range.upperBound...])

        prefix.foregroundColor = .secondary
        match.foregroundColor = .primary
        suffix.foregroundColor = .secondary

        self = prefix + match + suffix
    }
}
