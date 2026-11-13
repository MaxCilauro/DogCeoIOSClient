//
//  PoochieImage.swift
//
//

import SwiftUI

struct PoochieImage: View {
    let image: UIImage
    let breedImage: DogCeo.BreedImage

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear
                .overlay {
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                }
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )

            Text(self.breedImage.displayName)
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .padding()
        }
        .accessibilityElement(children: .combine)
    }
}

private struct PoochieImagePreview: View {
    var body: some View {
        HStack(spacing: 10) {
            ForEach(DogCeo.BreedImage.stubs.prefix(2), id: \.url) { breedImage in
                PoochieImage(image: UIImage(systemName: "dog.fill")!, breedImage: breedImage)
                    .frame(height: 130)
                    .clipShape(.rect(cornerRadius: 16))
            }
        }
        .padding()
    }
}

#Preview("Dark") {
    PoochieImagePreview()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    PoochieImagePreview()
        .preferredColorScheme(.light)
}
