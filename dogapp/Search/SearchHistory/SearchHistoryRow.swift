//
//  SearchHistoryRow.swift
//
//

import SwiftUI

struct SearchHistoryRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.fill.tertiary)
                .frame(width: 56, height: 56)
                .overlay {
                    Image(systemName: "pawprint.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(self.title)
                    .foregroundStyle(.primary)
                Text(self.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .alignmentGuide(.listRowSeparatorLeading) { dimensions in
                dimensions[.leading]
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .contentShape(.rect)
    }
}

#Preview("Dark") {
    SearchHistoryRow(title: "French Bulldog", subtitle: "Variation · Bulldog")
        .padding()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    SearchHistoryRow(title: "French Bulldog", subtitle: "Variation · Bulldog")
        .padding()
        .preferredColorScheme(.light)
}
