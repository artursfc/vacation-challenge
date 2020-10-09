//
//  RecordingButtonAnimation.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class RecordingButtonAnimation: CAAnimationGroup {

    var identifier: String {
        return String(describing: self)
    }

    private lazy var startAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        return animation
    }()

    private lazy var endAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        animation.beginTime = 0.5
        return animation
    }()

    override init() {
        super.init()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        animations = [startAnimation, endAnimation]
        isRemovedOnCompletion = false
        duration = 1
        repeatCount = .infinity
    }
}
