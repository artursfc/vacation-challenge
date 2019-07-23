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
    static let spoolWidth : CGFloat = Dimensions.screenHeight * 0.08
    static let spoolHeight : CGFloat = Dimensions.screenHeight * 0.08
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let cassetteTapeHeight : CGFloat = Dimensions.screenHeight * 0.25
    static let cassetteTapeWidth : CGFloat = Dimensions.screenWidth * 0.9
    static let buttonWidth : CGFloat = Dimensions.buttonStackViewWidth/4
    static let buttonHeight : CGFloat = Dimensions.buttonStackViewWidth/4
    static let buttonStackViewSpacing : CGFloat = 5
    static let buttonStackViewWidth : CGFloat = Dimensions.screenWidth * 0.8
    static let leftSpoolCenter : CGPoint = CGPoint(x: Dimensions.cassetteTapeWidth/4, y: Dimensions.cassetteTapeHeight/2)
    static let rightSpoolCenter : CGPoint = CGPoint(x: Dimensions.cassetteTapeWidth * 0.75, y: Dimensions.cassetteTapeHeight/2)
}

enum ReminderPeriods {
    static let timePeriods : [String] = ["1 to 7", "30 to 90", "120 to 365"]
}

extension UIViewController {
    public func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}



