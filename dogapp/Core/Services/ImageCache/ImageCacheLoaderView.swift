//
//  ImageCacheLoaderView.swift
//
//

import UIKit

final class ImageCacheLoaderView<Content: UIView>: BaseView {
    private var loadId: UUID?
    private var loadingTask: Task<Void, Never>?

    private(set) var contentView: Content?

    func cancelLoad() {
        self.cancelLoadingTask()
        self.setContentView(nil)
    }

    func loadImage(
        using imageCacheManager: ImageCacheManager,
        url: URL,
        targetSize size: CGSize,
        scale: CGFloat,
        animatesCached: Bool = false,
        content: @escaping @MainActor (ImageLoadPhase) -> Content
    ) {
        self.cancelLoadingTask()

        if let image = imageCacheManager.cachedImage(for: url, targetSize: size) {
            self.setContentView(content(.loaded(image)), isAnimated: animatesCached)
            return
        }

        self.setContentView(content(.loading))

        let id = UUID()
        self.loadId = id

        self.loadingTask = Task { [weak self] in
            do {
                let image = try await imageCacheManager.loadImage(url: url, targetSize: size, scale: scale)

                try Task.checkCancellation()

                guard let self, self.loadId == id else { return }

                self.setContentView(content(.loaded(image)), isAnimated: true)
            } catch is CancellationError {
                // The view disappeared or a newer request replaced this one.
            } catch {
                guard let self, self.loadId == id else { return }

                let phase = ImageLoadPhase.failed(error: error) { [weak self] in
                    self?.loadImage(
                        using: imageCacheManager,
                        url: url,
                        targetSize: size,
                        scale: scale,
                        animatesCached: animatesCached,
                        content: content
                    )
                }

                self.setContentView(content(phase))
            }
        }
    }

    private func cancelLoadingTask() {
        self.loadingTask?.cancel()
        self.loadId = nil
        self.loadingTask = nil
    }

    private func setContentView(_ view: Content?, isAnimated: Bool = false) {
        let update = {
            self.contentView?.removeFromSuperview()
            self.contentView = view

            guard let view else { return }

            view.translatesAutoresizingMaskIntoConstraints = false

            self.addSubview(view)

            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

            UIView.performWithoutAnimation {
                self.layoutIfNeeded()
            }
        }

        guard isAnimated else {
            update()
            return
        }

        UIView.transition(
            with: self,
            duration: 0.25,
            options: [.transitionCrossDissolve, .allowUserInteraction],
            animations: update
        )
    }
}
