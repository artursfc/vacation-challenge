//
//  ArchiveViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 30/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Representation of the Archive screen. Should be instantianted as one the pages of
/// a `UIPageViewController`. However, it should be encapsulated inside a `UINavigationController`.
final class ArchiveViewController: UIViewController {
// - MARK: Properties

    /// `UITableView` used to display all archived recordings.
    @AutoLayout private var archiveTableView: UITableView

// - MARK: Init

    init() {
        super.init(nibName: nil, bundle: nil)
        self.archiveTableView.delegate = self
        self.archiveTableView.dataSource = self

        self.archiveTableView.register(ArchiveTableViewCell.self,
                                       forCellReuseIdentifier: ArchiveTableViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// - MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout()
        title = "Archive"

        
    }

// - MARK: Layout
    /// Configures constraints and look of the `archiveTableView`.
    private func setupTableViewLayout() {
        archiveTableView.backgroundColor = .memoraDarkGray
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
}

// - MARK: UITableViewDelegate

extension ArchiveViewController: UITableViewDelegate {

}

// - MARK: UITableViewDataSource

extension ArchiveViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DesignSystem.Archive.rowHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// - TODO: Add correct number of archived recordings.
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArchiveTableViewCell.identifier,
                                                    for: indexPath) as? ArchiveTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }

}
