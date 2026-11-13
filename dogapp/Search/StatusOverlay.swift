//
//  StatusOverlay.swift
//
//

import SwiftUI

struct StatusOverlay: View {
    @State private var containerWidth: CGFloat = 0

    let stateCopy: StateCopy
    var retry: (() -> Void)? = nil

    var body: some View {
        VStack {
            if let iconName = self.stateCopy.iconName {
                Image(systemName: iconName)
                    .resizable()
                    .frame(maxWidth: 45, maxHeight: 45)
                    .scaledToFill()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 5)
            }

            Text(self.stateCopy.title)
                .font(.title2)

            if let subtitle = self.stateCopy.subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: min(self.containerWidth / 2, 160))
            }

            if let buttonTitle = self.stateCopy.buttonTitle, let retry {
                Button(buttonTitle, action: retry)
                    .buttonStyle(.glassProminent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .onGeometryChange(
            for: CGFloat.self,
            of: \.size.width
        ) { newValue in
            self.containerWidth = newValue
        }
    }
}

#Preview("Dark") {
    StatusOverlay(stateCopy: .stub, retry: {}).preferredColorScheme(.dark)
}

#Preview("Light") {
    StatusOverlay(stateCopy: .stub, retry: {}).preferredColorScheme(.light)
}
