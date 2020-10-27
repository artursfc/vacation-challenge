//
//  TimeInterval+Extensions.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 27/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toBeDisplayedFormat() -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        dateFormatter.allowedUnits = [.minute, .second]
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: self) ?? "00:00"
    }
}
