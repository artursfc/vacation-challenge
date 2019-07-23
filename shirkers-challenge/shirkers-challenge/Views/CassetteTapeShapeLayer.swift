//
//  CassetteTapeShapeLayer.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 16/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class CassetteTapeShapeLayer: CAShapeLayer {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func overlayedOutlinePath(view: UIView) {
        let overlayedOutlinePath = UIBezierPath()
        overlayedOutlinePath.move(to: CGPoint(x: Dimensions.leftSpoolCenter.x, y: Dimensions.leftSpoolCenter.y + Dimensions.spoolHeight/2))
        overlayedOutlinePath.addLine(to: CGPoint(x: Dimensions.leftSpoolCenter.x, y: Dimensions.cassetteTapeHeight))
        overlayedOutlinePath.addLine(to: CGPoint(x: view.frame.width * 0.25, y: Dimensions.cassetteTapeHeight))
        overlayedOutlinePath.addLine(to: CGPoint(x: view.frame.width * 0.35, y: Dimensions.cassetteTapeHeight * 0.8 ))
        overlayedOutlinePath.addLine(to: CGPoint(x: view.frame.width * 0.65, y: Dimensions.cassetteTapeHeight * 0.8))
        overlayedOutlinePath.addLine(to: CGPoint(x: view.frame.width * 0.75, y: Dimensions.cassetteTapeHeight))
        overlayedOutlinePath.addLine(to: CGPoint(x: view.frame.width, y: Dimensions.cassetteTapeHeight))
        overlayedOutlinePath.addLine(to: CGPoint(x: view.frame.width, y: 0))
        overlayedOutlinePath.addLine(to: CGPoint(x: 0, y: 0))
        overlayedOutlinePath.addLine(to: CGPoint(x: 0, y: Dimensions.cassetteTapeHeight))
        overlayedOutlinePath.addLine(to: CGPoint(x: (Dimensions.leftSpoolCenter.x - 10), y: Dimensions.cassetteTapeHeight))
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = ColorPalette.lightGrey.cgColor
        self.lineWidth = 7
        self.lineJoin = .round
        self.lineCap = .round
        self.path = overlayedOutlinePath.cgPath
    }

}
