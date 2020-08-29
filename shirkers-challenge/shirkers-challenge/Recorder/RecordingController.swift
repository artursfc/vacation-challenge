//
//  RecordingController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import AVFoundation
import os.log

/// Class used setup a recording session and to record audio. Preferably, it should not be
/// instantiated by a ViewController as the error responses were not made with that in mind.
public final class RecordingController: NSObject {
    /// The AVAudioRecorder used to record. Optional as the initializer for the class requires
    ///  a filename that does not exist at RecordingController initialization.
    private var recorder: AVAudioRecorder?
    /// AVAudioSession Singleton access.
    private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    /// A variable used to determine whether or not recording is permitted at any given time.
    /// Should be kept as a computed property to get correct permission condition at call time.
    private var permission: AVAudioSession.RecordPermission {
        return audioSession.recordPermission
    }

    /// Enum used to describe all possible states of an instance. Recording should only be possible at idle.
    private enum State {
        case requiresPermission
        case requiresSession
        case sessionActive
        case invalidSession
        case idle
        case recording
        case invalidRecorder
    }

    /// The instance state. Remember to always check the state before an action and set the correct state after
    /// an action. After a recording is done the state should be set to idle.
    private var state: State = .idle

    /// Initialize a new instance of this type.
    public override init() {
    }

    /// Requests user permission to record. No need to treat the
    /// closure's response as the instance state will determine whether
    /// recording is possible.
    public func requestRecordPermission() throws {
        var permission = false
        audioSession.requestRecordPermission { (response) in
            permission = response
        }
        if permission == false {
            throw RecordingControllerError.permissionDenied
        }
    }

    private func setupRecordingSession() {
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            state = .sessionActive
            os_log("AVAudioSession created and active", log: OSLog.recordingCycle, type: .info)
        } catch {
            os_log("AVAudioSession creation failed. Category: .record. Mode: .default",
                   log: OSLog.recordingCycle,
                   type: .error)
            state = .invalidSession
        }
    }

    public func setup(for filename: String) throws {
        let session = RecordingSession(filename: filename)
        let url = session.filepath
        let settings = session.settings

        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            if let recorder = recorder {
                recorder.delegate = self
                recorder.prepareToRecord()
                state = .idle
            }
            os_log("AVAudioRecorder created. Set to prepareToRecord().", log: OSLog.recordingCycle, type: .info)
        } catch {
            os_log("AVAudioRecorder creation failed.", log: OSLog.recordingCycle, type: .error)
            state = .invalidRecorder
            throw RecordingControllerError.setupRequired
        }
    }

    public func record() throws {
        if state == .idle {
            if let recorder = recorder {
                recorder.record()
                state = .recording
            }
        } else {
            switch state {
            case .requiresPermission:
                throw RecordingControllerError.permissionDenied
            case .sessionActive, .invalidSession, .requiresSession, .invalidRecorder:
                throw RecordingControllerError.setupRequired
            case .recording:
                throw RecordingControllerError.stillRecording
            case .idle:
                break
            }
        }
    }

    public func stop() throws {
        if state == .recording {
            if let recorder = recorder {
                recorder.stop()
                state = .idle
            }
        } else {
            switch state {
            case .requiresPermission:
                throw RecordingControllerError.permissionDenied
            case .sessionActive, .invalidSession, .requiresSession, .invalidRecorder:
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

}
