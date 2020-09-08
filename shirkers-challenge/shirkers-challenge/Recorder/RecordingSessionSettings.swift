//
//  RecordingSessionSettings.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import AVFoundation

/// A structure containing the necessary information to initialize a recording session.
/// Should be used by the RecordingController to setup itself.
struct RecordingSessionSettings {
    /// The URL of the directory used to save the recording. Defaults to the user's document directory.
    private let directory: URL
    /// The filename of the recording.
    private let filename: String
    /// The session's settings used by the RecordingController in the setup process.
    /// Should always be declared with the RecordingSettings property wrapper.
    @RecordingSettings var settings: [String: Any]
    /// The recording file URL used by the RecordingController in the setup process.
    let filepath: URL

    /// Initialize a new instance of this type:
    /// - parameter filename: The filename of the recording.
    /// - parameter directory: The URL of the directory used to save the recording.
    /// Defaults to the user's document directory.
    init(filename: String, directory: URL = FileManager.userDocumentDirectory) {
        self.filename = filename
        self.directory = directory
        self.filepath = directory.appendingPathComponent(filename).appendingPathExtension(".m4a")
    }
}

extension RecordingSessionSettings {
    /// Property wrapper used to build a default recording settings.
    @propertyWrapper struct RecordingSettings {
        /// The enconder bitrate. Defaults to 48000. See Apple's documentation for more information.
        private let enconderBitRate: Int
        /// The number of channels being used. Defaults to 2. See Apple's documentation for more information.
        private let numberOfChannels: Int
        /// The sample rate being used. Defaults to 44100. See Apple's documentation for more information.
        private let sampleRate: Double
        /// The number of channels being used. Defaults to max. See Apple's documentation for more information.
        private let audioQuality: Int
        /// The number of channels being used. Defaults to .m4a format (MPEG4ACC).
        /// See Apple's documentation for more information.
        private let format: Int

        /// Read-only wrapped value. Builds the necessary structure used by AVAudioRecorder.
        var wrappedValue: [String: Any] {
            return [AVFormatIDKey: format,
                    AVEncoderAudioQualityKey: audioQuality,
                    AVEncoderBitRateKey: enconderBitRate,
                    AVNumberOfChannelsKey: numberOfChannels,
                    AVSampleRateKey: sampleRate]
        }

        /// Initialize a new instance of this type.
        init() {
            self.enconderBitRate = 48000
            self.numberOfChannels = 2
            self.sampleRate = 44100
            self.audioQuality = AVAudioQuality.max.rawValue
            self.format = Int(kAudioFormatMPEG4AAC)
        }
    }
}
