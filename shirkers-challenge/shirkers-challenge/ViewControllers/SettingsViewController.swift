//
//  SettingsViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit
import os.log

/// Representation of the Settings screen. Should be instantiated as one the pages of
/// a `UIPageViewController`.
final class SettingsViewController: UIViewController {
    // MARK: - Properties
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .memoraBackground
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()

    private lazy var settingsCellArray: [[UITableViewCell]] = {
        let defaultThemeCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        defaultThemeCell.textLabel?.text = NSLocalizedString("default-theme", comment: "The app's default theme")
        defaultThemeCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        defaultThemeCell.textLabel?.textColor = .memoraAccent
        defaultThemeCell.backgroundColor = .memoraBackground
        defaultThemeCell.selectionStyle = .none

        let pastelThemeCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        pastelThemeCell.textLabel?.text = NSLocalizedString("pastel-theme", comment: "The app's pastel theme")
        pastelThemeCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        pastelThemeCell.textLabel?.textColor = .memoraAccent
        pastelThemeCell.backgroundColor = .memoraBackground
        pastelThemeCell.selectionStyle = .none

        let themesSection = [defaultThemeCell, pastelThemeCell]

        let githubCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        githubCell.textLabel?.text = "GitHub"
        githubCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        githubCell.textLabel?.textColor = .memoraAccent
        githubCell.backgroundColor = .memoraBackground
        githubCell.tintColor = .memoraAccent
        githubCell.selectionStyle = .none
        if let chevron = UIImage(systemName: "chevron.right") {
            githubCell.accessoryView = UIImageView(image: chevron)
        }

        let privacyPolicyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        privacyPolicyCell.textLabel?.text = NSLocalizedString("privacy", comment: "The app's privacy policy")
        privacyPolicyCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        privacyPolicyCell.textLabel?.textColor = .memoraAccent
        privacyPolicyCell.backgroundColor = .memoraBackground
        privacyPolicyCell.tintColor = .memoraAccent
        privacyPolicyCell.selectionStyle = .none
        if let chevron = UIImage(systemName: "chevron.right") {
            privacyPolicyCell.accessoryView = UIImageView(image: chevron)
        }

        let aboutSection = [githubCell, privacyPolicyCell]

        return [themesSection, aboutSection]
    }()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        os_log("SettingsViewController initialized.", log: .appFlow, type: .debug)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
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
        title = NSLocalizedString("settings", comment: "Title of the SettingsViewController")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeTheme(_:)),
                                               name: Notification.Name("theme-changed"),
                                               object: nil)
    }

    // MARK: - @objc
    @objc private func didChangeTheme(_ notification: NSNotification) {
        os_log("SettingsViewController should change theme.", log: .appFlow, type: .debug)
        settingsTableView.backgroundColor = .memoraBackground
        for section in settingsCellArray {
            for row in section {
                row.tintColor = .memoraAccent
                row.textLabel?.textColor = .memoraAccent
                row.backgroundColor = .memoraBackground
            }
        }
    }

    // MARK: Theme
    private func changeIcon(for theme: UIColor.Theme) {
        os_log("SettingsViewController should change app's icon.", log: .appFlow, type: .debug)
        switch theme {
        case .default:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(nil) { (error) in
                    if error != nil {
                        os_log("SettingsViewController failed to change app's icon.", log: .appFlow, type: .debug)
                    }
                }
            }
        case .pastel:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName("Pastel-Icon") { (error) in
                    if error != nil {
                        os_log("SettingsViewController failed to change app's icon.", log: .appFlow, type: .debug)
                    }
                }
            }
        }
    }

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
        os_log("SettingsViewController deinitialized.", log: .appFlow, type: .debug)
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                UIColor.currentTheme = .default
                changeIcon(for: .default)
            case 1:
                UIColor.currentTheme = .pastel
                changeIcon(for: .pastel)
            default:
                break
            }
        }
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
            return NSLocalizedString("themes", comment: "The themes section")
        case 1:
            return NSLocalizedString("about", comment: "The about section")
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
