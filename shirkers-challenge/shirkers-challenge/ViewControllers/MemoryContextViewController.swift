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
    }

    // MARK: - Views setup
    private func setUpViews() {
        view.backgroundColor = .memoraBackground
        setUpTitleLabel()
        setUpCreatedAtLabel()
        setUpModifiedAtLabel()
        setUpDueDateLabel()
    }

    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        titleLabel.textColor = .memoraAccent
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
        newDueDateLabel.setUp(as: .timestamp)
        newDueDateLabel.textAlignment = .natural
        newDueDateLabel.text = "19/10/2020"
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
            titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
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
            createdAtLabel.widthAnchor.constraint(equalTo: guide.widthAnchor,
                                                  multiplier: DesignSystem.MemoryContext.createdAtLabelWidthMultiplier)
        ])
    }

    private func layoutModifiedAtLabelConstraints() {
        view.addSubview(modifiedAtLabel)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            modifiedAtLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            modifiedAtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                 constant: DesignSystem.MemoryContext.modifiedAtLabelSpacingFromTitle),
            modifiedAtLabel.heightAnchor.constraint(equalToConstant: DesignSystem.MemoryContext.modifiedAtLabelHeight),
            modifiedAtLabel.widthAnchor.constraint(equalTo: guide.widthAnchor,
                                                   multiplier: DesignSystem.MemoryContext.modifiedAtLabelWidthMultiplier)
        ])
    }

    private func layoutNewDueDateLabelConstraints() {
        view.addSubview(newDueDateLabel)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            newDueDateLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            newDueDateLabel.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor,
                                                 constant: DesignSystem.MemoryContext.newDueDateLabelSpacingFromCreatedAt),
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
