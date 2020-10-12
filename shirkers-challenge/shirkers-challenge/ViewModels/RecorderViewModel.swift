//
//  RecorderViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// The  delegate responsible for allowing communication between
/// `RecorderViewModel` and its `View`.
protocol RecorderViewModelDelegate: AnyObject {
    func didStartRecording()
    func didStopRecording()
    func didUpdateRemindMe()
}

/// Responsible for providing the `View` with all the necessary
/// funcionalities and data for performing a recording.
final class RecorderViewModel {
    // MARK: - Properties
    /// The recorder abstraction.
    private var recorder: Recorder

    /// The period to remind the user in seconds. It should be
    /// used to perform comparision between periods.
    private var remindMeInSeconds: Int = 0

    /// The current date which is used as the recording filename.
    /// It resets everytime a new recording is started. With every new
    /// recording, the previous recording file should be deleted using the `oldValue`
    /// inside the `didSet`.
    private var currentDate: Date? {
        didSet {
            if let previousDate = oldValue {
                remove(file: previousDate.stringFormatted())
            }
        }
    }

    /// The  delegate responsible for allowing communication between
    /// `RecorderViewModel` and its `View`.
    weak var delegate: RecorderViewModelDelegate?

    // MARK: - Init
    /// Initializes a new instance of this type.
    /// - Parameter recorder: The recorder abstraction.
    init(recorder: Recorder) {
        self.recorder = recorder
        self.recorder.didFinishRecording = { [weak self] (successfully) in
            guard let self = self else { return }
            self.recording = false
        }

        // Sets a observer in case the user closes the app before it deletes
        // the previous recording.
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(remove(_:)),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)
    }

    // MARK: - API
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
                if let fileName = currentDate?.stringFormatted() {
                    do {
                        try recorder.setUp(for: fileName)
                        try recorder.start()
                        delegate?.didStartRecording()
                    } catch {
                        print(error.localizedDescription)
                        // TODO: Error Handling
                    }
                }
            } else {
                do {
                    try recorder.stop()
                    delegate?.didStopRecording()
                } catch {
                    print(error.localizedDescription)
                    // TODO: Error handling
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
            let localizedDays = NSLocalizedString("days", comment: "Plural reminder period")
            return "\(localizedRemindMe) \(Int(remindMePeriod)) \(localizedDays)"
        } else {
            let localizedDay = NSLocalizedString("day", comment: "Singular reminder period")
            return "\(localizedRemindMe) \(Int(remindMePeriod)) \(localizedDay)"
        }
    }

    /// The memory's notification period.
    var remindMePeriod: Float = 0.0 {
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
            print(error.localizedDescription)
            // TODO: Error handling
        }
    }

    // MARK: - FileManager
    private func remove(file: String, at fileManager: FileManager = FileManager.default) {
        let url = fileManager.userDocumentDirectory
        let fileURL = url.appendingPathComponent("\(file).m4a")
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            print(error.localizedDescription)
            // TODO: Error handling
        }
    }

    @objc private func remove(_ notification: Notification) {
        guard let fileName = currentDate?.stringFormatted() else {
            return
        }
        remove(file: fileName)
    }
    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
