//
//  MainView.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class CassetteTapeView: UIView {
    
    private var leftSpool : UIView?
    private var leftInnerCircle : UIBezierPath?
    private var rightSpool : UIView?
    private var rightInnerCircle : UIBezierPath?
    private var leftSpoolView: SpoolView?
    private var rightSpoolView : SpoolView?
    
    private var leftSpoolCenter : CGPoint = CGPoint()
    private var rightSpoolCenter : CGPoint = CGPoint()
    
    private var outlinePath : UIBezierPath?
    private var tapeChinPath : UIBezierPath?

    override func draw(_ rect: CGRect) {
        
        leftSpool = UIView()
        guard let leftSpool = leftSpool else { return }
        
        rightSpool = UIView()
        guard let rightSpool = rightSpool else { return }
        
        outlinePath = UIBezierPath()
        guard let outlinePath = outlinePath else { return }
        
        outlinePath.move(to: CGPoint(x: self.center.x - 100, y: self.center.y - 100))
        outlinePath.addLine(to: CGPoint(x: self.center.x - 100, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: self.frame.width, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: self.frame.width, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: 0, y: Dimensions.cassetteTapeHeight))
        
        let outlineShapeLayer = CAShapeLayer()
        outlineShapeLayer.path = outlinePath.cgPath
        
        outlineShapeLayer.fillColor = UIColor.clear.cgColor
        outlineShapeLayer.strokeColor = ColorPalette.lightGrey.cgColor
        outlineShapeLayer.lineWidth = 7
        outlineShapeLayer.lineJoin = .round
        outlineShapeLayer.lineCap = .round
        
        tapeChinPath = UIBezierPath()
        guard let tapeChinPath = tapeChinPath else { return }
        
        tapeChinPath.move(to: CGPoint(x: self.frame.width * 0.25, y: Dimensions.cassetteTapeHeight))
        tapeChinPath.addLine(to: CGPoint(x: self.frame.width * 0.35, y: Dimensions.cassetteTapeHeight * 0.8))
        tapeChinPath.addLine(to: CGPoint(x: self.frame.width * 0.65, y: Dimensions.cassetteTapeHeight * 0.8))
        tapeChinPath.addLine(to: CGPoint(x: self.frame.width * 0.75, y: Dimensions.cassetteTapeHeight))
        
        let tapeChinPathLayer = CAShapeLayer()
        tapeChinPathLayer.path = tapeChinPath.cgPath
        
        tapeChinPathLayer.fillColor = UIColor.clear.cgColor
        tapeChinPathLayer.strokeColor = ColorPalette.lightGrey.cgColor
        tapeChinPathLayer.lineWidth = 7
        tapeChinPathLayer.lineJoin = .round
        tapeChinPathLayer.lineCap = .round
        
        self.layer.addSublayer(tapeChinPathLayer)
        self.layer.addSublayer(outlineShapeLayer)
  
        self.addSubview(leftSpool)
        self.addSubview(rightSpool)
        
        leftSpool.translatesAutoresizingMaskIntoConstraints = false
        leftSpool.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -100).isActive = true
        leftSpool.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftSpool.widthAnchor.constraint(equalToConstant: Dimensions.spoolWidth).isActive = true
        leftSpool.heightAnchor.constraint(equalToConstant: Dimensions.spoolHeight).isActive = true
        
        leftSpool.layer.cornerRadius = Dimensions.spoolHeight / 2
        leftSpool.backgroundColor = ColorPalette.lightGrey
        leftSpool.alpha = 1
        leftSpool.clipsToBounds = true
        
        leftSpoolCenter = leftSpool.center
        
        rightSpool.translatesAutoresizingMaskIntoConstraints = false
        rightSpool.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 100).isActive = true
        rightSpool.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightSpool.widthAnchor.constraint(equalToConstant: 75).isActive = true
        rightSpool.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        rightSpool.layer.cornerRadius = Dimensions.spoolHeight / 2
        rightSpool.backgroundColor = ColorPalette.lightGrey
        rightSpool.alpha = 1
        rightSpool.clipsToBounds = true
        
        rightSpoolCenter = rightSpool.center
    }
    
    public func getLeftCenter() -> CGPoint {
        guard let leftSpoolCenter = leftSpool?.center else { return CGPoint() }
        return leftSpoolCenter
    }

    public func getRightCenter() -> CGPoint {
        guard let rightSpoolCenter = rightSpool?.center else { return CGPoint() }
        return rightSpoolCenter
    }
    
    public func setUpSpool() {
        leftSpoolView = SpoolView()
        guard let leftSpoolView = leftSpoolView else { return }
        
        rightSpoolView = SpoolView()
        guard let rightSpoolView = rightSpoolView else { return }
        
        guard let leftSpool = leftSpool else { return }
        guard let rightSpool = rightSpool else { return }
        
        self.addSubview(leftSpoolView)
        self.addSubview(rightSpoolView)
        
        rightSpoolView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightSpoolView.centerXAnchor.constraint(equalTo: rightSpool.centerXAnchor),
            rightSpoolView.centerYAnchor.constraint(equalTo: rightSpool.centerYAnchor),
            rightSpoolView.heightAnchor.constraint(equalTo: rightSpool.heightAnchor),
            rightSpoolView.widthAnchor.constraint(equalTo: rightSpool.widthAnchor)
        ])
        
        leftSpoolView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftSpoolView.centerXAnchor.constraint(equalTo: leftSpool.centerXAnchor ),
            leftSpoolView.centerYAnchor.constraint(equalTo: leftSpool.centerYAnchor),
            leftSpoolView.widthAnchor.constraint(equalToConstant: Dimensions.spoolWidth),
            leftSpoolView.heightAnchor.constraint(equalToConstant: Dimensions.spoolHeight)
        ])
    }
    
    public func setUpInnerCircles() {
        leftInnerCircle = UIBezierPath(arcCenter: getLeftCenter(), radius: Dimensions.spoolHeight * 0.3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        guard let leftInnerCircle = leftInnerCircle else { return }
        
        rightInnerCircle = UIBezierPath(arcCenter: getRightCenter(), radius: Dimensions.spoolHeight * 0.3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        guard let rightInnerCircle = rightInnerCircle else { return }
        
        let leftShapeLayer = CAShapeLayer()
        leftShapeLayer.path = leftInnerCircle.cgPath
        
        leftShapeLayer.fillColor = UIColor.clear.cgColor
        leftShapeLayer.strokeColor = ColorPalette.grey.cgColor
        leftShapeLayer.lineWidth = 10
        
        let rightShapeLayer = CAShapeLayer()
        rightShapeLayer.path = rightInnerCircle.cgPath
        
        rightShapeLayer.fillColor = UIColor.clear.cgColor
        rightShapeLayer.strokeColor = ColorPalette.grey.cgColor
        rightShapeLayer.lineWidth = 10
        
        self.layer.addSublayer(leftShapeLayer)
        self.layer.addSublayer(rightShapeLayer)
    }
}
