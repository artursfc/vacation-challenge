//
//  RootViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    private let rootPageViewController: RootPageViewController
    private let playerComponentViewController: PlayerComponentViewController

    init() {
        let first = UINavigationController(rootViewController: InboxViewController())

        let second = UINavigationController(rootViewController: ArchiveViewController())

        rootPageViewController = RootPageViewController(pages: [first, second])

        self.playerComponentViewController = PlayerComponentViewController()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private func setupLayout() {
        rootPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        playerComponentViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rootPageViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rootPageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootPageViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            rootPageViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7),

            playerComponentViewController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playerComponentViewController.view.topAnchor.constraint(equalTo: rootPageViewController.view.bottomAnchor),
            playerComponentViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            playerComponentViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3)
        ])
    }
}
