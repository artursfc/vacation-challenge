//
//  InboxViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit
import os.log

/// Representation of the Inbox screen. Should be instantianted as one the pages of
/// a `UIPageViewController`. 
final class InboxViewController: UIViewController {
    // MARK: - Properties
    /// `UICollectionView` used to display all recordings currently in the Inbox.
    @AutoLayout private var inboxCollectionView: InboxCollectionView

    ///  The `ViewModel` responsible for this `View`.
    private let viewModel: InboxViewModel
    // MARK: - Init
    /// Initializes a new instance of this type.
    /// - Parameter viewModel: The `ViewModel` responsible for this `View`.
    init(viewModel: InboxViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        os_log("InboxViewController initialized.", log: .appFlow, type: .debug)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        setUpCollectionView()
        title = NSLocalizedString("inbox", comment: "Title of the InboxViewController")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeTheme(_:)),
                                               name: Notification.Name("theme-changed"),
                                               object: nil)
    }

    // MARK: - @objc
    @objc private func didChangeTheme(_ notification: NSNotification) {
        os_log("InboxViewController should change theme.", log: .appFlow, type: .debug)
        inboxCollectionView.backgroundColor = .memoraBackground
        inboxCollectionView.reloadData()
    }

    // MARK: - ViewModel setup
    private func setUpViewModel() {
        viewModel.delegate = self
        viewModel.requestFetch()
    }

    // MARK: - Layout
    private func setUpCollectionView() {
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
        os_log("InboxViewController deinitialized.", log: .appFlow, type: .debug)
    }
}

// MARK: - UICollectionViewDelegate
extension InboxViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        let previewViewController = MemoryContextViewController()
        return UIContextMenuConfiguration(identifier: nil, previewProvider: { previewViewController }, actionProvider: { (_) -> UIMenu? in
            let sampleAction = UIAction(title: "Sample",
                                        image: UIImage(systemName: "checkmark.circle")) { (_) in
            }
            let children = [sampleAction]
            return UIMenu(title: "", children: children)
        })
    }

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

    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion { [weak self] in
            guard let self = self else { return }
            let previewViewController = MemoryContextViewController()
            self.show(previewViewController, sender: self)
        }
    }
}

// MARK: - ViewModel Delegate
extension InboxViewController: InboxViewModelDelegate {
    func insertNewMemoryAt(_ index: IndexPath) {
        os_log("InboxViewController inserting new memories...", log: .appFlow, type: .debug)
        inboxCollectionView.insertItems(at: [index])
    }

    func updates(from blocks: [BlockOperation]) {
        os_log("InboxViewController peforming batch updates.", log: .appFlow, type: .debug)
        inboxCollectionView.performBatchUpdates({
            for block in blocks {
                block.start()
            }
        }, completion: { [weak self] (didUpdate) in
            guard let self = self else {
                return
            }
            self.viewModel.didUpdate = didUpdate
            os_log("InboxViewController done with batch updates.", log: .appFlow, type: .debug)
        })
    }
}
