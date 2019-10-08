//
//  MainScreenViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreData
import UserNotifications

class MainScreenViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var recordingsBarButton: UIBarButtonItem!
    
    private var recordingTest: UIBarButtonItem?
    
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
    
    private var recordingsButton : UIButton?
    
    private var context : NSManagedObjectContext?
    private var date : Date?
    public var currentPath : String?

    private var notificationsFlag : Bool?
    private var microphoneFlag : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTap()
        
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: Notification.Name("didFinishPlaying"), object: nil)
        
        microphoneFlag = getMicrophonePermission()
        notificationsFlag = getNotificationsPermission()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.view.backgroundColor = ColorPalette.darkGrey
        
        reminderTimeSegmentedControl = CassetteTapeSegmentedControlView(items: ReminderPeriods.timePeriods)
        guard let reminderTimeSegmentedControl = reminderTimeSegmentedControl else { return }
        
        cassetteTapeView = CassetteTapeView()
        guard let cassetteTapeView = cassetteTapeView else { return }
        cassetteTapeView.delegate = self
        
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
        
        timePeriodLabel.text = "Remind me in about:"
        timePeriodLabel.textColor = ColorPalette.lightGrey
        timePeriodLabel.font = UIFont(name: Fonts.main, size: 20)
        timePeriodLabel.textAlignment = .center
        
        memoryTitle.attributedPlaceholder = NSAttributedString(string: "memory title", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.grey])
        memoryTitle.keyboardAppearance = .dark
        memoryTitle.autocorrectionType = .no
        memoryTitle.returnKeyType = .done
        memoryTitle.textAlignment = .center
        memoryTitle.delegate = self
        memoryTitle.textColor = ColorPalette.lightGrey
        memoryTitle.font = UIFont(name: Fonts.main, size: 24)
        
        recordButton = CassetteTapeButtonView(color: ColorPalette.red, altColor: ColorPalette.grey, text: "REC", border: false)
        guard let recordButton = recordButton else { return }
        recordButton.addTarget(self, action: #selector(startRec), for: .touchDown)
        
        playButton = CassetteTapeButtonView(color: ColorPalette.grey, altColor: ColorPalette.darkGrey, text: "PLAY", border: true)
        guard let playButton = playButton else { return }
        playButton.isEnabled = false
        playButton.alpha = 0.2
        playButton.addTarget(self, action: #selector(playAudio), for: .touchDown)
        
        stopButton = CassetteTapeButtonView(color: ColorPalette.grey, altColor: ColorPalette.darkGrey, text: "STOP", border: true)
        guard let stopButton = stopButton else { return }
        stopButton.isEnabled = false
        stopButton.alpha = 0.2
        stopButton.addTarget(self, action: #selector(stopAudio), for: .touchDown)
        
        saveButton = CassetteTapeButtonView(color: ColorPalette.grey, altColor: ColorPalette.darkGrey, text: "SAVE", border: false)
        guard let saveButton = saveButton else { return }
        saveButton.isEnabled = false
        saveButton.alpha = 0.2
        saveButton.addTarget(self, action: #selector(saveAudio), for: .touchDown)
        
        recordingsBarButton.title = "Recordings"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.barTintColor = ColorPalette.darkGrey
    
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
        cassetteTapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        cassetteTapeView.widthAnchor.constraint(equalToConstant: Dimensions.cassetteTapeWidth).isActive = true
        cassetteTapeView.heightAnchor.constraint(equalToConstant: Dimensions.cassetteTapeHeight).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -self.view.frame.height * 0.1).isActive = true
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
        memoryTitle.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.9).isActive = true
        memoryTitle.bottomAnchor.constraint(equalTo: timePeriodLabel.topAnchor, constant: -20).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        memoryTitle?.resignFirstResponder()
        return false
    }
    
    @objc private func startRec() {
        guard let playButton = playButton else { return }
        guard let stopButton = stopButton else { return }
        guard let saveButton = saveButton else { return }
        guard let cassetteTapeView = cassetteTapeView else { return }
        date = getDate()
        guard let date = date else { return }
        if !isTapeRunning {
            if let currentPath = currentPath {
                AudioSession.shared.deleteAudioFile(name: currentPath)
            }
            let fileName = createFileName(date: date)
            currentPath = fileName
            AudioSession.shared.setFile(name: fileName)
            AudioSession.shared.setupRecorder()
            cassetteTapeView.startSpoolsAnimation(duration: 1)
            cassetteTapeView.startOutlineAnimation(duration: AudioSettings.duration)
            isTapeRunning = true
            AudioSession.shared.record()
        } else {
            cassetteTapeView.stopSpoolsAnimation()
            cassetteTapeView.stopOutlineAnimation()
            isTapeRunning = false
            AudioSession.shared.stopRecording()
            AudioSession.shared.setupPlayer()
            
            playButton.isEnabled = true
            stopButton.isEnabled = true
            saveButton.isEnabled = true
        }
    }
    
    @objc private func playAudio() {
        if isTapeRunning {
            
        } else {
            isTapeRunning = true
            guard let duration = AudioSession.shared.getDuration() else { return }
            guard let cassetteTapeView = cassetteTapeView else { return }
            cassetteTapeView.startSpoolsAnimation(duration: 1)
            cassetteTapeView.startOutlineAnimation(duration: duration)
            AudioSession.shared.play()
        }
    }
    
    @objc private func stopAudio() {
        if isTapeRunning {
            isTapeRunning = false
            guard let cassetteTapeView = cassetteTapeView else { return }
            cassetteTapeView.stopSpoolsAnimation()
            cassetteTapeView.stopOutlineAnimation()
            AudioSession.shared.stopPlaying()
        }
    }
    
    @objc private func saveAudio() {
        guard let playButton = playButton else { return }
        guard let stopButton = stopButton else { return }
        guard let saveButton = saveButton else { return }
        guard let memoryTitle = memoryTitle else { return }
        guard let name = memoryTitle.text else { return }
        guard let date = date else { return }
        guard let context = context else { return }
        guard let reminderTimeSegmentedControl = reminderTimeSegmentedControl else { return }
        if !name.isEmpty {
            if let recording = NSEntityDescription.insertNewObject(forEntityName: "Recording", into: context) as? Recording {
                recording.name = name
                recording.date = date as NSDate
                recording.path = currentPath
            }
            
            let chosenTimePeriod = ReminderPeriods.timeArray[reminderTimeSegmentedControl.selectedSegmentIndex]

            let notificationCenter = UNUserNotificationCenter.current()
            
            guard let currentPath = currentPath else { return }
            
            notificationCenter.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    
                    content.title = NSString.localizedUserNotificationString(forKey: NotificationTexts.title, arguments: nil)
                    content.body = NSString.localizedUserNotificationString(forKey: NotificationTexts.body, arguments: nil)
                    content.sound = UNNotificationSound.default
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: chosenTimePeriod, repeats: false)
                    let request = UNNotificationRequest(identifier: currentPath, content: content, trigger: trigger)
                    
                    notificationCenter.add(request, withCompletionHandler: { (error : Error? ) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    })
                } else {
                    print("Permission denied")
                }
            }
            
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.saveContext()
            memoryTitle.text = ""
            playButton.isEnabled = false
            stopButton.isEnabled = false
            saveButton.isEnabled = false
            
            playButton.alpha = 1
            stopButton.alpha = 1
            saveButton.alpha = 1
            
            AudioSession.shared.clearFileNames()
            
        }
    }
        
    
    private func createFileName(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd+HH-mm-ss"
        return dateFormatter.string(from: date)
    }
    
    private func getDate() -> Date {
        return Date()
    }
    
    private func getMicrophonePermission() -> Bool {
        return AudioSession.shared.checkMicrophonePermission()
    }
    
    private func getNotificationsPermission() -> Bool {
        let notiticationCenter = UNUserNotificationCenter.current()
        let options : UNAuthorizationOptions = [.alert, .sound]
        
        var notificationsAllowed : Bool = false
        
        notiticationCenter.requestAuthorization(options: options) { (didAllow, error) in
            NotificationCenter.default.post(name: NSNotification.Name("permissionDidChange"), object: self)
            notificationsAllowed = didAllow
            if !didAllow {
                print("Notifications not allowed by user")
            }
        }
        return notificationsAllowed
    }
    
    @objc func didFinishPlaying() {
        guard let cassetteTapeView = cassetteTapeView else { return }
        cassetteTapeView.stopSpoolsAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        AudioSession.shared.clearFileNames()
        
        guard let cassetteTapeView = cassetteTapeView else { return }
        if isTapeRunning {
            cassetteTapeView.stopSpoolsAnimation()
            cassetteTapeView.stopOutlineAnimation()
            AudioSession.shared.stopPlaying()
        } else {
            cassetteTapeView.stopSpoolsAnimation()
            cassetteTapeView.stopOutlineAnimation()
            AudioSession.shared.stopRecording()
        }
        
        currentPath = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let playButton = playButton, let stopButton = stopButton, let saveButton = saveButton else { return }
        playButton.isEnabled = false
        stopButton.isEnabled = false
        saveButton.isEnabled = false
        
        playButton.alpha = 0.2
        stopButton.alpha = 0.2
        saveButton.alpha = 0.2
    }
}

extension MainScreenViewController : CassetteTapeViewDelegate {
    
    func tapeDidStop(finished: Bool) {
        guard let playButton = playButton else { return }
        guard let stopButton = stopButton else { return }
        guard let saveButton = saveButton else { return }
        self.isTapeRunning = false
        playButton.alpha = 1
        stopButton.alpha = 1
        saveButton.alpha = 1
    }
}

extension MainScreenViewController : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            let vc = MemoryPlayerViewController()
            vc.setNotificationIdentifier(named: response.notification.request.identifier)
            navigationController?.pushViewController(vc, animated: true)
            completionHandler()
        default:
            completionHandler()
        }
    }
}


