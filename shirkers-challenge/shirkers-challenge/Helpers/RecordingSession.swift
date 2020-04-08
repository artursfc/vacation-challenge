//
//  RecordingSession.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import AVFoundation

public struct RecordingSession {
    private let directory: URL
    private let fileName: String
    private let fileExtension: String

    public let filePath: URL

    @RecordingSettings public var settings: [String : Any]

    init(on fileName: String, as fileExtension: String = ".mp3",in directory: URL = FileManager.userDocumentDirectory) {
        self.fileName = fileName
        self.directory = directory
        self.fileExtension = fileExtension
        self.filePath = directory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }
}

@propertyWrapper public struct RecordingSettings {
    private let enconderBitRate: Int
    private let numberOfChannels: Int
    private let sampleRate: Double
    private let audioQuality: Int
    private let format: AudioFormatID

    public enum RecordingSettingsMode {

    }

    public var wrappedValue: [String : Any] {
        return [AVFormatIDKey: format,
                AVEncoderAudioQualityKey: audioQuality,
                AVEncoderBitRateKey: enconderBitRate,
                AVNumberOfChannelsKey: numberOfChannels,
                AVSampleRateKey: sampleRate]
    }

    public init(_ mode: RecordingSettingsMode? = nil) {
        switch mode {
        default:
            self.enconderBitRate = 32000
            self.numberOfChannels = 2
            self.sampleRate = 44100.2
            self.audioQuality = AVAudioQuality.max.rawValue
            self.format = kAudioFormatAppleLossless
        }
    }
}
