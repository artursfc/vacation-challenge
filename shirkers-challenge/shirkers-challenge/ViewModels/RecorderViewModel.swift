//
//  RecorderViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData
import UserNotifications
import os.log

// MARK: - Protocol-Delegate
/// The  delegate responsible for allowing communication between
/// `RecorderViewModel` and its `View`.
protocol RecorderViewModelDelegate: AnyObject {
    func didStartRecording()
    func didStopRecording()
    func didUpdateRemindMe()
    func didUpdateTimestamp()
}

/// Responsible for providing the `View` with all the necessary
/// funcionalities and data for performing a recording.
final class RecorderViewModel {
    // MARK: - Properties
    /// The recorder abstraction.
    private var recorder: Recorder

    /// The period to remind the user in seconds. It should be
    /// used to perform comparision between periods.
    private var remindMeInSeconds: Int = 1

    /// The curent time in sync with `timestampTimer`.
    private var internalCurrentTime: TimeInterval = 0.0

    /// The timer responsible for keeping track of time elapsed.
    private var timestampTimer: Timer?

    /// The current date which is used as the recording filename.
    /// It resets everytime a new recording is started. With every new
    /// recording, the previous recording file should be deleted using the `oldValue`
    /// inside the `didSet`.
    private var currentDate: Date? {
        didSet {
            if let previousDate = oldValue {
                remove(file: previousDate.toBeSavedFormat())
            }
        }
    }

    /// The memory's timestamp.
    var currentTimestamp: String {
        return internalCurrentTime.toBeDisplayedFormat()
    }

    /// The context used to save to Core Data.
    private let context: NSManagedObjectContext

    private let uncenter: UNUserNotificationCenter

    /// The  delegate responsible for allowing communication between
    /// `RecorderViewModel` and its `View`.
    weak var delegate: RecorderViewModelDelegate?

    // MARK: - Init
    /// Initializes a new instance of this type.
    /// - Parameter recorder: The recorder abstraction.
    /// - Parameter context: The context used to save to Core Data.
    init(recorder: Recorder,
         context: NSManagedObjectContext,
         uncenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.recorder = recorder
        self.context = context
        self.uncenter = uncenter
        self.recorder.didFinishRecording = { [weak self] (successfully) in
            guard let self = self else { return }
            self.recording = false
        }
        os_log("RecorderViewModel initialized.", log: .appFlow, type: .debug)
    }

    // MARK: - API
    /// Whether the app has permission or not record audio.
    var permission: Bool {
        return recorder.permission
    }

    /// The recording status flag. It triggers an array of actions in the app.
    /// After set, it should generate a new date, set up the recorder, start the recording.
    /// If set to false, it should stop the recorder.
    var recording: Bool = false {
        didSet {
            if recording {
                currentDate = Date()
                if let fileName = currentDate?.toBeSavedFormat() {
                    do {
                        try recorder.setUp(for: fileName)
                        try recorder.start()
                        delegate?.didStartRecording()
                        timestampTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] (_) in
                            guard let self = self else {
                                return
                            }

                            self.internalCurrentTime += 0.01
                            self.delegate?.didUpdateTimestamp()
                        })
                        delegate?.didUpdateTimestamp()
                    } catch {
                        os_log("RecorderViewModel's recorder failed to start", log: .appFlow, type: .error)
                    }
                }
            } else {
                do {
                    try recorder.stop()
                    delegate?.didStopRecording()
                    if timestampTimer != nil {
                        timestampTimer?.invalidate()
                        internalCurrentTime = 0.0
                        timestampTimer = nil
                        delegate?.didUpdateTimestamp()
                    }
                } catch {
                    os_log("RecorderViewModel's recorder failed to stop", log: .appFlow, type: .error)
                }

            }
        }
    }

    /// The memory's title.
    var title: String = ""

    /// The formatted memory's notification period.
    var remindMe: String {
        let localizedRemindMe = NSLocalizedString("remind-me-in", comment: "The reminder deadline")
        if remindMeInSeconds > (60*60*24) {
            let localizedDays = NSLocalizedString("days", comment: "Plural reminder dueDate")
            return "\(localizedRemindMe) \(Int(remindMePeriod)) \(localizedDays)"
        } else {
            let localizedDay = NSLocalizedString("day", comment: "Singular reminder dueDate")
            return "\(localizedRemindMe) \(Int(remindMePeriod)) \(localizedDay)"
        }
    }

    /// The memory's notification period.
    var remindMePeriod: Float = 1.0 {
        didSet {
            remindMeInSeconds = Int(remindMePeriod) * 24 * 60 * 60
            delegate?.didUpdateRemindMe()
        }
    }

    /// Requests user's permission to record.
    func requestPermission() {
        do {
            try recorder.requestPermission()
        } catch {
            os_log("RecorderViewModel's recorder failed to get permission.", log: .appFlow, type: .error)
        }
    }

    /// Saves memory to Core Data.
    func save() {
        guard let createdAt = currentDate else {
            return
        }

        let memory = Recording(context: context)
        memory.title = title
        memory.createdAt = createdAt
        memory.isActive = true
        memory.modifiedAt = createdAt
        let timeInterval = TimeInterval.random(in: TimeInterval(Double(remindMeInSeconds)*0.8)..<TimeInterval(remindMeInSeconds))
        let dueDate = Date(timeInterval: timeInterval, since: createdAt)
        memory.dueDate = dueDate
        memory.path = createdAt.toBeSavedFormat()

        schedule(for: timeInterval, with: createdAt.toBeSavedFormat())

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                os_log("RecorderViewModel failed to save to Core Data", log: .appFlow, type: .error)
            }
        }
    }

    func clean() {
        guard let fileName = currentDate?.toBeSavedFormat() else {
            os_log("RecorderViewModel failed to remove a memory's file befoe app's termination.", log: .appFlow, type: .error)
            return
        }
        remove(file: fileName)
    }

    // MARK: - UserNotification
    private func schedule(for interval: TimeInterval, with identifier: String) {
        uncenter.getNotificationSettings { [weak self] (settings) in
            guard let self = self else {
                return
            }

            switch settings.authorizationStatus {
            case .authorized:
                os_log("RecorderViewModel is scheduling a notification...", log: .appFlow, type: .debug)
                let content = UNMutableNotificationContent()
                content.title = NSLocalizedString("notification-title", comment: "")
                content.body = NSLocalizedString("notification-body", comment: "")
                content.sound = .default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                self.uncenter.add(request) { (error) in
                    if error != nil {
                        os_log("RecorderViewModel failed to schedule notification.", log: .appFlow, type: .error)
                    } else {
                        os_log("RecorderViewModel successfully scheduled a notification.", log: .appFlow, type: .debug)
                    }
                }
            case .denied:
                os_log("RecorderViewModel can`t schedule notification due to `denied` authorization status.", log: .appFlow, type: .debug)
            default:
                os_log("RecorderViewModel has unknown user notification status.", log: .appFlow, type: .debug)
            }
        }
    }

    // MARK: - FileManager
    /// Removes file representing a memory's audio.
    private func remove(file: String, at fileManager: FileManager = FileManager.default) {
        let url = fileManager.userDocumentDirectory
        let fileURL = url.appendingPathComponent("\(file).m4a")
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            os_log("RecorderViewModel failed to remove a memory's file.", log: .appFlow, type: .error)
        }
    }
}
