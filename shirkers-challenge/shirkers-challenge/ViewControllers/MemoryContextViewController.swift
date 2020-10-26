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

    private lazy var memorySymbolImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "waveform"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .memoraAccent
        return imageView
    }()

    private var viewModel: MemoryViewModel {
        didSet {
            titleLabel.text = viewModel.title
            titleLabel.textColor = .memoraAccent

            createdAtLabel.text = "\(NSLocalizedString("created-at", comment: "")) \(viewModel.createdAt)"
            createdAtLabel.textColor = .memoraAccent

            modifiedAtLabel.text = "\(NSLocalizedString("modified-at", comment: "")) \(viewModel.modifiedAt)"
            modifiedAtLabel.textColor = .memoraAccent

            newDueDateLabel.text = "\(NSLocalizedString("new-remind-me-in", comment: "")) \(viewModel.dueDate)"
            newDueDateLabel.textColor = .memoraAccent

            memorySymbolImageView.tintColor = .memoraAccent

            view.backgroundColor = .memoraFill
        }
    }

    // MARK: - Init
    init(viewModel: MemoryViewModel) {
        self.viewModel = viewModel
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

        preferredContentSize = CGSize(width: view.frame.width, height: 320)
    }

    // MARK: - ViewModel update
    func updates(from viewModel: MemoryViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views setup
    private func setUpViews() {
        view.backgroundColor = .memoraFill
        setUpTitleLabel()
        setUpCreatedAtLabel()
        setUpModifiedAtLabel()
        setUpNewDueDateLabel()
    }

    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        titleLabel.textColor = .memoraAccent
        titleLabel.numberOfLines = 3
        titleLabel.text = viewModel.title
    }

    private func setUpCreatedAtLabel() {
        createdAtLabel.setUp(as: .timestamp)
        createdAtLabel.font = .preferredFont(forTextStyle: .subheadline)
        createdAtLabel.text = "\(NSLocalizedString("created-at", comment: "")) \(viewModel.createdAt.toBeDisplayedFormat())"
        createdAtLabel.textAlignment = .natural
    }

    private func setUpModifiedAtLabel() {
        modifiedAtLabel.setUp(as: .timestamp)
        modifiedAtLabel.font = .preferredFont(forTextStyle: .subheadline)
        modifiedAtLabel.text = "\(NSLocalizedString("modified-at", comment: "")) \(viewModel.modifiedAt.toBeDisplayedFormat())"
        modifiedAtLabel.textAlignment = .natural
    }

    private func setUpNewDueDateLabel() {
        newDueDateLabel.setUp(as: .timestamp)
        newDueDateLabel.textAlignment = .natural
        newDueDateLabel.numberOfLines = 3
        newDueDateLabel.lineBreakMode = .byWordWrapping
        newDueDateLabel.text = "\(NSLocalizedString("new-remind-me-in", comment: "")) \(viewModel.dueDate.toBeDisplayedFormat())"
    }

    // MARK: - Layout
    private func layoutConstraints() {
        layoutTitleLabelConstraints()
        layoutMemorySymbolImageViewConstraints()
        layoutCreatedAtLabelConstraints()
        layoutModifiedAtLabelConstraints()
        layoutNewDueDateLabelConstraints()
    }

    private func layoutTitleLabelConstraints() {
        view.addSubview(titleLabel)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor,
                                                constant: DesignSystem.MemoryContext.titleLabelSpacingFromCenterY),
            titleLabel.widthAnchor.constraint(equalTo: guide.widthAnchor,
                                              multiplier: 0.8)
        ])
    }

    private func layoutMemorySymbolImageViewConstraints() {
        view.addSubview(memorySymbolImageView)

        let guide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            memorySymbolImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            memorySymbolImageView.centerYAnchor.constraint(equalTo: guide.centerYAnchor,
                                                constant: DesignSystem.MemoryContext.titleLabelSpacingFromCenterY),
            memorySymbolImageView.widthAnchor.constraint(equalTo: guide.widthAnchor,
                                              multiplier: 0.2),
            memorySymbolImageView.heightAnchor.constraint(equalTo: guide.widthAnchor,
                                                          multiplier: 0.2)
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
}
