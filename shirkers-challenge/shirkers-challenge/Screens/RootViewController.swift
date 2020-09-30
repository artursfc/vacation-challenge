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

    /// The UINavigationController with its `rootViewController` property
    /// set as an instance of `RootPageViewController` containing the Inbox, Archive and Settings screens.
    private let memoraNavigationViewController: MemoraNavigationViewController
    /// The UIViewController representing the Player Component.
    private let playerComponentViewController: PlayerComponentViewController

// - MARK: Init

    init(memoraNavigationViewController: MemoraNavigationViewController, playerComponentViewController: PlayerComponentViewController) {
        self.memoraNavigationViewController = memoraNavigationViewController

        self.playerComponentViewController = playerComponentViewController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// - MARK: Life cycle

    override func viewDidLoad() {
        view.backgroundColor = .memoraDarkGray

        self.addChild(memoraNavigationViewController)
        self.view.addSubview(memoraNavigationViewController.view)

        memoraNavigationViewController.didMove(toParent: self)

        self.addChild(playerComponentViewController)
        self.view.addSubview(playerComponentViewController.view)

        playerComponentViewController.didMove(toParent: self)

        setupLayout()
    }

// - MARK: Layout

    /// Configures all the necessary constraints.
    private func setupLayout() {
        memoraNavigationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        playerComponentViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            memoraNavigationViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            memoraNavigationViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoraNavigationViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            memoraNavigationViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),

            playerComponentViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playerComponentViewController.view.topAnchor.constraint(equalTo: memoraNavigationViewController.view.bottomAnchor, constant: 5),
            playerComponentViewController.view.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            playerComponentViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.175)
        ])
    }
}
