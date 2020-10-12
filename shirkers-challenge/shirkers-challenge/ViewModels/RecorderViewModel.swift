//
//  RecorderViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

protocol RecorderViewModelDelegate: AnyObject {
    func didStartRecording()
    func didStopRecording()
    func didUpdateRemindMe()
}

final class RecorderViewModel {
    // MARK: - Properties
    private var recorder: Recorder

    private var remindMeInSeconds: Int = 0

    private var currentDate: Date? {
        didSet {
            if let previousDate = oldValue {
                remove(file: previousDate.stringFormatted())
            }
        }
    }

    weak var delegate: RecorderViewModelDelegate?

    // MARK: - Init
    init(recorder: Recorder) {
        self.recorder = recorder
        self.recorder.didFinishRecording = { [weak self] (successfully) in
            guard let self = self else { return }
            self.recording = false
        }

        NotificationCenter.default.addObserver(self,
                                       selector: #selector(remove(_:)),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)
    }

    // MARK: - API
    var permission: Bool {
        return recorder.permission
    }

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
                        // TODO: Error Handling
                    }
                }
            } else {
                do {
                    try recorder.stop()
                    delegate?.didStopRecording()
                } catch {
                    // TODO: Error handling
                }

            }
        }
    }

    var title: String = ""

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

    var remindMePeriod: Float = 0.0 {
        didSet {
            remindMeInSeconds = Int(remindMePeriod) * 24 * 60 * 60
            delegate?.didUpdateRemindMe()
        }
    }

    func requestPermission() {
        do {
            try recorder.requestPermission()
        } catch {
            // TODO: Error handling
        }
    }

    // MARK: - FileManager
    private func remove(file: String, at fileManager: FileManager = FileManager.default) {
        print("Deleting...")
        let url = fileManager.userDocumentDirectory
        let fileURL = url.appendingPathComponent("\(file).m4a")
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
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
