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
    @AutoLayout private var newDueDateLabel: MemoraLabel
    @AutoLayout private var newDueDateSlider: MemoraSlider

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

        preferredContentSize = CGSize(width: view.frame.width, height: 275)
    }

    // MARK: - Views setup
    private func setUpViews() {
        view.backgroundColor = .memoraFill
        setUpTitleLabel()
        setUpCreatedAtLabel()
        setUpModifiedAtLabel()
        setUpDueDateLabel()
    }

    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        titleLabel.textColor = .memoraAccent
        titleLabel.text = "A very long Memory title"
    }

    private func setUpCreatedAtLabel() {
        createdAtLabel.setUp(as: .timestamp)
        createdAtLabel.font = .preferredFont(forTextStyle: .subheadline)
        createdAtLabel.text = "Created at 09/10/2020"
        createdAtLabel.textAlignment = .natural
    }

    private func setUpModifiedAtLabel() {
        modifiedAtLabel.setUp(as: .timestamp)
        modifiedAtLabel.font = .preferredFont(forTextStyle: .subheadline)
        modifiedAtLabel.text = "Last modified at 19/10/2020"
        modifiedAtLabel.textAlignment = .natural
    }

    private func setUpDueDateLabel() {
        newDueDateLabel.setUp(as: .timestamp)
        newDueDateLabel.textAlignment = .natural
        newDueDateLabel.text = "Due date 19/10/2020"
    }

    // MARK: - Layout
    private func layoutConstraints() {
        layoutTitleLabelConstraints()
        layoutCreatedAtLabelConstraints()
        layoutModifiedAtLabelConstraints()
        layoutNewDueDateLabelConstraints()
        layoutNewDueDateSliderConstraints()
    }

    private func layoutTitleLabelConstraints() {
        view.addSubview(titleLabel)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor,
                                                constant: DesignSystem.MemoryContext.titleLabelSpacingFromCenterY),
            titleLabel.heightAnchor.constraint(equalToConstant: DesignSystem.MemoryContext.titleLabelHeight),
            titleLabel.widthAnchor.constraint(equalTo: guide.widthAnchor)
        ])
    }

    private func layoutCreatedAtLabelConstraints() {
        view.addSubview(createdAtLabel)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            createdAtLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            createdAtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                constant: DesignSystem.MemoryContext.createdAtLabelSpacingFromTitle),
            createdAtLabel.heightAnchor.constraint(equalToConstant: DesignSystem.MemoryContext.createdAtLabelHeight),
            createdAtLabel.widthAnchor.constraint(equalTo: guide.widthAnchor)
        ])
    }

    private func layoutModifiedAtLabelConstraints() {
        view.addSubview(modifiedAtLabel)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            modifiedAtLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            modifiedAtLabel.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor,
                                                 constant: DesignSystem.MemoryContext.modifiedAtLabelSpacingFromCreatedAt),
            modifiedAtLabel.heightAnchor.constraint(equalToConstant: DesignSystem.MemoryContext.modifiedAtLabelHeight),
            modifiedAtLabel.widthAnchor.constraint(equalTo: guide.widthAnchor)
        ])
    }

    private func layoutNewDueDateLabelConstraints() {
        view.addSubview(newDueDateLabel)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            newDueDateLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            newDueDateLabel.topAnchor.constraint(equalTo: modifiedAtLabel.bottomAnchor,
                                                 constant: DesignSystem.MemoryContext.newDueDateLabelSpacingFromModifiedAt),
            newDueDateLabel.heightAnchor.constraint(equalToConstant: DesignSystem.MemoryContext.newDueDateLabelHeight),
            newDueDateLabel.widthAnchor.constraint(equalTo: guide.widthAnchor)
        ])
    }

    private func layoutNewDueDateSliderConstraints() {
        view.addSubview(newDueDateSlider)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            newDueDateSlider.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            newDueDateSlider.topAnchor.constraint(equalTo: newDueDateLabel.bottomAnchor,
                                                  constant: DesignSystem.MemoryContext.newDueDateSliderSpacingFromNewDueDateLabel),
            newDueDateSlider.heightAnchor.constraint(equalToConstant: DesignSystem.MemoryContext.newDueDateSliderHeight),
            newDueDateSlider.widthAnchor.constraint(equalTo: guide.widthAnchor)
        ])
    }
}
