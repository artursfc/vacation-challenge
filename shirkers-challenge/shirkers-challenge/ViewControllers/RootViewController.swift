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
        let first = UIViewController()
        first.view.backgroundColor = .memoraDarkGray

        let second = UIViewController()
        second.view.backgroundColor = .memoraRed

        let third = UIViewController()
        third.view.backgroundColor = .systemPink

        rootPageViewController = RootPageViewController(pages: [first, second, third])

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemRed

        self.addChild(rootPageViewController)
        self.view.addSubview(rootPageViewController.view)

        rootPageViewController.view.frame = UIScreen.main.bounds

        rootPageViewController.didMove(toParent: self)
    }
}
