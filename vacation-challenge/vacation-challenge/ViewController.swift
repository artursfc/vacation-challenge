//
//  ViewController.swift
//  vacation-challenge
//
//  Created by Artur Carneiro on 11/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var memoryTitle : UITextField?
    var leftCog : UIView?
    var rightCog : UIView?
    var cogStackView : UIView?

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
        
        // Do any additional setup after loading the view.
        
        view.addSubview(memoryTitle)
        
        memoryTitle.translatesAutoresizingMaskIntoConstraints = false
        memoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
    }


}

