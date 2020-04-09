//
//  RecordingController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import AVFoundation
import os.log

public final class RecordingController: NSObject {
    private var recorder: AVAudioRecorder?
    private lazy var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var permission: AVAudioSession.RecordPermission {
        return audioSession.recordPermission
    }

    private enum State {
        case requiresSession
        case sessionActive
        case invalidSession
        case idle
        case recording
        case invalidRecorder
    }

    private var state: State {
        didSet {
            if state == .requiresSession {
                setupRecordingSession()
            }
        }
    }

    public override init() {
        self.state = .requiresSession
    }

    public func requestRecordPermission() {
        audioSession.requestRecordPermission { _ in }
    }

    private func setupRecordingSession() {
        //Not sure about which category mode to use.
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            state = .sessionActive
            os_log("AVAudioSession created and active", log: OSLog.recordingCycle, type: .info)
        } catch {
            os_log("AVAudioSession creation failed. Category: .record. Mode: .default", log: OSLog.recordingCycle, type: .error)
            state = .invalidSession
        }
    }

    public func setup(for filename: String) {
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
