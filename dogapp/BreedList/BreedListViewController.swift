//
//  BreedListViewController.swift
//
//

import UIKit
import Foundation

class BreedListViewController: BaseViewController<BreedListView> {
    nonisolated enum Section: Hashable, Sendable {
        case breeds
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, DogCeo.Breed>! = nil
    private let viewModel: BreedListViewModel
    private let navigateTo: NavigateTo

    init(
        viewModel: BreedListViewModel,
        navigateTo: @escaping NavigateTo
    ) {
        self.viewModel = viewModel
        self.navigateTo = navigateTo

        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .inline
        self.navigationItem.title = String(localized: .breedsTitle)
        
        self.contentView.collectionView.delegate = self
        
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

        case .loaded(let breeds):
            let emptyView = UIContentUnavailableView.makeView(stateCopy: .emptyBreedList)

            self.contentView.collectionView.backgroundView = breeds.isEmpty ? emptyView : nil

            self.applySnapshot(breeds: breeds)

        case .failed:
            self.contentView.collectionView.backgroundView = UIContentUnavailableView.makeView(
                stateCopy: .breedListError,
                retry: UIAction { [weak self] _ in
                    Task {
                        await self?.viewModel.loadIfNeeded()
                    }
                }
            )
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<WrapperCollectionCell<BreedListItem>, DogCeo.Breed> { cell, indexPath, breed in
            cell.content.setup(with: breed)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, DogCeo.Breed>(collectionView: contentView.collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }

    private func applySnapshot(breeds: [DogCeo.Breed]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DogCeo.Breed>()
        snapshot.appendSections([.breeds])
        snapshot.appendItems(breeds, toSection: .breeds)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension BreedListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let breed = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        self.navigateTo(.imageGrid(breed: breed), self)
    }
}



