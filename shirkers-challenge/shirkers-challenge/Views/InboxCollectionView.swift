//
//  InboxCollectionView.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 05/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class InboxCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: InboxCollectionView.setupCollectionViewLayout())
        style()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        backgroundColor = .memoraBackground
    }

    private static func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(DesignSystem.Inbox.itemFractionalWidth),
                                                    heightDimension: .fractionalHeight(DesignSystem.Inbox.itemFractionalHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: DesignSystem.Inbox.itemTopSpacing,
                                                     leading: DesignSystem.Inbox.itemLeadingSpacing,
                                                     bottom: DesignSystem.Inbox.itemBottomSpacing,
                                                     trailing: DesignSystem.Inbox.itemTrailingSpacing)

        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(DesignSystem.Inbox.groupFractionalWidth),
                                                     heightDimension: .fractionalHeight(DesignSystem.Inbox.groupFractionalHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: DesignSystem.Inbox.groupTopSpacing,
                                                      leading: DesignSystem.Inbox.groupLeadingSpacing,
                                                      bottom: DesignSystem.Inbox.groupBottomSpacing,
                                                      trailing: DesignSystem.Inbox.groupTrailingSpacing)

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }
}
