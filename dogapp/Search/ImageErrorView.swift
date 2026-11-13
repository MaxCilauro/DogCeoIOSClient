//
//  ImageErrorView.swift
//
//

import SwiftUI

struct ImageErrorView: View {
    let stateCopy: StateCopy
    let retry: () -> Void

    var body: some View {
        Button(action: self.retry) {
            ViewThatFits(in: .vertical) {
                VStack(spacing: 6) {

                    Text(self.stateCopy.title)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                    
                    if let buttonTitle = self.stateCopy.buttonTitle {
                        Text(buttonTitle)
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                    }
                }

                if let iconName = self.stateCopy.iconName {
                    Image(systemName: iconName)
                        .font(.title3)
                } else if let buttonTitle = self.stateCopy.buttonTitle {
                    Text(buttonTitle)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                }
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(self.stateCopy.title)
        .accessibilityHint(self.stateCopy.buttonTitle ?? "", isEnabled: self.stateCopy.buttonTitle != nil)
    }
}

private struct ImageErrorViewPreview: View {
    var body: some View {
        HStack(spacing: 12) {
            ImageErrorView(
                stateCopy: .init(
                    title: "Couldn't load the image",
                    iconName: "exclamationmark.triangle",
                    buttonTitle: "Tap to retry"
                ),
                retry: {}
            )
                .frame(width: 170, height: 130)
                .background(.fill.tertiary)

            ImageErrorView(
                stateCopy: .init(
                    title: "Couldn't load the image",
                    buttonTitle: "Tap to retry"
                ),
                retry: {}
            )
                .frame(width: 56, height: 56)
                .background(.fill.tertiary)
        }
    }
}

#Preview("Dark") {
    ImageErrorViewPreview()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    ImageErrorViewPreview()
        .preferredColorScheme(.light)
}
