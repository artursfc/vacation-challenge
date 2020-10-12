//
//  RecorderViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol RecorderViewModelDelegate: AnyObject {
    func didStartRecording()
    func didStopRecording()
    func didUpdateRemindMe()
}

final class RecorderViewModel {
    // MARK: - Properties
    private var recorder: Recorder

    private var remindMeInSeconds: Int = 0

    weak var delegate: RecorderViewModelDelegate?

    // MARK: - Init
    init(recorder: Recorder) {
        self.recorder = recorder
        self.recorder.didFinishRecording = { [weak self] (successfully) in
            guard let self = self else { return }
            self.recording = false
        }
    }

    // MARK: - API
    var permission: Bool {
        return recorder.permission
    }

    var recording: Bool = false {
        didSet {
            if recording {
                delegate?.didStartRecording()
            } else {
                delegate?.didStopRecording()
            }
        }
    }

    var title: String = ""

    var remindMeIn: String {
        let localizedRemindMe = NSLocalizedString("remind-me-in", comment: "The reminder deadline")
        if remindMeInSeconds > (60*60*24) {
            let localizedDays = NSLocalizedString("days", comment: "Plural reminder period")
            return "\(localizedRemindMe) \(Int(remindMeInPeriod)) \(localizedDays)"
        } else {
            let localizedDay = NSLocalizedString("day", comment: "Singular reminder period")
            return "\(localizedRemindMe) \(Int(remindMeInPeriod)) \(localizedDay)"
        }
    }

    var remindMeInPeriod: Float = 0.0 {
        didSet {
            remindMeInSeconds = Int(remindMeInPeriod) * 24 * 60 * 60
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
}
