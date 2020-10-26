//
//  ArchiveViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 30/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit
import os.log

/// Representation of the Archive screen. Should be instantianted as one the pages of
/// a `UIPageViewController`.
final class ArchiveViewController: UIViewController {
    // MARK: - Properties

    /// `UITableView` used to display all archived recordings.
    @AutoLayout private var archiveTableView: UITableView

    /// The `ViewModel` responsible for this `View`.
    private let viewModel: ArchiveViewModel

    // MARK: - Init
    /// Initializes a new instace of this type.
    /// - Parameter viewModel: The `ViewModel` responsible for this `View`.
    init(viewModel: ArchiveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.archiveTableView.delegate = self
        self.archiveTableView.dataSource = self
        self.archiveTableView.register(ArchiveTableViewCell.self,
                                       forCellReuseIdentifier: ArchiveTableViewCell.identifier)
        os_log("ArchiveViewController initialized.", log: .appFlow, type: .debug)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout()
        setUpViewModel()
        title = NSLocalizedString("archive", comment: "Title of the ArchiveViewController")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeTheme(_:)),
                                               name: Notification.Name("theme-changed"),
                                               object: nil)
    }

    // MARK: - @objc
    @objc private func didChangeTheme(_ notification: NSNotification) {
        os_log("ArchiveViewController should change theme.", log: .appFlow, type: .debug)
        archiveTableView.backgroundColor = .memoraBackground
        archiveTableView.reloadData()
    }

    // MARK: - ViewModel setup
    private func setUpViewModel() {
        viewModel.delegate = self
        viewModel.requestFetch()
    }
    // MARK: - Layout
    /// Configures constraints and look of the `archiveTableView`.
    private func setupTableViewLayout() {
        archiveTableView.backgroundColor = .memoraBackground
        archiveTableView.estimatedRowHeight = DesignSystem.Archive.rowHeight
        archiveTableView.rowHeight = UITableView.automaticDimension
        archiveTableView.separatorStyle = .none

        view.addSubview(archiveTableView)

        NSLayoutConstraint.activate([
            archiveTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            archiveTableView.heightAnchor.constraint(equalTo: view.heightAnchor),
            archiveTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            archiveTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
        os_log("ArchiveViewController deinitialized.", log: .appFlow, type: .debug)
    }
}

// MARK: - UITableViewDelegate
extension ArchiveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let previewViewController = MemoryContextViewController(viewModel: viewModel.viewModelAt(index: indexPath))
        return UIContextMenuConfiguration(identifier: nil, previewProvider: { previewViewController }, actionProvider: { (_) -> UIMenu? in
            let resetAction = UIAction(title: NSLocalizedString("reset-reminder", comment: "Action to reset reminder"),
                                       image: UIImage(systemName: "arrow.clockwise")) { (_) in

            }
            let deleteAction = UIAction(title: NSLocalizedString("delete-memory", comment: "Action to delete memory. Destructive."),
                                        image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] (_) in
                guard let self = self else {
                    return
                }

                self.viewModel.deleteMemoryAt(index: indexPath)
            }
            let children = [resetAction, deleteAction]
            return UIMenu(title: "", children: children)
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("play"),
                                        object: nil,
                                        userInfo: ["play": viewModel.viewModelAt(index: indexPath)])
    }
}

// MARK: - UITableViewDataSource
extension ArchiveViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DesignSystem.Archive.rowHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMemories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArchiveTableViewCell.identifier,
                                                    for: indexPath) as? ArchiveTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.viewModelAt(index: indexPath))
        return cell
    }

}

// MARK: - ViewModel Delegate
extension ArchiveViewController: ArchiveViewModelDelegate {
    func beginUpdates() {
        os_log("ArchiveViewController updating...", log: .appFlow, type: .debug)
        archiveTableView.beginUpdates()
    }

    func insertNewMemoryAt(_ index: IndexPath) {
        os_log("ArchiveViewController inserting new memories...", log: .appFlow, type: .debug)
        archiveTableView.insertRows(at: [index], with: .fade)
    }

    func deleteMemoryAt(_ index: IndexPath) {
        os_log("ArchiveViewController deleting memories...", log: .appFlow, type: .debug)
        archiveTableView.deleteRows(at: [index], with: .fade)
    }

    func endUpdates() {
        os_log("ArchiveViewController done updating.", log: .appFlow, type: .debug)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else {
                return
            }
            self.archiveTableView.endUpdates()
        }
    }

}
