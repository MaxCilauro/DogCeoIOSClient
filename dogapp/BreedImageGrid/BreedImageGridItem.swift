//
//  BreedImageGridItem.swift
//
//

import UIKit

class BreedImageGridItem: BaseView {
    let imageLoaderView = ImageCacheLoaderView<UIView>()

    func prepareForReuse() {
        self.imageLoaderView.cancelLoad()
    }

    func setup(
        with breedImage: DogCeo.BreedImage,
        positionTitle: String,
        imageCacheManager: ImageCacheManager,
        targetSize: CGSize,
        scale: CGFloat
    ) {
        self.imageLoaderView.loadImage(
            using: imageCacheManager,
            url: breedImage.url,
            targetSize: targetSize,
            scale: scale
        ) { phase in
            switch phase {
            case .loading:
                return UIImageView.makeViewForLoader(
                    image: .loadingPlaceholder,
                    accessibilityLabel: positionTitle,
                    accessibilityValue: String(localized: .loading),
                    accessibilityTraits: [.image, .button]
                )
            case .failed(_, let retry):
                return UIButton.makeRetryButton(using: .imageLoadError, action: retry)
            case .loaded(let image):
                return UIImageView.makeViewForLoader(
                    image: image,
                    accessibilityLabel: positionTitle,
                    accessibilityTraits: [.image, .button]
                )
            }
        }
    }

    override func setup() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }

    override func setupSubviews() {
        self.addSubview(self.imageLoaderView)
    }

    override func defineLayout() {
        self.imageLoaderView.translatesAutoresizingMaskIntoConstraints = false

        self.imageLoaderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageLoaderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.imageLoaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageLoaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
}
