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
    private lazy var memoryEmojiLabel: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "waveform"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .memoraAccent
        return imageView
    }()

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

    func configure(with viewModel: MemoryViewModel) {
        memoryEmojiLabel.image = UIImage(systemName: "waveform")
        memoryEmojiLabel.tintColor = .memoraAccent
        contentView.backgroundColor = .memoraFill
    }

    // - MARK: Layout
    private func setupContentView() {
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        backgroundColor = .memoraFill
        layer.cornerRadius = 20
    }

    private func layoutConstraints() {
        contentView.addSubview(memoryEmojiLabel)

        NSLayoutConstraint.activate([
            memoryEmojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            memoryEmojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            memoryEmojiLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                    multiplier: 0.4),
            memoryEmojiLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor,
                                                     multiplier: 0.4)
        ])
    }
}
