//
//  MemoraSlider.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 30/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// The custom `UISlider`used in the `PlayerComponentViewController`.
final class MemoraSlider: UISlider {

    // - MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // - MARK: Layout
    /// Sets up the `UISlider`.
    private func setUp() {
        minimumTrackTintColor = .memoraAccent
        maximumTrackTintColor = .memoraAccent

        setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        tintColor = .memoraAccent
    }

    /// Determines the size of the `UISlider` rect.
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let width = bounds.width
        let height = bounds.height * 0.3
        let point = CGPoint(x: bounds.minX, y: bounds.minY)
        return CGRect(origin: point, size: CGSize(width: width, height: height))
    }

}
