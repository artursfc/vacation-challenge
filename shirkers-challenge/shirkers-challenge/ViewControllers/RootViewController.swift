//
//  RootViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Container UIViewController for the app's main interface.
final class RootViewController: UIViewController {

// - MARK: Properties

    /// The UIViewController containing the Inbox, Archive and Settings screens.
    private let rootPageViewController: RootPageViewController
    /// The UIViewController representing the Player Component.
    private let playerComponentViewController: PlayerComponentViewController

// - MARK: Init

    init() {
        let first = UINavigationController(rootViewController: InboxViewController())

        let second = UINavigationController(rootViewController: ArchiveViewController())

        let third = UINavigationController(rootViewController: SettingsViewController())

        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        rootPageViewController = RootPageViewController(pages: [third, first, second], pageViewController: pageViewController)

        self.playerComponentViewController = PlayerComponentViewController()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// - MARK: Life cycle

    override func viewDidLoad() {
        view.backgroundColor = .memoraDarkGray

        self.addChild(rootPageViewController)
        self.view.addSubview(rootPageViewController.view)

        rootPageViewController.didMove(toParent: self)

        self.addChild(playerComponentViewController)
        self.view.addSubview(playerComponentViewController.view)

        playerComponentViewController.didMove(toParent: self)

        title = "Teste"

        setupLayout()
    }

// - MARK: Layout

    /// Configures all the necessary constraints.
    private func setupLayout() {
        rootPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        playerComponentViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rootPageViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rootPageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootPageViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            rootPageViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),

            playerComponentViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playerComponentViewController.view.topAnchor.constraint(equalTo: rootPageViewController.view.bottomAnchor, constant: 5),
            playerComponentViewController.view.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            playerComponentViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.175)
        ])
    }
}
