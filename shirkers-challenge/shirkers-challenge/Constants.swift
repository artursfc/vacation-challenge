//
//  Constants.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 10/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

enum ColorPalette {
    static let red : UIColor = #colorLiteral(red: 0.6588235294, green: 0, blue: 0, alpha: 1)
    static let lightGrey : UIColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    static let grey : UIColor = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    static let darkGrey : UIColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)
    static let uiERROR : UIColor = #colorLiteral(red: 1, green: 0.9323067069, blue: 0, alpha: 1)
}

enum Fonts {
    static let main : String = "Gill Sans"
}

enum Dimensions {
    static let spoolWidth : CGFloat = 75
    static let spoolHeight : CGFloat = 75
    static let cassetteTapeHeight : CGFloat = 200
    static let cassetteTapeWidthConstant : CGFloat = 50
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}



