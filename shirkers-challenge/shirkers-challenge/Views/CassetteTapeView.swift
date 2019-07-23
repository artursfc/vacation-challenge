//
//  MainView.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class CassetteTapeView: UIView {
    
    private var cassetteTapeShapeLayer : CassetteTapeShapeLayer?
    
    /* -- MARK: Left Spool Variables
     leftSpool : View used to draw the circle for the spool
     leftSpoolView : View used to draw the inner drawings of the spool; used for animating
     leftInnerCircle : Bezier path used to draw the inner circle
     leftSpoolCenter : Center of the spool view used for positioning and animating
    */
    private var leftSpool : UIView?
    public var leftSpoolView: SpoolView?
    private var leftInnerCircle : UIBezierPath?
    private var leftSpoolCenter : CGPoint = CGPoint()
    
    /* -- MARK: Right Spool Variables
     rightSpool : View used to draw the circle for the spool
     rightleftSpoolView : View used to draw the inner drawings of the spool; used for animating
     rightInnerCircle : Bezier path used to draw the inner circle
     rightSpoolCenter : Center of the spool view used for positioning and animating
    */
    private var rightSpool : UIView?
    public var rightSpoolView : SpoolView?
    private var rightInnerCircle : UIBezierPath?
    private var rightSpoolCenter : CGPoint = CGPoint()
    
    /* -- MARK: Outline Path
     outlinePath : used to draw the frame of the cassette tape; same path coordinates is used for animating
     */
    private var outlinePath : UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        
        cassetteTapeShapeLayer = CassetteTapeShapeLayer()
        
        leftSpool = UIView()
        guard let leftSpool = leftSpool else { return }
        
        rightSpool = UIView()
        guard let rightSpool = rightSpool else { return }
        
        outlinePath = UIBezierPath()
        guard let outlinePath = outlinePath else { return }
        
        outlinePath.move(to: CGPoint(x: Dimensions.leftSpoolCenter.x, y: Dimensions.leftSpoolCenter.y + Dimensions.spoolHeight/2))
        outlinePath.addLine(to: CGPoint(x: Dimensions.leftSpoolCenter.x, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: self.frame.width * 0.25, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: self.frame.width * 0.35, y: Dimensions.cassetteTapeHeight * 0.8 ))
        outlinePath.addLine(to: CGPoint(x: self.frame.width * 0.65, y: Dimensions.cassetteTapeHeight * 0.8))
        outlinePath.addLine(to: CGPoint(x: self.frame.width * 0.75, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: self.frame.width, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: self.frame.width, y: 0))
        outlinePath.addLine(to: CGPoint(x: 0, y: 0))
        outlinePath.addLine(to: CGPoint(x: 0, y: Dimensions.cassetteTapeHeight))
        outlinePath.addLine(to: CGPoint(x: (Dimensions.leftSpoolCenter.x - 10), y: Dimensions.cassetteTapeHeight))
        
        let outlineShapeLayer = CAShapeLayer()
        outlineShapeLayer.path = outlinePath.cgPath
        
        outlineShapeLayer.fillColor = UIColor.clear.cgColor
        outlineShapeLayer.strokeColor = ColorPalette.grey.cgColor
        outlineShapeLayer.lineWidth = 7
        outlineShapeLayer.lineJoin = .round
        outlineShapeLayer.lineCap = .round

        self.layer.addSublayer(outlineShapeLayer)
  
        self.addSubview(leftSpool)
        self.addSubview(rightSpool)
        
        leftSpool.translatesAutoresizingMaskIntoConstraints = false
        leftSpool.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -Dimensions.leftSpoolCenter.x).isActive = true
        leftSpool.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftSpool.widthAnchor.constraint(equalToConstant: Dimensions.spoolWidth).isActive = true
        leftSpool.heightAnchor.constraint(equalToConstant: Dimensions.spoolHeight).isActive = true
        
        leftSpool.layer.cornerRadius = Dimensions.spoolHeight / 2
        leftSpool.backgroundColor = ColorPalette.lightGrey
        leftSpool.alpha = 1
        leftSpool.clipsToBounds = true
        
        leftSpoolCenter = leftSpool.center
        
        rightSpool.translatesAutoresizingMaskIntoConstraints = false
        rightSpool.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Dimensions.leftSpoolCenter.x).isActive = true
        rightSpool.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightSpool.widthAnchor.constraint(equalToConstant: Dimensions.spoolWidth).isActive = true
        rightSpool.heightAnchor.constraint(equalToConstant: Dimensions.spoolHeight).isActive = true
        
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
    
    public func getLeftSpoolView() -> SpoolView {
        guard let leftSpoolView = leftSpoolView else { return SpoolView() }
        return leftSpoolView
    }
    
    public func getRightSpoolView() -> SpoolView {
        guard let rightSpoolView = rightSpoolView else { return SpoolView() }
        return rightSpoolView
    }
    
    private func setUpSpool() {
        leftSpoolView = SpoolView()
        guard let leftSpoolView = leftSpoolView else { return }
        guard let leftSpool = leftSpool else { return }
        leftSpoolView.alpha = 0
        
        rightSpoolView = SpoolView()
        guard let rightSpoolView = rightSpoolView else { return }
        guard let rightSpool = rightSpool else { return }
        rightSpoolView.alpha = 0
        
        self.addSubview(leftSpoolView)
        self.addSubview(rightSpoolView)
        
        rightSpoolView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightSpoolView.centerXAnchor.constraint(equalTo: rightSpool.centerXAnchor),
            rightSpoolView.centerYAnchor.constraint(equalTo: rightSpool.centerYAnchor),
            rightSpoolView.heightAnchor.constraint(equalToConstant: Dimensions.spoolWidth),
            rightSpoolView.widthAnchor.constraint(equalToConstant: Dimensions.spoolHeight)
        ])

        leftSpoolView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftSpoolView.centerXAnchor.constraint(equalTo: leftSpool.centerXAnchor),
            leftSpoolView.centerYAnchor.constraint(equalTo: leftSpool.centerYAnchor),
            leftSpoolView.widthAnchor.constraint(equalToConstant: Dimensions.spoolWidth),
            leftSpoolView.heightAnchor.constraint(equalToConstant: Dimensions.spoolHeight)
        ])
    }
    
    private func setUpInnerCircles() {
        leftInnerCircle = UIBezierPath(arcCenter: Dimensions.leftSpoolCenter, radius: Dimensions.spoolHeight * 0.3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        guard let leftInnerCircle = leftInnerCircle else { return }
        
        rightInnerCircle = UIBezierPath(arcCenter: Dimensions.rightSpoolCenter, radius: Dimensions.spoolHeight * 0.3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        guard let rightInnerCircle = rightInnerCircle else { return }
        
        let leftShapeLayer = CAShapeLayer()
        leftShapeLayer.path = leftInnerCircle.cgPath
        
        leftShapeLayer.fillColor = UIColor.clear.cgColor
        leftShapeLayer.strokeColor = ColorPalette.grey.cgColor
        leftShapeLayer.lineWidth = 7
        
        let rightShapeLayer = CAShapeLayer()
        rightShapeLayer.path = rightInnerCircle.cgPath
        
        rightShapeLayer.fillColor = UIColor.clear.cgColor
        rightShapeLayer.strokeColor = ColorPalette.grey.cgColor
        rightShapeLayer.lineWidth = 7
        
        self.layer.addSublayer(leftShapeLayer)
        self.layer.addSublayer(rightShapeLayer)
    }
    
    public func startSpoolsAnimation(duration: CFTimeInterval) {
        guard let leftSpoolView = leftSpoolView else { return }
        guard let rightSpoolView = rightSpoolView else { return }
        leftSpoolView.startAnimation(duration: duration)
        rightSpoolView.startAnimation(duration: duration)
    }
    
    public func stopSpoolsAnimation() {
        guard let leftSpoolView = leftSpoolView else { return }
        guard let rightSpoolView = rightSpoolView else { return }
        leftSpoolView.stopAnimation()
        rightSpoolView.stopAnimation()
    }
    
    public func stopOutlineAnimation() {
        guard let cassetteTapeShapeLayer = cassetteTapeShapeLayer else { return }
//        cassetteTapeShapeLayer.removeAnimation(forKey: "outlineAnimation")
        let pausedTime : CFTimeInterval = cassetteTapeShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        cassetteTapeShapeLayer.speed = 0.0
        cassetteTapeShapeLayer.timeOffset = pausedTime
        //comment line below to not fill after stopping recording
//        cassetteTapeShapeLayer.removeFromSuperlayer()
    }
    
    public func startOutlineAnimation(duration: CFTimeInterval) {
        guard let cassetteTapeShapeLayer = cassetteTapeShapeLayer else { return }
        cassetteTapeShapeLayer.overlayedOutlinePath(view: self)
        cassetteTapeShapeLayer.speed = 1
        cassetteTapeShapeLayer.timeOffset = 0
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = duration
        self.layer.addSublayer(cassetteTapeShapeLayer)
        cassetteTapeShapeLayer.add(animation, forKey: "outlineAnimation")
    }
    
    override func layoutSubviews() {
        self.setUpSpool()
        self.setUpInnerCircles()
    }
    
    public func startAnimation(duration: CFTimeInterval) {
        self.alpha = 1
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: .pi * 2.0)
        animation.duration = duration
        animation.repeatCount = .infinity
        self.layer.add(animation, forKey: "rotatingAnimation")
    }
    
    public func stopAnimation() {
        self.layer.removeAnimation(forKey: "rotatingAnimation")
    }
    
}
