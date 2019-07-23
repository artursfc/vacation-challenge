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
    private var border : Bool?
    
    required init(color: UIColor, altColor: UIColor, text: String, border: Bool) {
        super.init(frame: .zero)
        self.color = color
        self.altColor = altColor
        self.text = text
        self.border = border
        self.setTitle(text, for: .normal)
        self.setTitleColor(ColorPalette.lightGrey, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.main, size: 24)
        self.layer.cornerRadius = 10
        if !border {
            self.backgroundColor = color
        } else {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = 5
            self.backgroundColor = .clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func switchColors() {
        guard let border = border else { return }
        guard let color = color else { return }
        guard let altColor = altColor else { return }
        if !border {
            if (self.backgroundColor == color) {
                self.backgroundColor = altColor
            } else {
                self.backgroundColor = color
            }
        } else {
            if (self.layer.borderColor == color.cgColor) {
                self.layer.borderColor = altColor.cgColor
            } else {
                self.layer.borderColor = color.cgColor
            }
        }
    }
}
