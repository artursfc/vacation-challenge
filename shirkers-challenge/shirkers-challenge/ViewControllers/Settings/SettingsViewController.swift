//
//  SettingsViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func loadView() {
        super.loadView()

        settingsTableView.delegate = self
        settingsTableView.dataSource = self

        view.addSubview(settingsTableView)

        NSLayoutConstraint.activate([
            settingsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            settingsTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            settingsTableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.backgroundColor = .memoraRed
    }
}

extension SettingsViewController: UITableViewDelegate {

}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = .memoraLightGray
        return cell
    }


}
