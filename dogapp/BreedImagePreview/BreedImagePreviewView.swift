//
//  BreedImagePreviewView.swift
//
//

import UIKit
import Foundation

class BreedImagePreviewView: BaseView {
    
    let margin: CGFloat = 8
    
    let closeButton: UIButton = {
        var configuration = UIButton.Configuration.glass()
        configuration.image = UIImage(systemName: "xmark")
        
        return UIButton(configuration: configuration)
    }()
    
    let favouriteButton: UIButton = {
        var configuration = UIButton.Configuration.glass()
        configuration.image = UIImage(systemName: "heart")
        
        return UIButton(configuration: configuration)
    }()
    
    let previousButton: UIButton = {
        var configuration = UIButton.Configuration.glass()
        configuration.image = UIImage(systemName: "chevron.left")
        
        return UIButton(configuration: configuration)
    }()
    
    let nextButton: UIButton = {
        var configuration = UIButton.Configuration.glass()
        configuration.image = UIImage(systemName: "chevron.right")
        
        return UIButton(configuration: configuration)
    }()
    
    let imageLoaderView = ImageCacheLoaderView<UIImageView>()

    let breedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private(set) lazy var titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    private(set) lazy var headerStack = UIStackView(arrangedSubviews: [closeButton, titleStack,favouriteButton])
    private(set) lazy var footerStack = UIStackView(arrangedSubviews: [previousButton, breedLabel, nextButton])

    private(set) lazy var mainStack = UIStackView(arrangedSubviews: [headerStack, imageLoaderView, footerStack])
    
    func setup(
        title: String,
        subtitle: String,
        caption: String,
        isFavourite: Bool = false
    ) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.breedLabel.text = caption
        
        self.favouriteButton.setImage(
            isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
            for: .normal
        )
    }
    
    func load(
        using imageCacheManager: ImageCacheManager,
        url: URL,
        positionTitle: String,
        targetSize size: CGSize,
        scale: CGFloat
    ) {
        self.imageLoaderView.loadImage(
            using: imageCacheManager,
            url: url,
            targetSize: size,
            scale: scale,
            animatesCached: true
        ) { [weak self] phase in
            let imageView = UIImageView.makeViewForLoader(
                accessibilityLabel: positionTitle
            )
            
            [NSLayoutConstraint.Axis.horizontal, .vertical].forEach { axis in
                imageView.setContentHuggingPriority(.defaultLow - 1, for: axis)
                imageView.setContentCompressionResistancePriority(.defaultLow - 1, for: axis)
            }

            switch phase {
            case .loading:
                imageView.configureSymbol(named: Symbols.genericLoading)
                imageView.addSymbolEffect(.breathe)
                imageView.accessibilityValue = String(localized: .loading)

            case .failed:
                imageView.configureSymbol(named: Symbols.genericWarning)
                imageView.accessibilityValue = String(localized: .imageLoadFailed)

            case .loaded(let image):
                imageView.image = image
                self?.updateContentMode(of: imageView)
            }

            return imageView
        }
    }
    
    override func setup() {
        self.backgroundColor = .systemBackground
        self.layoutMargins = .init(top: 0, left: self.margin, bottom: 0, right: self.margin)
        
        self.titleStack.axis = .vertical
        self.titleStack.alignment = .center
        
        self.headerStack.alignment = .center
        self.headerStack.axis = .horizontal
        
        self.footerStack.alignment = .center
        self.footerStack.axis = .horizontal
        
        self.breedLabel.textAlignment = .center

        self.closeButton.accessibilityLabel = String(localized: .closePreview)
        self.favouriteButton.accessibilityLabel = String(localized: .favourite)
        self.previousButton.accessibilityLabel = String(localized: .goToPreviousImage)
        self.nextButton.accessibilityLabel = String(localized: .goToNextImage)

        self.mainStack.axis = .vertical

        self.titleLabel.font = .preferredFont(forTextStyle: .headline)
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.textColor = .label
        self.titleLabel.numberOfLines = 1
        self.titleLabel.lineBreakMode = .byTruncatingTail

        self.subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        self.subtitleLabel.adjustsFontForContentSizeCategory = true
        self.subtitleLabel.textColor = .secondaryLabel

        self.breedLabel.font = .preferredFont(forTextStyle: .footnote)
        self.breedLabel.adjustsFontForContentSizeCategory = true
        self.breedLabel.textColor = .secondaryLabel

        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .body)
            .applying(UIImage.SymbolConfiguration(weight: .semibold))

        [self.closeButton, self.favouriteButton, self.previousButton, self.nextButton].forEach { button in
            button.configuration?.preferredSymbolConfigurationForImage = symbolConfiguration
        }
    }
    
    override func setupSubviews() {
        self.addSubview(mainStack)
    }
    
    override func defineLayout() {
        let headerHeight = self.headerStack.heightAnchor.constraint(equalToConstant: 0)
        headerHeight.priority = .defaultLow + 1
        headerHeight.isActive = true

        let footerHeight = self.footerStack.heightAnchor.constraint(equalToConstant: 0)
        footerHeight.priority = .defaultLow + 1
        footerHeight.isActive = true
        
        self.titleStack.setContentHuggingPriority(.defaultLow, for: .horizontal)

        self.breedLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.nextButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.previousButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        self.mainStack.translatesAutoresizingMaskIntoConstraints = false
        self.mainStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.mainStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        self.mainStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
        self.mainStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        
        [self.closeButton, self.favouriteButton, self.previousButton, self.nextButton].forEach { button in
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let imageView = self.imageLoaderView.contentView {
            self.updateContentMode(of: imageView)
        }
    }
    
    private func updateContentMode(of imageView: UIImageView) {
        guard let image = imageView.image else {
            return
        }

        let available = self.imageLoaderView.bounds.size
        let fits = image.size.width <= available.width && image.size.height <= available.height

        imageView.contentMode = fits ? .center : .scaleAspectFit
    }
}
