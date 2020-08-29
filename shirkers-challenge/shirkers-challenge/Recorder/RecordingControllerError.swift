//
//  RecordingControllerError.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

public enum RecordingControllerError: Error {
    case permissionDenied
    case setupRequired
    case stillRecording
    case notRecording
    case setupFailed
}

extension RecordingControllerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return NSLocalizedString("User has not given permission to record.", comment: "")
        case .setupRequired:
            return NSLocalizedString("Setup required to record.", comment: "")
        case .stillRecording:
            return NSLocalizedString("Cannot start a recording while one is still running.", comment: "")
        case .notRecording:
            return NSLocalizedString("Currently not recording.", comment: "")
        case .setupFailed:
            return NSLocalizedString("Recording setup failed", comment: "")
        }
    }
}
