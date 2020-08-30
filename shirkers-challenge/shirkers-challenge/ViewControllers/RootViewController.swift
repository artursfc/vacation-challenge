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

    init() {
        let first = UINavigationController(rootViewController: InboxViewController())

        let second = UINavigationController(rootViewController: ArchiveViewController())

        rootPageViewController = RootPageViewController(pages: [first, second])

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

        title = "Teste"
    }
}
