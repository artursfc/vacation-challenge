//
//  SettingsViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    // - MARK: Properties
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .memoraDarkGray
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()

    private lazy var settingsCellArray: [[UITableViewCell]] = {
        let defaultThemeCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        defaultThemeCell.textLabel?.text = "Default"
        defaultThemeCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        defaultThemeCell.textLabel?.textColor = .memoraLightGray
        defaultThemeCell.backgroundColor = .memoraDarkGray

        let themesSection = [defaultThemeCell]

        let githubCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        githubCell.textLabel?.text = "GitHub"
        githubCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        githubCell.textLabel?.textColor = .memoraLightGray
        githubCell.backgroundColor = .memoraDarkGray
        githubCell.tintColor = .memoraLightGray
        githubCell.selectedBackgroundView = UIView()
        if let chevron = UIImage(systemName: "chevron.right") {
            githubCell.accessoryView = UIImageView(image: chevron)
        }

        let privacyPolicyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        privacyPolicyCell.textLabel?.text = "Privacy Policy"
        privacyPolicyCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        privacyPolicyCell.textLabel?.textColor = .memoraLightGray
        privacyPolicyCell.backgroundColor = .memoraDarkGray
        privacyPolicyCell.tintColor = .memoraLightGray
        if let chevron = UIImage(systemName: "chevron.right") {
            privacyPolicyCell.accessoryView = UIImageView(image: chevron)
        }
        privacyPolicyCell.selectedBackgroundView = UIView()

        let aboutSection = [githubCell, privacyPolicyCell]

        return [themesSection, aboutSection]
    }()

    // - MARK: Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // - MARK: Life cycle
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
        title = "Settings"
    }
}

// - MARK: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                if let githubURL = URL(string: ExternalURL.github.rawValue) {
                    UIApplication.shared.open(githubURL)
                }
            case 1:
                if let privacyURL = URL(string: ExternalURL.privacy.rawValue) {
                    UIApplication.shared.open(privacyURL)
                }
            default:
                break
            }
        }
    }

}

// - MARK: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Theme"
        case 1:
            return "About"
        default:
            return ""
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsCellArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCellArray[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingsCellArray[indexPath.section][indexPath.row]
    }

}
