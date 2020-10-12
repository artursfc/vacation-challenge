//
//  RecordingController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import AVFoundation
import os.log

/// Type used setup a recording session and to record audio. Preferably, it should not be
/// instantiated by a ViewController as the error responses were not made with that in mind.
final class RecordingController: NSObject, Recorder {
    /// The AVAudioRecorder used to record. Optional as the initializer for the class requires
    ///  a filename that does not exist at RecordingController initialization.
    private var recorder: AVAudioRecorder?
    /// AVAudioSession Singleton access.
    private let audioSession: AVAudioSession
    /// A variable used to determine whether or not recording is permitted at any given time.
    /// Should be kept as a computed property to get correct permission condition at call time.
    var permission: Bool {
        switch audioSession.recordPermission {
        case .denied, .undetermined:
            return false
        case .granted:
            return true
        default:
            return false
        }
    }

    /// Enum used to describe all possible states of an instance. Recording should only be possible at idle.
    private enum State {
        case requiresPermission
        case sessionActive
        case idle
        case recording
    }

    /// The instance state. Remember to always check the state before an action and set the correct state after
    /// an action. After a recording is done the state should be set to idle.
    private var state: State = .requiresPermission

    var didFinishRecording: ((Bool) -> Void)?

    /// Initialize a new instance of this type.
    init(session: AVAudioSession = AVAudioSession.sharedInstance()) {
        self.audioSession = session
        super.init()
        self.setUpRecordingSession()
    }

    /// Requests user permission to record. No need to treat the
    /// closure's response as the instance state will determine whether
    /// recording is possible.
    func requestPermission() throws {
        var permission = false
        audioSession.requestRecordPermission { (response) in
            permission = response
        }
        if permission == false {
            throw RecordingControllerError.permissionDenied
        }
    }

    private func setUpRecordingSession() {
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            state = .sessionActive
            os_log("AVAudioSession created and active", log: OSLog.recordingCycle, type: .debug)
        } catch {
            os_log("AVAudioSession creation failed. Category: .record. Mode: .default",
                   log: OSLog.recordingCycle,
                   type: .error)
        }
    }

    func setUp(for filename: String) throws {
        let session = RecordingSessionSettings(filename: filename)
        let url = session.filepath
        let settings = session.settings

        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            if let recorder = recorder {
                recorder.delegate = self
                recorder.prepareToRecord()
                state = .idle
            }
            os_log("AVAudioRecorder created. Set to prepareToRecord().", log: OSLog.recordingCycle, type: .debug)
        } catch {
            os_log("AVAudioRecorder creation failed.", log: OSLog.recordingCycle, type: .error)
            throw RecordingControllerError.setupRequired
        }
    }

    func start() throws {
        if state == .idle {
            if let recorder = recorder {
                recorder.record()
                state = .recording
            }
        } else {
            switch state {
            case .requiresPermission:
                throw RecordingControllerError.permissionDenied
            case .sessionActive:
                throw RecordingControllerError.setupRequired
            case .recording:
                throw RecordingControllerError.stillRecording
            case .idle:
                break
            }
        }
    }

    func stop() throws {
        if state == .recording {
            if let recorder = recorder {
                recorder.stop()
                state = .idle
            }
        } else {
            switch state {
            case .requiresPermission:
                throw RecordingControllerError.permissionDenied
            case .sessionActive:
                throw RecordingControllerError.setupRequired
            case .idle:
                throw RecordingControllerError.notRecording
            case .recording:
                break
            }
        }
    }
}

extension RecordingController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        didFinishRecording?(flag)
    }
}
