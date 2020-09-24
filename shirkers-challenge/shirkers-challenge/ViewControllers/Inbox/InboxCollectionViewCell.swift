//
//  InboxCollectionViewCell.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 30/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Representation of a `InboxViewController`'s cell.
final class InboxCollectionViewCell: UICollectionViewCell {
    // - MARK: Properties
    @AutoLayout private var memoryEmojiLabel: UILabel

    static var identifier: String {
        return String(describing: self)
    }

    // - MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        layoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with emoji: String) {
        memoryEmojiLabel.text = emoji
        memoryEmojiLabel.font = .preferredFont(forTextStyle: .title1)
        memoryEmojiLabel.textAlignment = .center
    }

    // - MARK: Layout
    private func setupContentView() {
        contentView.backgroundColor = .memoraMediumGray
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }

    private func layoutConstraints() {
        contentView.addSubview(memoryEmojiLabel)

        NSLayoutConstraint.activate([
            memoryEmojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            memoryEmojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            memoryEmojiLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            memoryEmojiLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}
