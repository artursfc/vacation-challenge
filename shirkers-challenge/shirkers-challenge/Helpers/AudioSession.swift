//
//  AudioSession.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import AVFoundation

extension FileManager {
    static var userDocumentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}



public final class AudioSession: NSObject {
    
    static let shared = AudioSession()
    
    private var audioRecorder : AVAudioRecorder?
    private var audioPlayer : AVAudioPlayer?
    private var isMicAccessGranted : Bool = false
    private var fileName : String?
    private var clearName: String?
    
    private var duration : TimeInterval?
    
    public func clear() {
        if let fileName = clearName {
            deleteAudioFile(name: fileName)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    public func setFile(name: String) {
        self.fileName = name + ".m4a"
        self.clearName = name
    }
    
    public func clearFileNames() {
        self.clearName = nil
        self.fileName = nil
    }
    
    public func deleteAudioFile(name: String) {
        let audio = name + ".m4a"
        let documentsPath : URL = getDocumentsDirectory()
        let audioPath = documentsPath.appendingPathComponent(audio)
        do {
            try FileManager.default.removeItem(at: audioPath)
        } catch {
            print(error)
        }
    }
    
    public func setupRecorder() {
        guard let fileName = fileName else { return }
        let audioFileName = getDocumentsDirectory().appendingPathComponent(fileName)
        let recordSettings = AudioSettings.recordSettings
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.record)
            try session.setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: recordSettings)
            guard let audioRecorder = audioRecorder else { return }
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    public func setupPlayer() {
        guard let fileName = fileName else { return }
        let audioFileName = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            guard let audioPlayer = audioPlayer else { return }
            duration = audioPlayer.duration
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
        } catch {
            print(error)
        }
    }
    
    public func checkMicrophonePermission() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            isMicAccessGranted = true
            break
        case .denied:
            isMicAccessGranted = false
            break
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
                if allowed {
                    self.isMicAccessGranted = true
                } else {
                    self.isMicAccessGranted = false
                }
            }
        default:
            break
        }
        return isMicAccessGranted
    }
    
    public func record() {
        guard let audioRecorder = audioRecorder else { return }
        audioRecorder.record(forDuration: AudioSettings.duration)
    }
    
    public func stopRecording() {
        guard let audioRecorder = audioRecorder  else { return  }
        audioRecorder.stop()
    }
    
    public func play() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
    }
    
    public func stopPlaying() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
    
    public func getDuration() -> TimeInterval? {
        guard let duration = duration else { return nil }
        return duration
        
    }
}

extension AudioSession : AVAudioRecorderDelegate {
//    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        <#code#>
//    }
}

extension AudioSession: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let name = Notification.Name("didFinishPlaying")
        let notification: Notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
