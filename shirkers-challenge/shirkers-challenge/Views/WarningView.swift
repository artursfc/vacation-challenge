//
//  WarningView.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 26/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class WarningView: UIView {
    
    private var textLabel : UILabel?
    
    required init(text: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = ColorPalette.grey.cgColor
        
        self.textLabel = UILabel()
        guard let textLabel = self.textLabel else { return }
        textLabel.text = text
        textLabel.textColor = ColorPalette.lightGrey
        textLabel.font = UIFont(name: Fonts.main, size: 24)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        self.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        textLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
