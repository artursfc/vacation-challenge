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
        timestampLabel.text = "04:00"

        creationDateLabel.textColor = .memoraLightGray
        creationDateLabel.text = "12/12/2020"

        titleLabel.textColor = .memoraLightGray
        titleLabel.text = "Memory Title"
    }

    private func setupPlayButton() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    private func setupLayout() {
        view.addSubview(progressSlider)
        view.addSubview(timestampLabel)
        view.addSubview(creationDateLabel)
        view.addSubview(titleLabel)
        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            progressSlider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressSlider.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            progressSlider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            progressSlider.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            timestampLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor),
            timestampLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            timestampLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            timestampLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            creationDateLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor),
            creationDateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            creationDateLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            creationDateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            playButton.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            playButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
