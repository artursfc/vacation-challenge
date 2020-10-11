//
//  MemoraButton.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class MemoraButton: UIButton {
    enum Style {
        case close
        case save
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp(with style: MemoraButton.Style) {
        switch style {
        case .close:
            setUpWithClose()
        case .save:
            setUpWithSave()
        }
    }

    private func setUpWithClose() {
        let buttonImageConfig = UIImage.SymbolConfiguration(pointSize: 0, weight: .bold, scale: .large)
        let buttonImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: buttonImageConfig)
        setImage(buttonImage, for: .normal)
        tintColor = .memoraLightGray
    }

    private func setUpWithSave() {
        setTitleColor(.memoraDarkGray, for: .normal)
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        layer.cornerRadius = 10
        backgroundColor = .memoraLightGray
    }
}
