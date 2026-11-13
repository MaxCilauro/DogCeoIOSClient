//
//  BreedItem.swift
//
//

import SwiftUI

struct BreedItem: View {
    let title: Title

    var body: some View {
        HStack {
            Text(self.attributedTitle)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .contentShape(.rect(cornerRadius: 16))
        .background(
            Color(.secondarySystemBackground),
            in: .rect(
                cornerRadius: 16
            )
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.separator, lineWidth: 1)
        }
    }

    private var attributedTitle: AttributedString {
        switch self.title {
        case .plain(let text):
            return AttributedString(text)
        case .highlighted(let text, let match):
            return AttributedString(text, highlighting: match)
        }
    }
}

extension BreedItem {
    enum Title {
        case plain(String)
        case highlighted(String, match: Range<String.Index>)
    }
}

private extension BreedItem {
    static let previewTitle = "Border Collie"
    static let previewMatch = previewTitle.range(of: "der")!
}

#Preview("Dark") {
    VStack {
        BreedItem(title: .plain(BreedItem.previewTitle))
        BreedItem(title: .highlighted(BreedItem.previewTitle, match: BreedItem.previewMatch))
    }
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    VStack {
        BreedItem(title: .plain(BreedItem.previewTitle))
        BreedItem(title: .highlighted(BreedItem.previewTitle, match: BreedItem.previewMatch))
    }
    .padding()
    .preferredColorScheme(.light)
}
