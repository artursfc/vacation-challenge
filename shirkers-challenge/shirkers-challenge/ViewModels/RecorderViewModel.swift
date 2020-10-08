//
//  RecorderViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 08/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol RecorderViewModelDelegate: AnyObject {
    func didStartRecording()
    func didStopRecording()
}

final class RecorderViewModel {

    weak var delegate: RecorderViewModelDelegate?

    init() {

    }

    var recording: Bool = false {
        didSet {
            if recording {
                delegate?.didStartRecording()
            } else {
                delegate?.didStopRecording()
            }
        }
    }
}
