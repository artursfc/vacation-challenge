//
//  OSLog+Extensions.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/04/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem: String = Bundle.main.bundleIdentifier!

    static let recordingCycle: OSLog = OSLog(subsystem: subsystem, category: "recordingCycle")
}
