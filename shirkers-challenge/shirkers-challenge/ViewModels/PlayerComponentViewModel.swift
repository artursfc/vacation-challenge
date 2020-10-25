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
    func didStopPlaying()
}

final class PlayerComponentViewModel {
    // MARK: - Properties
    weak var delegate: PlayerComponentViewModelDelegate?

    private var player: AVAudioPlayer?

    private var memory: MemoryViewModel?

    // MARK: - Init
    init() {

    }

    // MARK: - API

    var duration: Float {
        return Float(player?.duration ?? 0.0)
    }

    var title: String {
        return memory?.title ?? ""
    }

    var createdAt: String {
        return memory?.createdAt ?? ""
    }

    func setUp(for memory: MemoryViewModel) {
        self.memory = memory

        guard let audioFile = Bundle.main.path(forResource: memory.createdAt, ofType: "m4a") else {
            /// TODO: Error Handling
            return
        }

        let fileURL = URL(fileURLWithPath: audioFile)

        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }

    func play() {
        guard let player = player else {
            /// TODO: Error Handling
            return
        }

        player.play()
    }

    func stop() {
        guard let player = player else {
            /// TODO: Error Handling
            return
        }

        player.stop()
    }

    func seekTo(_ pos: Float) {
        guard let player = player else {
            /// TODO: Error Handling
            return
        }

        player.currentTime = TimeInterval(pos)
    }
}
