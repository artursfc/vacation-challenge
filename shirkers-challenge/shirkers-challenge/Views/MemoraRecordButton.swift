//
//  MemoraRecordButton.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class MemoraRecordButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        backgroundColor = .memoraRed
        layer.cornerRadius = DesignSystem.Recorder.recordButtonHeight/2
        clipsToBounds = true
    }
}
