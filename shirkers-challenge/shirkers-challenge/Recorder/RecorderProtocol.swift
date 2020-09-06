//
//  RecorderProtocol.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 06/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

public protocol RecordingControllerProtocol {
    public func setup() -> RecordingControllerError
}
