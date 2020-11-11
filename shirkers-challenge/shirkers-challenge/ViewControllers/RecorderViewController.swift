//
//  RecorderViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 07/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit
import os.log

/// Representation of the Recorder screen.
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

    /// The `CAShapeLayer` used to animate the recording button.
    private lazy var recordButtonShapeLayer = RecordButtonShapeLayer(buttonFrame: recordButton.frame)

    /// The `ViewModel` responsible for this `View`.
    private let viewModel: RecorderViewModel

    /// An anchor identifier used to animate constraints.
    fileprivate enum AnchorIdentifier: String {
        case recordButtonBottom = "record-bottom"
        case recordButtonWidth = "record-width"
        case recordButtonHeight = "record-height"
        case timestampLabelBottom = "timestamp-bottom"
    }

    // MARK: - Init
    /// Initializes a new instance of this type.
    /// - Parameter viewModel: The `ViewModel` responsible for this `View`.
    init(viewModel: RecorderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        os_log("RecorderViewController initialized.", log: .appFlow, type: .debug)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        setUpViews()
        layoutConstraints()

        // Sets a observer in case the user closes the app before it deletes
        // the previous recording.
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(remove(_:)),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)
    }

    // MARK: - @objc
    @objc private func didTapRecord(_ button: MemoraButton) {
        os_log("RecorderViewController requested its ViewModel to start recording.", log: .appFlow, type: .debug)
        viewModel.recording.toggle()
    }

    @objc private func didTapClose(_ button: MemoraButton) {
        os_log("RecorderViewController should close.", log: .appFlow, type: .debug)
        viewModel.clean()
        dismiss(animated: true, completion: nil)
    }

    @objc private func didChangeRemindMe(_ slider: MemoraSlider) {
        viewModel.remindMePeriod = slider.value
    }

    @objc private func didTapSave(_ button: MemoraButton) {
        os_log("RecorderViewController requested its ViewModel to save the recording.", log: .appFlow, type: .debug)
        viewModel.save()
        dismiss(animated: true, completion: nil)
    }

    @objc private func didEditText(_ textfield: MemoraTextField) {
        viewModel.title = textfield.text ?? ""
    }

    /// Removes file representing a memory's audio before app is terminated.
    @objc private func remove(_ notification: Notification) {
        viewModel.clean()
    }

    // MARK: - ViewModel setup
    private func setUpViewModel() {
        if !viewModel.permission {
            viewModel.requestPermission()
        }
        viewModel.delegate = self
    }

    // MARK: - Views setup
    private func setUpViews() {
        setUpBlurredView()
        setUpRecordButton()
        setUpSaveButton()
        setUpTextField()
        setUpRemindMeSlider()
        setUpTimestampLabel()
        setUpCloseButton()
        setUpInfoStackViews()
    }

    private func setUpBlurredView() {
        switch UIColor.currentTheme {
        case .default:
            let blurredView = UIBlurEffect(style: .dark)
            let visualEffectView = UIVisualEffectView(effect: blurredView)
            visualEffectView.frame = view.frame

            view.addSubview(visualEffectView)
        case .pastel:
            let blurredView = UIBlurEffect(style: .light)
            let visualEffectView = UIVisualEffectView(effect: blurredView)
            visualEffectView.frame = view.frame

            view.addSubview(visualEffectView)
        }
    }

    private func setUpRecordButton() {
        recordButton.addTarget(self, action: #selector(didTapRecord(_:)), for: .touchUpInside)
    }

    private func setUpSaveButton() {
        saveButton.addTarget(self, action: #selector(didTapSave(_:)), for: .touchUpInside)
    }

    private func setUpTextField() {
        titleTextField.addTarget(self, action: #selector(didEditText(_:)), for: .editingChanged)
    }

    private func setUpRemindMeSlider() {
        remindMeSlider.minimumValue = 1
        remindMeSlider.maximumValue = 365

        remindMeSlider.addTarget(self, action: #selector(didChangeRemindMe(_:)), for: .valueChanged)
    }

    private func setUpTimestampLabel() {
        timestampLabel.setUp(as: .timestamp)
    }

    private func setUpCloseButton() {
        closeButton.setUp(as: .close)
        closeButton.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
    }

    private func setUpInfoStackViews() {
        titleLabel.setUp(as: .default)
        titleLabel.text = NSLocalizedString("title", comment: "The memory's title")

        remindMeLabel.setUp(as: .default)
        remindMeLabel.text = "\(NSLocalizedString("remind-me-in", comment: "The reminder deadline")) 1 day"

        saveButton.setUp(as: .save)
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

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - ViewModel Delegate
extension RecorderViewController: RecorderViewModelDelegate {
    func didUpdateTimestamp() {
        timestampLabel.text = viewModel.currentTimestamp
    }

    func didUpdateRemindMe() {
        remindMeLabel.text = viewModel.remindMe
    }

    func didStartRecording() {
        os_log("RecorderViewController should start the recording animation.", log: .appFlow, type: .debug)
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
        os_log("RecorderViewController should stop the recording animation.", log: .appFlow, type: .debug)
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
