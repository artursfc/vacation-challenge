//
//  MainScreenViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    private var memoryTitle : UITextField?
    private let cassetteTapeView : CassetteTapeView = CassetteTapeView()
    private let cassetteTapeShapeLayer : CassetteTapeShapeLayer = CassetteTapeShapeLayer()
    private var rightSpoolCenter : CGPoint = CGPoint()
    private var leftSpoolCenter : CGPoint = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorPalette.darkGrey
        
        memoryTitle = UITextField()
        guard let memoryTitle = memoryTitle else { return }
        
        memoryTitle.attributedPlaceholder = NSAttributedString(string: "memory title", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.grey])
        memoryTitle.keyboardAppearance = .dark
        memoryTitle.autocorrectionType = .no
        memoryTitle.returnKeyType = .done
        memoryTitle.textColor = ColorPalette.lightGrey
        memoryTitle.font = UIFont(name: Fonts.main, size: 24)
        
        self.view.addSubview(cassetteTapeView)
        self.view.addSubview(memoryTitle)

        cassetteTapeView.translatesAutoresizingMaskIntoConstraints = false
        cassetteTapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cassetteTapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cassetteTapeView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Dimensions.cassetteTapeWidthConstant)).isActive = true
        cassetteTapeView.heightAnchor.constraint(equalToConstant: Dimensions.cassetteTapeHeight).isActive = true

        memoryTitle.translatesAutoresizingMaskIntoConstraints = false
        memoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryTitle.bottomAnchor.constraint(equalTo: cassetteTapeView.topAnchor, constant: -50).isActive = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cassetteTapeView.setUpInnerCircles()
        cassetteTapeView.setUpSpool()
        leftSpoolCenter = cassetteTapeView.getLeftCenter()
        rightSpoolCenter = cassetteTapeView.getRightCenter()
    }
    
    @objc private func animateTest() {
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 2
        animation.repeatCount = .infinity
        animation.path = cassetteTapeShapeLayer.path
        let path = UIBezierPath()
        path.move(to: rightSpoolCenter)
        path.move(to: CGPoint(x: rightSpoolCenter.x, y: rightSpoolCenter.y + 50))
        let first = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        first.duration = 2
        first.path = path.cgPath
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [first,animation]
        groupAnimation.duration = 4
        
//        squareView.layer.add(groupAnimation, forKey: nil)
        view.layer.addSublayer(cassetteTapeShapeLayer)
    }
    

}

