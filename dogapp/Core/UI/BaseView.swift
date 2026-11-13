//
//  BaseView.swift
//
//

import UIKit

open class BaseView: UIView {
    var onLayoutSubviews: ((BaseView) -> Void) = { _ in }
    
    open func setHighlighted(_ highlighted: Bool) {}
    
    required public init() {
        super.init(frame: .zero)

        self.sharedInit()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     override init(frame: CGRect) {
        super.init(frame: frame)

        self.sharedInit()
    }

    private func sharedInit() {
        self.setup()
        self.setupSubviews()
        self.defineLayout()
    }

    // MARK: Lifecycle Methods

    open func setup() {}
    open func setupSubviews() {}
    open func defineLayout() {}

    open override func layoutSubviews() {
        super.layoutSubviews()
        onLayoutSubviews(self)
    }
}
