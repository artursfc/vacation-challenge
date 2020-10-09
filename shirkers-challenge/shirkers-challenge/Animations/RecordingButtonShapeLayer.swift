//
//  RecordingButtonShapeLayer.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 09/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class RecordingButtonShapeLayer: CAShapeLayer {

    private let buttonFrame: CGRect

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
        strokeColor = UIColor.memoraLightGray.cgColor
    }
}
