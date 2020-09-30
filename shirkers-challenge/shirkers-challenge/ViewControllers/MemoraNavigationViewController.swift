//
//  MemoraNavigationViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class MemoraNavigationViewController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setUpNavigationController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpNavigationController() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.memoraLightGray]
        self.navigationBar.barTintColor = .memoraDarkGray
        self.navigationBar.isTranslucent = false
    }
}
