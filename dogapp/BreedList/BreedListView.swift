//
//  BreedListView.swift
//
//


import UIKit

class BreedListView: BaseView {
    
    private(set) lazy var collectionView: UICollectionView = {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(58)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: item.layoutSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 9
        section.contentInsets = .init(top: 2, leading: 18, bottom: 18, trailing: 18)
        let layout = UICollectionViewCompositionalLayout(section: section)

        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        
        return view
    }()
    
    override func setupSubviews() {
        self.addSubview(collectionView)
    }
    
    override func defineLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
}

