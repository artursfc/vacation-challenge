//
//  InboxViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Representation of the Inbox screen. Should be instantianted as one the pages of
/// a `UIPageViewController`. However, it should be encapsulated inside a `UINavigationController`.
final class InboxViewController: UIViewController {

// - MARK: Properties

    /// `UICollectionView` used to display all recordings currently in the Inbox.
    private lazy var inboxCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

// - MARK: Init

    init() {
        super.init(nibName: nil, bundle: nil)
        self.inboxCollectionView.delegate = self
        self.inboxCollectionView.dataSource = self

        self.inboxCollectionView.register(InboxCollectionViewCell.self,
                                     forCellWithReuseIdentifier: InboxCollectionViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// - MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        title = "Inbox"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        navigationController?.navigationBar.barTintColor = .memoraDarkGray
    }

// - MARK: Layout

    /// Configures constraints and look of the `inboxCollectionView`
    private func setupCollectionView() {
        inboxCollectionView.backgroundColor = .memoraDarkGray

        self.view.addSubview(inboxCollectionView)

        NSLayoutConstraint.activate([
            inboxCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            inboxCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.90),
            inboxCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inboxCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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

// - MARK: UICollectionViewDelegate

extension InboxViewController: UICollectionViewDelegate {

}

// - MARK: UICollectionViewDataSource

extension InboxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InboxCollectionViewCell.identifier,
                                                         for: indexPath) as? InboxCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: "💎")

        return cell
    }
}
