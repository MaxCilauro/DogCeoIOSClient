//
//  BaseViewController.swift
//
//

import UIKit

class BaseViewController<T: BaseView>: UIViewController {

    var contentView: T {
        guard let customView = view as? T else {
            fatalError("View must be of type \(T.self)")
        }
        return customView
    }
    
    override func loadView() {
        self.view = T()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
