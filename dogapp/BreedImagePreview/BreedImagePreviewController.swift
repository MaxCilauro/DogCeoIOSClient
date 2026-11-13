//
//  BreedImagePreviewController.swift
//
//

import UIKit
import Foundation

class BreedImagePreviewController: BaseViewController<BreedImagePreviewView> {
    private let viewModel: BreedImagePreviewViewModel
    private var loadedSize: CGSize = .zero
    private var loadedIndex: Int?
    private let store: any ValueStoring<Favourite>
    private let imageCacheManager: ImageCacheManager

    init(
        viewModel: BreedImagePreviewViewModel,
        imageCacheManager: ImageCacheManager,
        store: any ValueStoring<Favourite>
    ) {
        self.viewModel = viewModel
        self.imageCacheManager = imageCacheManager
        self.store = store
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .dark

        self.contentView.closeButton.addAction(
            UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            },
            for: .touchUpInside
        )
        
        self.contentView.previousButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.previous()
            },
            for: .touchUpInside
        )

        self.contentView.nextButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.next()
            },
            for: .touchUpInside
        )
        
        let favouriteFeedback = UINotificationFeedbackGenerator(view: self.contentView.favouriteButton)

        self.contentView.favouriteButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let isFavourite = self.store.contains(self.viewModel.currentImage.id)
                Task {
                    do {
                        if isFavourite {
                            try await self.store.remove(self.viewModel.currentImage.id)
                        } else {
                            try await self.store.insert(.init(image: self.viewModel.currentImage))
                        }
                        
                        favouriteFeedback.notificationOccurred(.success)
                    } catch {
                        favouriteFeedback.notificationOccurred(.error)
                        let alert = UIAlertController(
                            title: String(localized: .favouriteSaveFailed),
                            message: String(localized: isFavourite ? .favouriteRemoveFailed : .favouriteAddFailed),
                            preferredStyle: .alert
                        )

                        alert.addAction(
                            UIAlertAction(
                                title: String(localized: .ok),
                                style: .default
                            )
                        )

                        self.present(alert, animated: true, completion: nil)
                    }
                }
            },
            for: .touchUpInside
        )
        
        self.contentView.imageLoaderView.onLayoutSubviews = { [weak self] view in
            self?.updateImageLoaderView(with: view.bounds.size)
        }
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipeGesture.direction = .left
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipeGesture.direction = .right
        
        [leftSwipeGesture, rightSwipeGesture].forEach {
            self.contentView.imageLoaderView.addGestureRecognizer($0)
        }
    }
    
    override func updateProperties() {
        super.updateProperties()
        
        let isFavourite = self.store.contains(self.viewModel.currentImage.id)
        
        self.contentView.favouriteButton.accessibilityTraits = isFavourite ? [.button, .selected] : .button
        
        self.contentView.setup(
            title: self.viewModel.title,
            subtitle: self.viewModel.subtitle,
            caption: self.viewModel.caption,
            isFavourite: isFavourite
        )

        self.loadCurrentImageIfNeeded()
    }

    private func loadCurrentImage() {
        self.contentView.load(
            using: self.imageCacheManager,
            url: self.viewModel.currentImage.url,
            positionTitle: self.viewModel.positionTitle,
            targetSize: self.loadedSize,
            scale: self.contentView.traitCollection.displayScale
        )
    }
    
    private func updateImageLoaderView(with size: CGSize) {
        guard size != .zero, size != self.loadedSize else {
            return
        }
        
        self.loadedSize = size
        self.loadedIndex = nil
        self.loadCurrentImageIfNeeded()
    }
    
    private func loadCurrentImageIfNeeded() {
        guard self.loadedSize != .zero, self.loadedIndex != self.viewModel.currentIndex else {
            return
        }
        self.loadedIndex = self.viewModel.currentIndex
        self.loadCurrentImage()
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            self.viewModel.next()
        }
        
        if gesture.direction == .right {
            self.viewModel.previous()
        }
    }
}
