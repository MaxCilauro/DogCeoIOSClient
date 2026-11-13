//
//  WrapperCollectionCell.swift
//
//


import UIKit

public class WrapperCollectionCell<T: BaseView>: CollectionViewCell {

    public private(set) var content: T = T()

    public override var isHighlighted: Bool {
        didSet { self.content.setHighlighted(self.isHighlighted) }
    }

    public override func setup() {
        backgroundColor = .clear
    }

    public override func setupSubviews() {
        contentView.addSubview(content)
    }

    public override func defineLayout() {
        content.translatesAutoresizingMaskIntoConstraints = false
        
        content.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        let bottomConstraint = content.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        bottomConstraint.priority = .init(rawValue: 999)
        bottomConstraint.isActive = true

        let trailingConstraint = content.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        trailingConstraint.priority = .init(rawValue: 999)
        trailingConstraint.isActive = true

        content.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    }
}

