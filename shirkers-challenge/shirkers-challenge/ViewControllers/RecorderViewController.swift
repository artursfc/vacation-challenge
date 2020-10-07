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
        view.backgroundColor = .memoraMediumGray
        setUpViews()
        layoutConstraints()
    }

    // MARK: @objc
    @objc private func didTapRecord(_ button: UIButton) {
        button.setBackgroundImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
    }

    // MARK: Views setup
    private func setUpViews() {
        setUpRecordButton()
        setUpTimestampLabel()
    }

    private func setUpRecordButton() {
        recordButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        recordButton.tintColor = .memoraRed

        recordButton.addTarget(self, action: #selector(didTapRecord(_:)), for: .touchUpInside)
    }

    private func setUpTimestampLabel() {
        timestampLabel.text = "04:00"
        timestampLabel.textColor = .memoraLightGray
        timestampLabel.textAlignment = .center
        timestampLabel.font = .preferredFont(forTextStyle: .headline)
    }

    // MARK: Layout
    private func layoutConstraints() {
        layoutRecordButtonConstraints()
        layoutTimestampLabelConstraints()
    }

    private func layoutRecordButtonConstraints() {
        view.addSubview(recordButton)

        let guides = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            recordButton.bottomAnchor.constraint(equalTo: guides.bottomAnchor,
                                                 constant: -DesignSystem.Recorder.spacingFromBottom),
            recordButton.widthAnchor.constraint(equalToConstant: DesignSystem.Recorder.recordButtonWidth),
            recordButton.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.recordButtonHeight),
            recordButton.centerXAnchor.constraint(equalTo: guides.centerXAnchor)
        ])
    }

    private func layoutTimestampLabelConstraints() {
        view.addSubview(timestampLabel)

        let guides = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            timestampLabel.bottomAnchor.constraint(equalTo: recordButton.topAnchor,
                                                 constant: -DesignSystem.Recorder.spacingFromRecordButton),
            timestampLabel.widthAnchor.constraint(equalTo: guides.widthAnchor,
                                                multiplier: DesignSystem.Recorder.timestampLabelWidthMultiplier),
            timestampLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.timestampLabelHeight),
            timestampLabel.centerXAnchor.constraint(equalTo: guides.centerXAnchor)
        ])
    }
}
