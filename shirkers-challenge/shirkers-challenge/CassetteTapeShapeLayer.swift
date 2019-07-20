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
    
    public func updatePath(from: CGPoint, to: CGPoint) {
        let path = UIBezierPath(arcCenter: to, radius: 75, startAngle: 0, endAngle: .pi * 2, clockwise: true)
//        path.move(to: from)
//        path.addLine(to: to)
        self.strokeEnd = 0
        self.strokeColor = UIColor.clear.cgColor
        self.fillColor = UIColor.clear.cgColor
        self.path = path.cgPath
    }

}
