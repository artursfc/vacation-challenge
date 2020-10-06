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
    @AutoLayout private var inboxCollectionView: InboxCollectionView

// - MARK: Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// - MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        title = "Inbox"
    }

// - MARK: Layout

    /// Configures constraints and look of the `inboxCollectionView`
    private func setupCollectionView() {
        inboxCollectionView.delegate = self
        inboxCollectionView.dataSource = self

        inboxCollectionView.register(InboxCollectionViewCell.self,
                                     forCellWithReuseIdentifier: InboxCollectionViewCell.identifier)
        
        view.addSubview(inboxCollectionView)

        NSLayoutConstraint.activate([
            inboxCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            inboxCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            inboxCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inboxCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
