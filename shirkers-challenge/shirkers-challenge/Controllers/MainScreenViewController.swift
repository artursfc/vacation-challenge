//
//  MainScreenViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    private var memoryTitle : UITextField?
    private var timePeriodLabel : UILabel?
    private var cassetteTapeView : CassetteTapeView?
    private var buttonStackView : UIStackView?
    private var reminderTimeSegmentedControl : CassetteTapeSegmentedControlView?
    
    private var isTapeRunning : Bool = false
    
    private var recordButton : CassetteTapeButtonView?
    private var playButton : CassetteTapeButtonView?
    private var stopButton : CassetteTapeButtonView?
    private var saveButton : CassetteTapeButtonView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTap()
        
        self.view.backgroundColor = ColorPalette.darkGrey
        
        reminderTimeSegmentedControl = CassetteTapeSegmentedControlView(items: ReminderPeriods.timePeriods)
        guard let reminderTimeSegmentedControl = reminderTimeSegmentedControl else { return }
        
        cassetteTapeView = CassetteTapeView()
        guard let cassetteTapeView = cassetteTapeView else { return }
        
        buttonStackView = UIStackView()
        guard let buttonStackView = buttonStackView else { return }
        buttonStackView.spacing = Dimensions.buttonStackViewSpacing
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        
        memoryTitle = UITextField()
        guard let memoryTitle = memoryTitle else { return }
        
        timePeriodLabel = UILabel()
        guard let timePeriodLabel = timePeriodLabel else { return }
        
        timePeriodLabel.text = "Remind me in days:"
        timePeriodLabel.textColor = ColorPalette.grey
        timePeriodLabel.font = UIFont(name: Fonts.main, size: 17)
        timePeriodLabel.textAlignment = .center
        
        memoryTitle.attributedPlaceholder = NSAttributedString(string: "memory title", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.grey])
        memoryTitle.keyboardAppearance = .dark
        memoryTitle.autocorrectionType = .no
        memoryTitle.returnKeyType = .done
        memoryTitle.textColor = ColorPalette.lightGrey
        memoryTitle.font = UIFont(name: Fonts.main, size: 24)
        
        recordButton = CassetteTapeButtonView(color: ColorPalette.red, altColor: ColorPalette.grey, text: "REC", border: false)
        guard let recordButton = recordButton else { return }
        recordButton.addTarget(self, action: #selector(startRec), for: .touchDown)
        
        playButton = CassetteTapeButtonView(color: ColorPalette.grey, altColor: ColorPalette.darkGrey, text: "PLAY", border: true)
        guard let playButton = playButton else { return }
        playButton.alpha = 0.2
        playButton.addTarget(self, action: #selector(playAudio), for: .touchDown)
        
        stopButton = CassetteTapeButtonView(color: ColorPalette.grey, altColor: ColorPalette.darkGrey, text: "STOP", border: true)
        guard let stopButton = stopButton else { return }
        stopButton.alpha = 0.2
        stopButton.addTarget(self, action: #selector(stopAudio), for: .touchDown)
        
        saveButton = CassetteTapeButtonView(color: ColorPalette.grey, altColor: ColorPalette.darkGrey, text: "SAVE", border: false)
        guard let saveButton = saveButton else { return }
        saveButton.alpha = 0.2
        saveButton.addTarget(self, action: #selector(saveAudio), for: .touchDown)
    
        buttonStackView.addArrangedSubview(recordButton)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(stopButton)
        buttonStackView.addArrangedSubview(saveButton)
        
        self.view.addSubview(buttonStackView)
        self.view.addSubview(cassetteTapeView)
        self.view.addSubview(memoryTitle)
        self.view.addSubview(timePeriodLabel)
        self.view.addSubview(reminderTimeSegmentedControl)

        cassetteTapeView.translatesAutoresizingMaskIntoConstraints = false
        cassetteTapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cassetteTapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cassetteTapeView.widthAnchor.constraint(equalToConstant: Dimensions.cassetteTapeWidth).isActive = true
        cassetteTapeView.heightAnchor.constraint(equalToConstant: Dimensions.cassetteTapeHeight).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: cassetteTapeView.bottomAnchor, constant: 100).isActive = true
        buttonStackView.widthAnchor.constraint(equalToConstant: Dimensions.screenWidth * 0.9).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: Dimensions.buttonHeight).isActive = true
        
        reminderTimeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        reminderTimeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reminderTimeSegmentedControl.bottomAnchor.constraint(equalTo: cassetteTapeView.topAnchor, constant: -40).isActive = true
        reminderTimeSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        reminderTimeSegmentedControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        timePeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        timePeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePeriodLabel.bottomAnchor.constraint(equalTo: reminderTimeSegmentedControl.topAnchor, constant: -10).isActive = true
        timePeriodLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        timePeriodLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        memoryTitle.translatesAutoresizingMaskIntoConstraints = false
        memoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryTitle.bottomAnchor.constraint(equalTo: timePeriodLabel.topAnchor, constant: -20).isActive = true
    }
    
    
    @objc private func startRec() {
        guard let cassetteTapeView = cassetteTapeView else { return }
        guard let recordButton = recordButton else { return }
        if isTapeRunning == false {
            cassetteTapeView.startSpoolsAnimation(duration: 1)
            cassetteTapeView.startOutlineAnimation(duration: 15)
            recordButton.switchColors()
            isTapeRunning = true
        } else {
            cassetteTapeView.stopSpoolsAnimation()
            cassetteTapeView.stopOutlineAnimation()
            recordButton.switchColors()
            isTapeRunning = false
        }
    }
    
    @objc private func playAudio() {
        guard let playButton = playButton else { return }
        playButton.alpha = 1
        playButton.switchColors()
    }
    
    @objc private func stopAudio() {
        guard let stopButton = stopButton  else { return }
        stopButton.alpha = 1
        stopButton.switchColors()
    }
    
    @objc private func saveAudio() {
        guard let saveButton = saveButton else { return }
        saveButton.alpha = 1
    }
    

}

