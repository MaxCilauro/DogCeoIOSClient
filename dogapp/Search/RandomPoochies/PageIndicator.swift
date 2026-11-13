//
//  PageIndicator.swift
//
//

import SwiftUI

struct PageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<self.count, id: \.self) { index in
                Circle()
                    .fill(index == self.current ? AnyShapeStyle(.primary) : AnyShapeStyle(.tertiary))
                    .frame(width: 6, height: 6)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: self.current)
        .accessibilityHidden(true)
    }
}

#Preview("Dark") {
    PageIndicator(count: 3, current: 1)
        .padding()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    PageIndicator(count: 3, current: 1)
        .padding()
        .preferredColorScheme(.light)
}
