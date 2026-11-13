//
//  RandomBreeds.swift
//
//

import SwiftUI

struct RandomBreeds: View {
    @Environment(\.navigateTo) private var navigateTo

    let viewModel: RandomBreedsViewModel
    let breeds: [DogCeo.Breed]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(.highlightedBreeds)
                    .font(.headline)
                    .padding(.horizontal)
                Spacer()
                Button(
                    action: {
                        withAnimation(.snappy) {
                           self.viewModel.shuffle()
                       }
                    },
                    label: {
                        Text(.refresh)
                            .font(.footnote)
                    }
                )
                .buttonStyle(.glass)
                .padding(.trailing, 16)
            }
            
            VStack {
                ForEach(self.viewModel.randomBreeds) { breed in
                    Button {
                        self.navigateTo(.imageGrid(breed: breed))
                    } label: {
                        BreedItem(title: .plain(breed.displayName))
                    }
                    .buttonStyle(CardButtonStyle())
                    .padding(.horizontal)
                    .transition(.blurReplace)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            guard self.viewModel.randomBreeds.isEmpty else { return }

            self.viewModel.setBreeds(self.breeds)
        }
    }
}

private extension RandomBreeds {
    static let previewRandomBreeds = RandomBreeds(
        viewModel: .init(itemCount: 3),
        breeds: DogCeo.Breed.stubs
    )
}

#Preview("Dark") {
    RandomBreeds.previewRandomBreeds
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    RandomBreeds.previewRandomBreeds
        .preferredColorScheme(.light)
}
