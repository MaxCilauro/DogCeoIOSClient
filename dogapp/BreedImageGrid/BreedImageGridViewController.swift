//
//  BreedImageGridViewController.swift
//
//

import UIKit
import Foundation

class BreedImageGridViewController: BaseViewController<BreedImageGridView> {
    nonisolated enum Section: Hashable, Sendable {
        case images
    }

    private let viewModel: BreedImageGridViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, DogCeo.BreedImage>! = nil
    private let imageCacheManager: ImageCacheManager
    private let navigateTo: NavigateTo
    
    private var appliedImages: [DogCeo.BreedImage] = []

    init(
        viewModel: BreedImageGridViewModel,
        imageCacheManager: ImageCacheManager,
        navigateTo: @escaping NavigateTo
    ) {
        self.viewModel = viewModel
        self.imageCacheManager = imageCacheManager
        self.navigateTo = navigateTo
        
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.contentView.collectionView.delegate = self
        
        self.setContentScrollView(self.contentView.collectionView, for: .top)
        
        self.navigationItem.title = self.viewModel.title
        self.navigationItem.subtitle = self.viewModel.subtitle

        self.configureDataSource()
        
        Task { [weak self] in
            await self?.viewModel.loadIfNeeded()
        }
    }
    
    override func updateProperties() {
        super.updateProperties()

        self.navigationItem.subtitle = self.viewModel.subtitle
        
        switch self.viewModel.state {
        case .loading:
            self.contentView.collectionView.backgroundView = UIContentUnavailableView(configuration: .loading())
        case .loaded(let images):
            let emptyView = UIContentUnavailableView.makeView(stateCopy: self.viewModel.emptyStateCopy)

            self.contentView.collectionView.backgroundView = images.isEmpty ? emptyView : nil
            self.apply(images: images)

        case .failed:
            self.contentView.collectionView.backgroundView = UIContentUnavailableView.makeView(
                stateCopy: self.viewModel.errorStateCopy,
                retry: UIAction { [weak self] _ in
                    Task {
                        await self?.viewModel.loadIfNeeded()
                    }
                }
            )
        }
        
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<WrapperCollectionCell<BreedImageGridItem>, DogCeo.BreedImage> { [weak self] cell, indexPath, breedImage in
            guard let self else {
                return
            }

            cell.content.prepareForReuse()
            cell.content.setup(
                with: breedImage,
                positionTitle: self.viewModel.positionTitle(for: breedImage, at: indexPath.item),
                imageCacheManager: self.imageCacheManager,
                targetSize: self.contentView.tileSize,
                scale: self.contentView.collectionView.traitCollection.displayScale
            )
        }

        self.dataSource = UICollectionViewDiffableDataSource<Section, DogCeo.BreedImage>(collectionView: contentView.collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }

    private func apply(images: [DogCeo.BreedImage]) {
        guard images != self.appliedImages else {
            return
        }
        self.appliedImages = images

        var snapshot = NSDiffableDataSourceSnapshot<Section, DogCeo.BreedImage>()
        
        if snapshot.indexOfSection(.images) == nil {
            snapshot.appendSections([.images])
        }
        
        snapshot.appendItems(images, toSection: .images)

        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension BreedImageGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard case .loaded(let images) = self.viewModel.state else {
            return
        }
        
        self.navigateTo(.previewImage(images: images, index: indexPath.item), self)
    }
}

