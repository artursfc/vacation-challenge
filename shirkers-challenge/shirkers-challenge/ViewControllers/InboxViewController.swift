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

    // MARK: - Properties

    /// `UICollectionView` used to display all recordings currently in the Inbox.
    @AutoLayout private var inboxCollectionView: InboxCollectionView

    private let viewModel: InboxViewModel
    // MARK: - Init

    init(viewModel: InboxViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        setupCollectionView()
        title = NSLocalizedString("inbox", comment: "Title of the InboxViewController")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeTheme(_:)),
                                               name: Notification.Name("theme-changed"),
                                               object: nil)
    }

    // MARK: - @objc
    @objc private func didChangeTheme(_ notification: NSNotification) {
        inboxCollectionView.backgroundColor = .memoraBackground
        inboxCollectionView.reloadData()
    }

    // MARK: ViewModel setup
    private func setUpViewModel() {
        viewModel.delegate = self
        viewModel.requestFetch()
    }

    // MARK: - Layout

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

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionViewDelegate
extension InboxViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension InboxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMemories
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InboxCollectionViewCell.identifier,
                                                         for: indexPath) as? InboxCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: viewModel.viewModelAt(index: indexPath))

        return cell
    }
}

// MARK: - ViewModel Delegate
extension InboxViewController: InboxViewModelDelegate {
    func insertNewMemoryAt(_ index: IndexPath) {
        inboxCollectionView.insertItems(at: [index])
    }

    func updates(from blocks: [BlockOperation]) {
        inboxCollectionView.performBatchUpdates({
            for block in blocks {
                block.start()
            }
        }, completion: { [weak self] (didUpdate) in
            guard let self = self else {
                return
            }
            self.viewModel.didUpdate = didUpdate
        })
    }
}
