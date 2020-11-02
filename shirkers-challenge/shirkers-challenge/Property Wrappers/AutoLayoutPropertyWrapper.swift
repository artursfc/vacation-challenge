//
//  AutoLayoutPropertyWrapper.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Property wrapper responsible for providing a convinient way of initializing
/// a `UIView` ready for programmatic Auto Layout. It should **only** be
/// used with `UIView`s using `init(frame: .zero)`.
@propertyWrapper class AutoLayout<View: UIView> {
    private lazy var view: View = {
        let view = View(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var wrappedValue: View {
        return view
    }
}
