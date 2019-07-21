//
//  CassetteTapeButtonView.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 21/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import Foundation

class CassetteTapeButtonView: UIButton {
    
    private var color : UIColor?
    private var altColor : UIColor?
    private var text :  String?
    
    required init(color: UIColor, altColor: UIColor, text: String) {
        super.init(frame: .zero)
        self.color = color
        self.altColor = altColor
        self.text = text
        self.backgroundColor = color
        self.setTitle(text, for: .normal)
        self.setTitleColor(ColorPalette.lightGrey, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.main, size: 24)
        self.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    recordButton.backgroundColor = ColorPalette.red
//    recordButton.setTitle("REC", for: .normal)
//    recordButton.setTitleColor(ColorPalette.lightGrey, for: .normal)
//    recordButton.titleLabel?.font = UIFont(name: Fonts.main, size: 24)
//    recordButton.addTarget(self, action: #selector(startRec), for: .touchUpInside)
//    recordButton.layer.cornerRadius = 10

//    override func draw(_ rect: CGRect) {
//        self.backgroundColor = color
//        self.setTitle(text, for: .normal)
//        self.setTitleColor(ColorPalette.lightGrey, for: .normal)
//        self.titleLabel?.font = UIFont(name: Fonts.main, size: 24)
//        self.layer.cornerRadius = 10
//    }

    
    public func switchColors() {
        if (self.backgroundColor == color) {
            self.backgroundColor = altColor
        } else {
            self.backgroundColor = color
        }
    }
}
