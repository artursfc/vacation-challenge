//
//  RecorderViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 07/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class RecorderViewController: UIViewController {
    // MARK: Properties
    @AutoLayout private var recordButton: UIButton
    @AutoLayout private var timestampLabel: UILabel

    // MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Layout
    private func layoutConstraints() {
        view.addSubview(recordButton)
        view.addSubview(timestampLabel)

        let guides = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            recordButton.bottomAnchor.constraint(equalTo: guides.bottomAnchor,
                                                 constant: DesignSystem.)
        ])
    }
}
