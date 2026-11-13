//
//  BreedImageGridView.swift
//
//

import UIKit

class BreedImageGridView: BaseView {
    private static let columns = 3
    private static let spacing: CGFloat = 10
    private static let insets: CGFloat = 18

    static func tileSize(for containerWidth: CGFloat) -> CGSize {
        let columns = CGFloat(Self.columns)
        let available = containerWidth - Self.insets * 2 - Self.spacing * (columns - 1)
        let side = max(0, available / columns)

        return CGSize(width: side, height: side)
    }

    var tileSize: CGSize {
        Self.tileSize(for: self.collectionView.bounds.width)
    }

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, environment in
            let tileSize = Self.tileSize(for: environment.container.contentSize.width)

            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .absolute(tileSize.width),
                    heightDimension: .absolute(tileSize.height)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(tileSize.height)
                ),
                repeatingSubitem: item,
                count: Self.columns
            )
            group.interItemSpacing = .fixed(Self.spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Self.spacing
            section.contentInsets = .init(
                top: Self.insets,
                leading: Self.insets,
                bottom: Self.insets,
                trailing: Self.insets
            )

            return section
        }

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
