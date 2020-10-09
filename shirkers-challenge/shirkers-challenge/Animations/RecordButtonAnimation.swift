//
//  RecordingButtonAnimation.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Responsible for performing the animation.
final class RecordButtonAnimation: CAAnimationGroup {

    /// The animation identifier used when adding it to a `CAShapeLayer`.
    var identifier: String {
        return String(describing: self)
    }

    /// The start animation. Its `duration` should be the same as `endAnimation`.
    private lazy var startAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        return animation
    }()

    /// The end animation. Its `duration` should be the same as `startAnimation`
    /// and have a `beginTime` equal to `duration`.
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
