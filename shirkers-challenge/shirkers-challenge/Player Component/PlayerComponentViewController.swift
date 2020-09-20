//
//  PlayerComponentViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Representation of the Player Component. Should be instantiated only once as part
/// of the `RootViewController`.
final class PlayerComponentViewController: UIViewController {

// - MARK: Properties
    /// The slider representing the progress of the audio playback.
    @AutoLayout private var progressSlider: UISlider
    /// The timestamp of the audio's duration.
    @AutoLayout private var timestampLabel: UILabel
    /// The creation data of the audio.
    @AutoLayout private var creationDateLabel: UILabel
    /// The title of the audio.
    @AutoLayout private var titleLabel: UILabel
    /// The play button used to control the component.
    @AutoLayout private var playButton: UIButton
    /// The view used to encapsulate all the views. Used to more easily configure
    /// constraints with its superview (`RootViewController.view`).
    @AutoLayout private var contentView: UIView

// - MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// - MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureProgressSlider()
        configureLabels()
        configurePlayButton()
        configureLayout()
    }

// - MARK: Layout

    /// Configures the main view.
    private func configureView() {
        view.backgroundColor = .memoraMediumGray
        view.layer.cornerRadius = view.frame.height * 0.015
    }

    /// Configures the progress slider.
    private func configureProgressSlider() {
        progressSlider.tintColor = .memoraLightGray
    }

    /// Configures all the labels.
    private func configureLabels() {
        timestampLabel.textColor = .memoraLightGray
        timestampLabel.font = .preferredFont(forTextStyle: .body)
        timestampLabel.text = "04:00"

        creationDateLabel.textColor = .memoraLightGray
        creationDateLabel.font = .preferredFont(forTextStyle: .body)
        creationDateLabel.text = "12/12/2020"

        titleLabel.textColor = .memoraLightGray
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.text = "Memory Title"
    }

    /// Configures the play button.
    private func configurePlayButton() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .memoraLightGray
    }

    /// Configures the layout using the `contentView`.
    private func configureLayout() {
        contentView.addSubview(progressSlider)
        contentView.addSubview(timestampLabel)
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)

        view.addSubview(contentView)

        let rootLayoutMarginsGuide = view.layoutMarginsGuide
        let contentLayoutMarginsGuide = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: rootLayoutMarginsGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: rootLayoutMarginsGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rootLayoutMarginsGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: rootLayoutMarginsGuide.bottomAnchor),

            progressSlider.topAnchor.constraint(equalTo: contentLayoutMarginsGuide.topAnchor),
            progressSlider.widthAnchor.constraint(equalTo: contentLayoutMarginsGuide.widthAnchor),
            progressSlider.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            progressSlider.centerXAnchor.constraint(equalTo: contentLayoutMarginsGuide.centerXAnchor),

            timestampLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 10),
            timestampLabel.leadingAnchor.constraint(equalTo: contentLayoutMarginsGuide.leadingAnchor),

            creationDateLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 10),
            creationDateLabel.trailingAnchor.constraint(equalTo: contentLayoutMarginsGuide.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentLayoutMarginsGuide.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentLayoutMarginsGuide.bottomAnchor),

            playButton.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor),
            playButton.trailingAnchor.constraint(equalTo: contentLayoutMarginsGuide.trailingAnchor),
            playButton.bottomAnchor.constraint(equalTo: contentLayoutMarginsGuide.bottomAnchor)
        ])
    }
}
