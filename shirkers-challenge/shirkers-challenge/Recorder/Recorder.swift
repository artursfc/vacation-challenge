//
//  RecordingControllerProtocol.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 06/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

/// The protocol determining the interface of a `RecordingController`.
protocol Recorder {
    var permission: Bool { get }
    var didFinishRecording: ((_ successfully: Bool) -> Void)? { get set }
    func requestPermission() throws
    func setUp(for filename: String) throws
    func start() throws
    func stop() throws
}
