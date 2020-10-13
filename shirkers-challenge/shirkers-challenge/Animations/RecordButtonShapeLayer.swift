//
//  RecordingButtonShapeLayer.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Responsible for describing how to draw the desired shape for the
/// animation.
final class RecordButtonShapeLayer: CAShapeLayer {

    /// The button's frame used in drawing the animated shape.
    private let buttonFrame: CGRect

    /// The shape drawn based on `buttonFrame`.
    private lazy var buttonPath: UIBezierPath = {
        let path = UIBezierPath()
        let center = CGPoint(x: buttonFrame.midX, y: buttonFrame.midY)
        let radius = (buttonFrame.height * 0.8)/2
        path.addArc(withCenter: center,
                    radius: radius,
                    startAngle: (.pi*3)/2,
                    endAngle: (.pi*3)/2 * 0.99,
                    clockwise: true)

        return path
    }()

    /// Initializes a new instance of this type.
    /// - Parameter buttonFrame: The button's frame used in drawing the animated shape.
    init(buttonFrame frame: CGRect) {
        self.buttonFrame = frame
        super.init()
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        path = buttonPath.cgPath
        lineWidth = 4
        lineCap = .round
        fillColor = .none
        strokeColor = UIColor.memoraAccent.cgColor
    }
}
