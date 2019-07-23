//
//  SpoolView.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 18/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class SpoolView: UIView {
    
    private var topRect : UIView?
    private var bottomRect : UIView?
    private var leftRect : UIView?
    private var rightRect: UIView?
    
    override func draw(_ rect: CGRect) {
        
        topRect = UIView()
        guard let topRect = topRect else { return }
        bottomRect = UIView()
        guard let bottomRect = bottomRect else { return }
        leftRect = UIView()
        guard let leftRect = leftRect else { return }
        rightRect = UIView()
        guard let rightRect = rightRect else { return }
        
        self.backgroundColor = .clear
        
        topRect.backgroundColor = ColorPalette.grey
        bottomRect.backgroundColor = ColorPalette.grey
        rightRect.backgroundColor = ColorPalette.grey
        leftRect.backgroundColor = ColorPalette.grey
        
        self.addSubview(topRect)
        self.addSubview(bottomRect)
        self.addSubview(rightRect)
        self.addSubview(leftRect)
        
        topRect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topRect.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            topRect.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -(self.frame.height * 0.2)),
            topRect.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(self.frame.width) * 0.85),
            topRect.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -(self.frame.height * 0.85))
            ])
        
        bottomRect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomRect.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            bottomRect.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: +(self.frame.height * 0.2)),
            bottomRect.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(self.frame.width) * 0.85),
            bottomRect.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -(self.frame.height * 0.85))
            ])
        
        rightRect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightRect.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: +(self.frame.width * 0.2)),
            rightRect.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            rightRect.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(self.frame.width) * 0.85),
            rightRect.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -(self.frame.height * 0.85))
            ])
        
        leftRect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftRect.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -(self.frame.width * 0.2)),
            leftRect.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            leftRect.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(self.frame.width) * 0.85),
            leftRect.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -(self.frame.height * 0.85))
            ])
        
        bottomRect.layer.cornerRadius = self.frame.height * 0.1
        bottomRect.clipsToBounds = true
        topRect.layer.cornerRadius = self.frame.height * 0.1
        topRect.clipsToBounds = true
        leftRect.layer.cornerRadius = self.frame.width * 0.1
        leftRect.clipsToBounds = true
        rightRect.layer.cornerRadius = self.frame.width * 0.1
        rightRect.clipsToBounds = true
        
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
