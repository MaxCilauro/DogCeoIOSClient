//
//  CardButtonStyle.swift
//
//

import SwiftUI

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isPressed ? AnyShapeStyle(.fill.tertiary) : AnyShapeStyle(.clear))
            }
    }
}
