//
//  UIFont+Extensions.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 30/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

extension UIFont {
    func bold() -> UIFont {
        guard let newDescriptor = fontDescriptor.withSymbolicTraits(.traitBold) else {
            return self
        }
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}
