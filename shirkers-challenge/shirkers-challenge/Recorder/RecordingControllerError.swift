//
//  RecordingControllerError.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

public enum RecordingControllerError: Error {
    case setupRequired
    case stillRecording
    case notRecording
}

extension RecordingControllerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .setupRequired:
            return NSLocalizedString("Setup required to record.", comment: "")
        case .stillRecording:
            return NSLocalizedString("Cannot start a recording while one is still running.", comment: "")
        case .notRecording:
            return NSLocalizedString("Currently not recording.", comment: "")
        }
    }
}
