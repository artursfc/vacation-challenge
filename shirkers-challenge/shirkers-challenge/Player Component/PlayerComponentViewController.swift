//
//  PlayerComponentViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class PlayerComponentViewController: UIViewController {

    @AutoLayout private var progressSlider: UISlider
    @AutoLayout private var timestampLabel: UILabel
    @AutoLayout private var creationDateLabel: UILabel
    @AutoLayout private var titleLabel: UILabel
    @AutoLayout private var playButton: UIButton

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .memoraMediumGray
        view.layer.cornerRadius = view.frame.height * 0.015

        setupProgressSlider()
        setupLabels()
        setupPlayButton()
        setupLayout()
    }

    private func setupProgressSlider() {
        progressSlider.tintColor = .memoraLightGray
    }

    private func setupLabels() {
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

    private func setupPlayButton() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .memoraLightGray
    }

    private func setupLayout() {
        view.addSubview(progressSlider)
        view.addSubview(timestampLabel)
        view.addSubview(creationDateLabel)
        view.addSubview(titleLabel)
        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            progressSlider.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            progressSlider.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            progressSlider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            progressSlider.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),

            timestampLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 10),
            timestampLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),

            creationDateLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 10),
            creationDateLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

            playButton.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            playButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
