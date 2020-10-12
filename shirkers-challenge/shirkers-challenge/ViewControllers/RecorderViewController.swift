//
//  RecorderViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 07/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class RecorderViewController: UIViewController {
    // MARK: - Properties
    @AutoLayout private var recordButton: MemoraRecordButton
    @AutoLayout private var timestampLabel: MemoraLabel
    @AutoLayout private var titleLabel: MemoraLabel
    @AutoLayout private var titleTextField: MemoraTextField
    @AutoLayout private var remindMeLabel: MemoraLabel
    @AutoLayout private var remindMeSlider: MemoraSlider
    @AutoLayout private var saveButton: MemoraButton
    @AutoLayout private var closeButton: MemoraButton

    private lazy var recordButtonShapeLayer = RecordButtonShapeLayer(buttonFrame: recordButton.frame)

    private let viewModel: RecorderViewModel

    /// A anchor identifier used to animate constraints.
    fileprivate enum AnchorIdentifier: String {
        case recordButtonBottom = "record-bottom"
        case recordButtonWidth = "record-width"
        case recordButtonHeight = "record-height"
        case timestampLabelBottom = "timestamp-bottom"
    }

    // MARK: - Init
    init(viewModel: RecorderViewModel = RecorderViewModel(recorder: RecordingController())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        layoutConstraints()
        setUpViewModel()
    }

    // MARK: - @objc
    @objc private func didTapRecord(_ button: MemoraButton) {
        viewModel.recording.toggle()
    }

    @objc private func didTapClose(_ button: MemoraButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didChangeRemindMe(_ slider: MemoraSlider) {
        viewModel.remindMeInPeriod = slider.value
    }

    // MARK: - ViewModel setup
    private func setUpViewModel() {
        viewModel.delegate = self
    }

    // MARK: - Views setup
    private func setUpViews() {
        setUpBlurredView()
        setUpRecordButton()
        setUpRemindMeSlider()
        setUpTimestampLabel()
        setUpCloseButton()
        setUpInfoStackViews()
    }

    private func setUpBlurredView() {
        let blurredView = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurredView)
        visualEffectView.frame = view.frame

        view.addSubview(visualEffectView)
    }

    private func setUpRecordButton() {
        recordButton.addTarget(self, action: #selector(didTapRecord(_:)), for: .touchUpInside)
    }

    private func setUpRemindMeSlider() {
        remindMeSlider.minimumValue = 1
        remindMeSlider.maximumValue = 365

        remindMeSlider.addTarget(self, action: #selector(didChangeRemindMe(_:)), for: .valueChanged)
    }

    private func setUpTimestampLabel() {
        timestampLabel.setUp(with: .timestamp)
    }

    private func setUpCloseButton() {
        closeButton.setUp(with: .close)
        closeButton.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
    }

    private func setUpInfoStackViews() {
        titleLabel.setUp(with: .default)
        titleLabel.text = NSLocalizedString("title", comment: "The memory's title")

        remindMeLabel.setUp(with: .default)
        remindMeLabel.text = NSLocalizedString("remind-me-in", comment: "The reminder deadline")

        saveButton.setUp(with: .save)
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
    }

    // MARK: - Layout
    private func layoutConstraints() {
        layoutRecordButtonConstraints()
        layoutTimestampLabelConstraints()
        layoutCloseButtonConstraints()
        layoutInfoStackViewsConstraints()
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

    private func layoutCloseButtonConstraints() {
        view.addSubview(closeButton)

        let guides = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: guides.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: guides.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.closeButtonHeight)
        ])
    }

    private func layoutInfoStackViewsConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(remindMeLabel)
        view.addSubview(remindMeSlider)
        view.addSubview(saveButton)

        let guides = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor,
                                            constant: DesignSystem.Recorder.titleLabelSpacingFromCloseButton),
            titleLabel.widthAnchor.constraint(equalTo: guides.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.titleLabelHeight),
            titleLabel.centerXAnchor.constraint(equalTo: guides.centerXAnchor),

            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                constant: DesignSystem.Recorder.titleTextFieldSpacingFromTitleLabel),
            titleTextField.widthAnchor.constraint(equalTo: guides.widthAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.titleTextFieldHeight),
            titleTextField.centerXAnchor.constraint(equalTo: guides.centerXAnchor),

            remindMeLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor,
                                               constant: DesignSystem.Recorder.remindMeLabelSpacingFromTitleTextField),
            remindMeLabel.widthAnchor.constraint(equalTo: guides.widthAnchor),
            remindMeLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.remindMeLabelHeight),
            remindMeLabel.centerXAnchor.constraint(equalTo: guides.centerXAnchor),

            remindMeSlider.topAnchor.constraint(equalTo: remindMeLabel.bottomAnchor,
                                                constant: DesignSystem.Recorder.remindMeSliderSpacingFromRemindMeLabel),
            remindMeSlider.widthAnchor.constraint(equalTo: guides.widthAnchor),
            remindMeSlider.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.remindMeSliderHeight),
            remindMeSlider.centerXAnchor.constraint(equalTo: guides.centerXAnchor),

            saveButton.bottomAnchor.constraint(equalTo: timestampLabel.topAnchor,
                                               constant: DesignSystem.Recorder.saveButtonSpacingFromTimestampLabel),
            saveButton.widthAnchor.constraint(equalTo: guides.widthAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: DesignSystem.Recorder.saveButtonHeight),
            saveButton.centerXAnchor.constraint(equalTo: guides.centerXAnchor)
        ])
    }

    // MARK: - Animations
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

// MARK: - ViewModel Delegate
extension RecorderViewController: RecorderViewModelDelegate {
    func didUpdateRemindMe() {
        remindMeLabel.text = viewModel.remindMeIn
    }

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
