//
//  shirkers_challengeTests.swift
//  shirkers-challengeTests
//
//  Created by Artur Carneiro on 08/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import XCTest
import AVFoundation
@testable import shirkers_challenge

class RecordingSessionTests: XCTestCase {

    //Property wrappers can't be declared in local scope.
    @RecordingSettings var pwSettings: [String : Any]

    func testRecordingSettings() {
        let settings: [String : Any] = [AVFormatIDKey: kAudioFormatAppleLossless,
                        AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                        AVEncoderBitRateKey: 32000 ,
                        AVNumberOfChannelsKey: 2,
                        AVSampleRateKey: 44100.2]

        for key in settings.keys {
            if let lhs = settings[key] as? String, let rhs = pwSettings[key] as? String {
                XCTAssert(lhs == rhs)
            }
        }
    }

    func testRecordingSession() {
        let fileName = "FILENAME"
        let fileExtension = ".mp3"
        let session = RecordingSession(on: fileName)
        let filePath = FileManager.userDocumentDirectory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)

        XCTAssert(session.filePath == filePath)

        for key in session.settings.keys {
            if let lhs = session.settings[key] as? String, let rhs = pwSettings[key] as? String {
                XCTAssert(lhs == rhs)
            }
        }
    }

}
