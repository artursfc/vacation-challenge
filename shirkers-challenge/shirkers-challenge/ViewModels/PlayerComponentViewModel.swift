//
//  PlayerComponentViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import AVFoundation

// MARK: - Protocol-Delegate
protocol PlayerComponentViewModelDelegate: AnyObject {
    func update()
}

final class PlayerComponentViewModel: NSObject {
    // MARK: - Properties
    weak var delegate: PlayerComponentViewModelDelegate?

    private var player: AVAudioPlayer?

    private var timestampTimer: Timer?

    private var internalCurrentTime: TimeInterval = 0.0

    private var memory: MemoryViewModel?

    // MARK: - Init
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shouldPlay(_:)),
                                               name: Notification.Name("play"),
                                               object: nil)
    }

    // MARK: - @objc
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

    var duration: Float {
        return Float(player?.duration ?? 1.0)
    }

    var title: String {
        return memory?.title ?? ""
    }

    var createdAt: String {
        return memory?.createdAt.toBeDisplayedFormat() ?? ""
    }

    var currentTimestamp: String {
        return internalCurrentTime.toBeDisplayedFormat()
    }

    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    var currentPos: Float {
        return Float(internalCurrentTime * 100) / duration
    }

    func play() {
        guard let player = player else {
            /// TODO: Error Handling
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

    func stop() {
        guard let player = player else {
            /// TODO: Error Handling
            return
        }

        timestampTimer?.invalidate()
        timestampTimer = nil
        internalCurrentTime = 0.0

        player.stop()
        delegate?.update()
    }

    func seekTo(_ pos: Float) {
        guard let player = player else {
            /// TODO: Error Handling
            return
        }

        player.currentTime = TimeInterval(pos)
    }

    // MARK: - Player setup
    private func setUp(for memory: MemoryViewModel) {
        self.memory = memory

        let fileURL = FileManager.userDocumentDirectory.appendingPathComponent(memory.createdAt.toBeSavedFormat()).appendingPathExtension(".m4a")

        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.prepareToPlay()
            player?.delegate = self
        } catch {
            /// TODO: Error Handling
            print(error.localizedDescription)
        }
    }

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PlayerComponentViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timestampTimer?.invalidate()
        timestampTimer = nil
        internalCurrentTime = 0.0
        delegate?.update()
    }
}
