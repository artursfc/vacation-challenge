//
//  PlayerComponentViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import AVFoundation
import os.log

// MARK: - Protocol-Delegate
/// The delegate responsible for allowing communication between
/// `PlayerComponentViewModel` and its `View`.
protocol PlayerComponentViewModelDelegate: AnyObject {
    func update()
}

/// Responsible for providing the `View` with all the necessary
/// funcionalities and data for audio playback.
final class PlayerComponentViewModel: NSObject {
    // MARK: - Properties
    /// The delegate responsible for allowing communication between
    /// `PlayerComponentViewModel` and its `View`.
    weak var delegate: PlayerComponentViewModelDelegate?

    /// The player used to audio playback.
    private var player: AVAudioPlayer?

    /// The timer responsible for keeping track of time elapsed.
    private var timestampTimer: Timer?

    /// The curent time in sync with `timestampTimer`.
    private var internalCurrentTime: TimeInterval = 0.0

    /// The memory currently being played.
    private var memory: MemoryViewModel?

    // MARK: - Init
    /// Initializes a new instance of this type.
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shouldPlay(_:)),
                                               name: Notification.Name("play"),
                                               object: nil)
        os_log("PlayerComponentViewModel initialized.", log: .appFlow, type: .debug)
    }

    // MARK: - @objc
    /// Plays memory chosen by the user, whether it be in `Inbox` or `Archive` screen.
    @objc private func shouldPlay(_ notification: NSNotification) {
        guard let memory = notification.userInfo?["play"] as? MemoryViewModel else {
            return
        }

        setUp(for: memory)

        self.memory = memory

        if timestampTimer != nil {
            timestampTimer?.invalidate()
            timestampTimer = nil
            internalCurrentTime = 0.0
        }
        
        play()
    }

    // MARK: - API

    /// The memory's duration.
    var duration: Float {
        return Float(player?.duration ?? 1.0)
    }

    /// The memory's title.
    var title: String {
        return memory?.title ?? ""
    }

    /// The memory's date of creation.
    var createdAt: String {
        return memory?.createdAt.toBeDisplayedFormat() ?? ""
    }

    /// The memory's timestamp.
    var currentTimestamp: String {
        return internalCurrentTime.toBeDisplayedFormat()
    }

    /// Whether a memory is being played.
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    /// The current position in the memory. From 0.0 to 100.0.
    var currentPos: Float {
        return Float(internalCurrentTime * 100) / duration
    }

    /// Plays the memory loaded in the player.
    func play() {
        guard let player = player else {
            os_log("PlayerComponentViewModel tried playing without a player.", log: .appFlow, type: .error)
            return
        }
        if timestampTimer != nil {
            timestampTimer?.invalidate()
            internalCurrentTime = 0.0
            timestampTimer = nil
            delegate?.update()
        } else {
            timestampTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] (_) in
                guard let self = self else {
                    return
                }

                self.internalCurrentTime += 0.01
                self.delegate?.update()
            })
            player.play()
            delegate?.update()
        }

    }

    /// Stops playback of the memory loaded in the player.
    func stop() {
        guard let player = player else {
            os_log("PlayerComponentViewModel tried to stop playback without a player.", log: .appFlow, type: .error)
            return
        }

        timestampTimer?.invalidate()
        timestampTimer = nil
        internalCurrentTime = 0.0

        player.stop()
        delegate?.update()
    }

    /// Seeks to chosen position in the memory. Only works if a
    /// memory is being played.
    func seekTo(_ pos: Float) {
        guard let player = player else {
            os_log("PlayerComponentViewModel tried to seek without a player.", log: .appFlow, type: .error)
            return
        }
        
        internalCurrentTime = TimeInterval((pos*duration)/100)
        player.currentTime = TimeInterval((pos*duration)/100)
    }

    // MARK: - Player setup
    /// Sets up the player for playback of given memory.
    private func setUp(for memory: MemoryViewModel) {
        self.memory = memory

        let filename = FileManager.userDocumentDirectory.appendingPathComponent(memory.createdAt.toBeSavedFormat())
        let fileURL = filename.appendingPathExtension("m4a")

        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.prepareToPlay()
            player?.delegate = self
        } catch {
            os_log("PlayerComponentViewModel failed to set up player.", log: .appFlow, type: .error)
        }
    }

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - AVAudioPlayerDelegate
extension PlayerComponentViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timestampTimer?.invalidate()
        timestampTimer = nil
        internalCurrentTime = 0.0
        delegate?.update()
    }
}
