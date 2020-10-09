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
    @AutoLayout private var titleTextField: UITextField

    private lazy var recordButtonShapeLayer = RecordButtonShapeLayer(buttonFrame: recordButton.frame)

    private let viewModel: RecorderViewModel

    /// A anchor identifier used to animate constraints.
    fileprivate enum AnchorIdentifier: String {
        case recordButtonBottom = "record-bottom"
        case recordButtonWidth = "record-width"
        case recordButtonHeight = "record-height"
        case timestampLabelBottom = "timestamp-bottom"
    }

    // MARK: Init
    init(viewModel: RecorderViewModel = RecorderViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        layoutConstraints()
        setUpViewModel()
    }

    // MARK: @objc
    @objc private func didTapRecord(_ button: UIButton) {
        viewModel.recording.toggle()
    }

    // MARK: ViewModel setup
    private func setUpViewModel() {
        viewModel.delegate = self
    }

    // MARK: Views setup
    private func setUpViews() {
        setUpBlurredView()
        setUpRecordButton()
        setUpTimestampLabel()
        setUpTitleTextField()
    }

    private func setUpBlurredView() {
        let blurredView = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurredView)
        visualEffectView.frame = view.frame

        view.addSubview(visualEffectView)
    }

    private func setUpRecordButton() {
        recordButton.backgroundColor = .memoraRed
        recordButton.layer.cornerRadius = DesignSystem.Recorder.recordButtonHeight/2
        recordButton.clipsToBounds = true

        recordButton.addTarget(self, action: #selector(didTapRecord(_:)), for: .touchUpInside)
    }

    private func setUpTimestampLabel() {
        timestampLabel.text = "04:00"
        timestampLabel.textColor = .memoraLightGray
        timestampLabel.textAlignment = .center
        timestampLabel.font = .preferredFont(forTextStyle: .headline)
    }

    private func setUpTitleTextField() {
        titleTextField.placeholder = "Memory's title"
        titleTextField.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        titleTextField.tintColor = .memoraLightGray
        titleTextField.textAlignment = .center
        titleTextField.textColor = .memoraLightGray
    }

    // MARK: Layout
    private func layoutConstraints() {
        layoutRecordButtonConstraints()
        layoutTimestampLabelConstraints()
        layoutTitleTextFieldConstraints()
    }

    private func layoutRecordButtonConstraints() {
        view.addSubview(recordButton)

        let guides = view.safeAreaLayoutGuide

        let bottomConstraint = recordButton.bottomAnchor.constraint(equalTo: guides.bottomAnchor,
                                             constant: -DesignSystem.Recorder.spacingFromBottom)
        let widthConstraint = recordButton.widthAnchor.constraint(equalToConstant: DesignSystem.Recorder.recordButtonWidth)
        let heightConstraint = recordButton.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.recordButtonHeight)
        let centerXconstraint = recordButton.centerXAnchor.constraint(equalTo: guides.centerXAnchor)

        NSLayoutConstraint.activate([bottomConstraint,
                                     widthConstraint,
                                     heightConstraint,
                                     centerXconstraint])

        widthConstraint.identifier = AnchorIdentifier.recordButtonWidth.rawValue
        heightConstraint.identifier = AnchorIdentifier.recordButtonHeight.rawValue
        bottomConstraint.identifier = AnchorIdentifier.recordButtonBottom.rawValue
    }

    private func layoutTimestampLabelConstraints() {
        view.addSubview(timestampLabel)

        let guides = view.safeAreaLayoutGuide

        let bottomAnchor = timestampLabel.bottomAnchor.constraint(equalTo: recordButton.topAnchor,
                                                                  constant: -DesignSystem.Recorder.spacingFromRecordButton)

        NSLayoutConstraint.activate([
            bottomAnchor,
            timestampLabel.widthAnchor.constraint(equalTo: guides.widthAnchor,
                                                  multiplier: DesignSystem.Recorder.timestampLabelWidthMultiplier),
            timestampLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.timestampLabelHeight),
            timestampLabel.centerXAnchor.constraint(equalTo: guides.centerXAnchor)
        ])

        bottomAnchor.identifier = AnchorIdentifier.timestampLabelBottom.rawValue
    }

    private func layoutTitleTextFieldConstraints() {
        view.addSubview(titleTextField)

        let guides = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            titleTextField.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 30),
            titleTextField.topAnchor.constraint(equalTo: guides.topAnchor,
                                                constant: 50),
            titleTextField.widthAnchor.constraint(equalTo: guides.widthAnchor,
                                                  multiplier: 0.8)
        ])
    }

    // MARK: Animations
    private func shouldAnimateRecordingButton(_ animated: Bool) {
        if animated {
            let animation = RecordButtonAnimation()

            view.layer.addSublayer(recordButtonShapeLayer)
            recordButtonShapeLayer.add(animation, forKey: animation.identifier)
        } else {
            recordButtonShapeLayer.removeAllAnimations()
            recordButtonShapeLayer.removeFromSuperlayer()
        }
    }
}

// MARK: ViewModel Delegate
extension RecorderViewController: RecorderViewModelDelegate {
    func didStartRecording() {
        guard let timestampBottomAnchor = view.constraints.first(where: {
            $0.identifier == AnchorIdentifier.timestampLabelBottom.rawValue
        }) else { return }
        guard let bottomAnchor = view.constraints.first(where: {
            $0.identifier == AnchorIdentifier.recordButtonBottom.rawValue
        }) else { return }
        guard let widthAnchor = recordButton.constraints.first(where: {
            $0.identifier == AnchorIdentifier.recordButtonWidth.rawValue
        }) else { return }
        guard let heightAnchor = recordButton.constraints.first(where: {
            $0.identifier == AnchorIdentifier.recordButtonHeight.rawValue
        }) else { return }

        shouldAnimateRecordingButton(true)

        timestampBottomAnchor.constant = -(DesignSystem.Recorder.spacingFromRecordButton + DesignSystem.Recorder.recordButtonHeight * 0.5/2)

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1) { [weak self] in
            guard let self = self else { return }
            self.recordButton.layer.cornerRadius = (DesignSystem.Recorder.recordButtonHeight * 0.5) / 2
            bottomAnchor.constant = -(DesignSystem.Recorder.spacingFromBottom + (DesignSystem.Recorder.recordButtonHeight * 0.5)/2)
            widthAnchor.constant = DesignSystem.Recorder.recordButtonWidth * 0.5
            heightAnchor.constant = DesignSystem.Recorder.recordButtonHeight * 0.5

            self.recordButton.layoutIfNeeded()
        }
    }

    func didStopRecording() {
        guard let timestampBottomAnchor = view.constraints.first(where: {
            $0.identifier == AnchorIdentifier.timestampLabelBottom.rawValue
        }) else { return }
        guard let bottomAnchor = view.constraints.first(where: {
            $0.identifier == AnchorIdentifier.recordButtonBottom.rawValue
        }) else { return }
        guard let widthAnchor = recordButton.constraints.first(where: {
            $0.identifier == AnchorIdentifier.recordButtonWidth.rawValue
        }) else { return }
        guard let heightAnchor = recordButton.constraints.first(where: {
            $0.identifier == AnchorIdentifier.recordButtonHeight.rawValue
        }) else { return }

        shouldAnimateRecordingButton(false)
        timestampBottomAnchor.constant = -(DesignSystem.Recorder.spacingFromRecordButton)

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1) { [weak self] in
            guard let self = self else { return }
            self.recordButton.layer.cornerRadius = (DesignSystem.Recorder.recordButtonHeight * 1.0) / 2
            bottomAnchor.constant = -(DesignSystem.Recorder.spacingFromBottom)
            widthAnchor.constant = DesignSystem.Recorder.recordButtonWidth * 1.0
            heightAnchor.constant = DesignSystem.Recorder.recordButtonHeight * 1.0

            self.recordButton.layoutIfNeeded()
        }
    }
}
