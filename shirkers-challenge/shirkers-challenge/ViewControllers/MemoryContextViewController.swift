//
//  MemoryContextViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 19/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class MemoryContextViewController: UIViewController {
    // MARK: - Properties
    @AutoLayout private var titleLabel: MemoraLabel
    @AutoLayout private var createdAtLabel: MemoraLabel
    @AutoLayout private var modifiedAtLabel: MemoraLabel
    @AutoLayout private var dueDateLabel: MemoraLabel
    @AutoLayout private var dueDateSlider: MemoraSlider
    @AutoLayout private var closeButton: MemoraButton
    @AutoLayout private var stackView: UIStackView

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        layoutConstraints()
    }

    // MARK: - Views setup
    private func setUpViews() {
        setUpTitleLabel()
        setUpCreatedAtLabel()
        setUpModifiedAtLabel()
        setUpDueDateLabel()
        setUpCloseButton()
        setUpStackView()
    }

    private func setUpTitleLabel() {
        titleLabel.setUp(as: .default)
        titleLabel.text = "Memory title"
    }

    private func setUpCreatedAtLabel() {
        createdAtLabel.setUp(as: .timestamp)
        createdAtLabel.text = "09/10/2020"
    }

    private func setUpModifiedAtLabel() {
        modifiedAtLabel.setUp(as: .timestamp)
        modifiedAtLabel.text = "19/10/2020"
    }

    private func setUpDueDateLabel() {
        dueDateLabel.setUp(as: .timestamp)
        dueDateLabel.text = "19/10/2020"
    }

    private func setUpCloseButton() {
        closeButton.setUp(as: .close)
    }

    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(createdAtLabel)
        stackView.addArrangedSubview(modifiedAtLabel)
        stackView.addArrangedSubview(dueDateLabel)
        stackView.addArrangedSubview(closeButton)
    }

    // MARK: - Layout
    private func layoutConstraints() {
        view.addSubview(stackView)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: guide.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: guide.heightAnchor)
        ])
    }
}
