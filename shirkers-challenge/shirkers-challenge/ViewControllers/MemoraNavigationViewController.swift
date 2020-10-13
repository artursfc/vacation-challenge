//
//  MemoraNavigationViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class MemoraNavigationViewController: UINavigationController {

    // MARK: Init
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setUpNavigationController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeTheme(_:)),
                                               name: Notification.Name("theme-changed"),
                                               object: nil)
    }

    // MARK: @objc
    @objc private func didChangeTheme(_ notification: NSNotification) {
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraAccent]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraAccent]
        navigationBar.barTintColor = .memoraBackground
    }

    // MARK: Setup
    private func setUpNavigationController() {
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraAccent]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraAccent]
        navigationBar.barTintColor = .memoraBackground
        navigationBar.isTranslucent = true
    }

    // MARK: Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
