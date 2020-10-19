//
//  MemoraLabel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class MemoraLabel: UILabel {
    enum Style {
        case timestamp
        case `default`
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp(as style: MemoraLabel.Style) {
        textColor = .memoraAccent
        switch style {
        case .default:
            setUpWithDefault()
        case .timestamp:
            setUpWithTimestamp()
        }
    }

    private func setUpWithTimestamp() {
        text = "00:00"
        textAlignment = .center
        font = .preferredFont(forTextStyle: .headline)
    }

    private func setUpWithDefault() {
        textAlignment = .natural
        font = .preferredFont(forTextStyle: .subheadline)
    }
}
