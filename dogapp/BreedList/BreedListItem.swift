//
//  BreedListItem.swift
//
//

import UIKit

class BreedListItem: BaseView {
    private var breed: DogCeo.Breed?
    
    private let breedLabel = UILabel()
    private let subBreedCountLabel = UILabel()
    private let arrowImageView: UIImageView = UIImageView()
    
    private(set) lazy var titleStack = UIStackView(arrangedSubviews: [
        breedLabel,
        subBreedCountLabel
    ])
    
    private(set) lazy var mainStack = UIStackView(arrangedSubviews: [
        titleStack,
        arrowImageView
    ])
    
    override func setHighlighted(_ highlighted: Bool) {
        self.backgroundColor = highlighted ? .tertiarySystemFill : .secondarySystemBackground
    }
    
    func setup(with breed: DogCeo.Breed) {
        self.breed = breed
        
        self.breedLabel.text = breed.displayName.capitalized
        
        let subBreedCount = breed.subBreeds.count
        let isSubBreedInfoHidden = subBreedCount == 0 || subBreedCount == 1
        
        self.subBreedCountLabel.isHidden = isSubBreedInfoHidden
        self.subBreedCountLabel.text = "\(subBreedCount) varieties"
    }
    
    override func setup() {
        self.insetsLayoutMarginsFromSafeArea = false
        self.backgroundColor = .secondarySystemBackground
        self.layoutMargins = .init(
            top: 13,
            left: 14,
            bottom: 13,
            right: 16
        )

        self.layer.borderColor = UIColor.separator.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        self.arrowImageView.image = UIImage(systemName: "chevron.right")
        self.arrowImageView.tintColor = .tertiaryLabel
        self.arrowImageView.preferredSymbolConfiguration = .init(textStyle: .footnote, scale: .small)
        
        self.titleStack.alignment = .leading
        self.titleStack.axis = .vertical
        self.titleStack.spacing = 3
        
        self.mainStack.alignment = .center
        self.mainStack.axis = .horizontal
        self.mainStack.spacing = 12
        
        self.breedLabel.font = .preferredFont(forTextStyle: .headline)
        self.breedLabel.adjustsFontForContentSizeCategory = true
        self.breedLabel.numberOfLines = 0

        self.subBreedCountLabel.font = .preferredFont(forTextStyle: .footnote)
        self.subBreedCountLabel.adjustsFontForContentSizeCategory = true
        self.subBreedCountLabel.numberOfLines = 0
        self.subBreedCountLabel.textColor = .secondaryLabel
    }
    
    override func setupSubviews() {
        self.addSubview(mainStack)
    }
    
    override func defineLayout() {
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 58).isActive = true

        self.titleStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.titleStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        self.arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        self.arrowImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        self.mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.mainStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        self.mainStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        self.mainStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
    }
}
