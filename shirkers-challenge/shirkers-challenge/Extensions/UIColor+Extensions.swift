//
//  UIColor+Extensions.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//
// swiftlint:disable implicit_getter

import UIKit

extension UIColor {
    enum Theme: String {
        case `default`
        case pastel

        static func theme(from string: String) -> Theme {
            switch string {
            case UIColor.Theme.default.rawValue:
                return .default
            case UIColor.Theme.pastel.rawValue:
                return .pastel
            default:
                return .default
            }
        }
    }

    @UserDefaultsAccess(key: "theme", defaultValue: UIColor.Theme.default.rawValue)
    private static var themeStore

    static var currentTheme: Theme {
        get {
            return Theme.theme(from: themeStore)
        }
        set {
            themeStore = newValue.rawValue
            NotificationCenter.default.post(name: Notification.Name("theme-changed"), object: nil)
        }
    }

    class var memoraRecord: UIColor {
        switch currentTheme {
        case .default:
            return UIColor(red: 192.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        case .pastel:
            return UIColor(red: 255.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        }
    }

    class var memoraAccent: UIColor {
        switch currentTheme {
        case .default:
            return UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
        case .pastel:
            return UIColor(red: 92.0/255.0, green: 74.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        }
    }

    class var memoraFill: UIColor {
        switch currentTheme {
        case .default:
            return UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        case .pastel:
            return UIColor(red: 255.0/255.0, green: 189.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        }
    }

    class var memoraBackground: UIColor {
        switch currentTheme {
        case .default:
            return UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        case .pastel:
            return UIColor(red: 255.0/255.0, green: 222.0/255.0, blue: 191.0/255.0, alpha: 1.0)
        }
    }
}
