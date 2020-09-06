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
    /// `UITableView` used to display all archived recordings.
    @AutoLayout private var archiveTableView: UITableView

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout()

        title = "Archive"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        navigationController?.navigationBar.barTintColor = .memoraDarkGray
    }

    /// Setups constraints and look of the `archiveTableView`.
    private func setupTableViewLayout() {
        archiveTableView.backgroundColor = .memoraDarkGray

        view.addSubview(archiveTableView)

        NSLayoutConstraint.activate([
            archiveTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            archiveTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9),
            archiveTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            archiveTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension ArchiveViewController: UITableViewDelegate {

}

extension ArchiveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// - TODO: Add correct number of archived recordings.
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArchiveTableViewCell.identifier,
                                                    for: indexPath) as? ArchiveTableViewCell {
            cell.contentView.backgroundColor = .memoraLightGray
            return cell
        }
        return UITableViewCell()
    }

}
