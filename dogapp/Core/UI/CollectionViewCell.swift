//
//  CollectionViewCell.swift
//
//

import UIKit

open class CollectionViewCell: UICollectionViewCell {
    public var onLayoutSubviews: (CollectionViewCell) -> Void = { _ in }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
        defineLayout()
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        onLayoutSubviews(self)
    }

    open func setup() { }
    open func setupSubviews() { }
    open func defineLayout() { }
}


