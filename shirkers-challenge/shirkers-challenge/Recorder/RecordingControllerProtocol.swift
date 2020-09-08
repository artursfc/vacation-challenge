//
//  RecordingControllerProtocol.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 06/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

/// The protocol determining the public interface of a `RecordingController`.
public protocol RecordingControllerProtocol {
    func requestRecordPermission() throws
    func setup(for filename: String) throws
    func start() throws
    func stop() throws
}
