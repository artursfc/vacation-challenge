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

    /// `UICollectionView` used to display all recordings currently in the Inbox.
    private lazy var inboxCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout()

        title = "Inbox"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        navigationController?.navigationBar.barTintColor = .memoraDarkGray
    }

    /// Setups constraints and look of the `inboxCollectionView`
    private func setupCollectionViewLayout() {
        inboxCollectionView.backgroundColor = .memoraDarkGray

        self.view.addSubview(inboxCollectionView)

        NSLayoutConstraint.activate([
            inboxCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            inboxCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.90),
            inboxCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inboxCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension InboxViewController: UICollectionViewDelegate {

}

extension InboxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InboxCollectionViewCell.identifier,
                                                         for: indexPath) as? InboxCollectionViewCell {
            cell.contentView.backgroundColor = .memoraLightGray
            return cell
        }
        return UICollectionViewCell()
    }
}

extension InboxViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height * 0.15)
    }
}
