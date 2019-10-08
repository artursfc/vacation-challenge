//
//  MemoryPlayerViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 22/08/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class MemoryPlayerViewController: UIViewController {
    
    private var context : NSManagedObjectContext?
    private var recordings : [Recording]?

    private var playButton : CassetteTapeButtonView?
    private var stopButton : CassetteTapeButtonView?
    private var keepButton : CassetteTapeButtonView?
    private var discardButton : CassetteTapeButtonView?
    private var reminderTimeSegmentedControl : CassetteTapeSegmentedControlView?
    
    private var cassetteTapeView : CassetteTapeView?
    private var memoryTitle : UILabel?
    private var timePeriodLabel : UILabel?
    
    private var notificationIdentifier: String?
    
    private var buttonStack : UIStackView?
    
    private var isTapeRunning : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: Notification.Name("didFinishPlaying"), object: nil)
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let context = context {
            do {
                recordings = try context.fetch(Recording.fetchRequest()) as? [Recording]
            }
            catch {
                print(error)
            }
        }
        
        guard let recordings = recordings else { return }
        
        view.backgroundColor = ColorPalette.darkGrey
        
        cassetteTapeView = CassetteTapeView()
        guard let cassetteTapeView = cassetteTapeView else { return }
        
        memoryTitle = UILabel()
        guard let memoryTitle = memoryTitle else { return }
        for n in 0..<recordings.count {
            if recordings[n].path == notificationIdentifier {
                memoryTitle.text = recordings[n].name
            }
        }
        
        buttonStack = UIStackView()
        guard let buttonStack = buttonStack else { return }
        
        playButton = CassetteTapeButtonView(color: ColorPalette.lightGrey, altColor: ColorPalette.grey, text: "PLAY", border: true)
        guard let playButton = playButton else { return }
        playButton.addTarget(self, action: #selector(playAudio), for: .touchDown)
        
        stopButton = CassetteTapeButtonView(color: ColorPalette.lightGrey, altColor: ColorPalette.grey, text: "STOP", border: true)
        guard let stopButton = stopButton else { return }
        stopButton.addTarget(self, action: #selector(stopAudio), for: .touchDown)
        
        keepButton = CassetteTapeButtonView(color: ColorPalette.grey, altColor: ColorPalette.grey, text: "KEEP", border: false)
        guard let keepButton = keepButton else { return }
        keepButton.addTarget(self, action: #selector(keepAudio), for: .touchDown)
        
        discardButton = CassetteTapeButtonView(color: ColorPalette.red, altColor: ColorPalette.red, text: "DEL", border: false)
        guard let discardButton = discardButton else { return }
        discardButton.addTarget(self, action: #selector(discardAudio), for: .touchDown)
        
        reminderTimeSegmentedControl = CassetteTapeSegmentedControlView(items: ReminderPeriods.timePeriods)
        guard let reminderTimeSegmentedControl = reminderTimeSegmentedControl else { return }
        
        timePeriodLabel = UILabel()
        guard let timePeriodLabel = timePeriodLabel else { return }
        
        timePeriodLabel.text = "Remind me in about:"
        timePeriodLabel.textColor = ColorPalette.lightGrey
        timePeriodLabel.font = UIFont(name: Fonts.main, size: 20)
        timePeriodLabel.textAlignment = .center
        
        memoryTitle.textColor = ColorPalette.lightGrey
        memoryTitle.font = UIFont(name: Fonts.main, size: 20)
        memoryTitle.textAlignment = .center
        
        buttonStack.addArrangedSubview(playButton)
        buttonStack.addArrangedSubview(stopButton)
        buttonStack.addArrangedSubview(keepButton)
        buttonStack.addArrangedSubview(discardButton)
        
        buttonStack.spacing = Dimensions.buttonStackViewSpacing
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        
        view.addSubview(memoryTitle)
        view.addSubview(timePeriodLabel)
        view.addSubview(buttonStack)
        view.addSubview(cassetteTapeView)
        view.addSubview(reminderTimeSegmentedControl)
        
        cassetteTapeView.translatesAutoresizingMaskIntoConstraints = false
        cassetteTapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cassetteTapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        cassetteTapeView.widthAnchor.constraint(equalToConstant: Dimensions.cassetteTapeWidth).isActive = true
        cassetteTapeView.heightAnchor.constraint(equalToConstant: Dimensions.cassetteTapeHeight).isActive = true
        
        reminderTimeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        reminderTimeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reminderTimeSegmentedControl.bottomAnchor.constraint(equalTo: cassetteTapeView.topAnchor, constant: -40).isActive = true
        reminderTimeSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        reminderTimeSegmentedControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        memoryTitle.translatesAutoresizingMaskIntoConstraints = false
        memoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryTitle.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.9).isActive = true
        memoryTitle.bottomAnchor.constraint(equalTo: timePeriodLabel.topAnchor, constant: -20).isActive = true
        
        timePeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        timePeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePeriodLabel.bottomAnchor.constraint(equalTo: reminderTimeSegmentedControl.topAnchor, constant: -10).isActive = true
        timePeriodLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        timePeriodLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -self.view.frame.height * 0.1).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: Dimensions.screenWidth * 0.9).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: Dimensions.buttonHeight).isActive = true
        
        
    }
    
    @objc private func playAudio() {
        if isTapeRunning {
            
        } else {
            guard let notificationIdentifier = notificationIdentifier else { return }
            AudioSession.shared.setFile(name: notificationIdentifier)
            guard let duration = AudioSession.shared.getDuration() else { return }
            isTapeRunning = true
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
    
    
    @objc private func keepAudio() {
        guard let reminderTimeSegmentedControl = reminderTimeSegmentedControl else { return }
        let chosenTimePeriod = ReminderPeriods.timeArray[reminderTimeSegmentedControl.selectedSegmentIndex]

        let notificationCenter = UNUserNotificationCenter.current()
        var currentPath: String?
        guard let recordings = self.recordings else { return }
        for n in 0..<recordings.count {
            if recordings[n].path == notificationIdentifier {
                currentPath = recordings[n].path
            }
        }
        if let currentPath = currentPath {
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
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func discardAudio() {
        guard let recordings = self.recordings else { return }
        for n in 0..<recordings.count {
            if recordings[n].path == notificationIdentifier {
                self.context?.delete(recordings[n])
                self.recordings?.remove(at: n)
                guard let notificationIdentifier = notificationIdentifier else { return }
                AudioSession.shared.deleteAudioFile(name: notificationIdentifier)
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.saveContext()
            }
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func didFinishPlaying() {
        guard let cassetteTapeView = cassetteTapeView else { return }
        cassetteTapeView.stopSpoolsAnimation()
    }
    
    public func setNotificationIdentifier(named: String) {
        notificationIdentifier = named
    }
    
    
}




