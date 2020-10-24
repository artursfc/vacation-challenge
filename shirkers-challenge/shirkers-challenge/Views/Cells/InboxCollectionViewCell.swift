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
    // MARK: - Properties
    private lazy var memorySymbolImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "waveform"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .memoraAccent
        return imageView
    }()

    static var identifier: String {
        return String(describing: self)
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        layoutConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API
    func configure(with viewModel: MemoryViewModel) {
        memorySymbolImageView.tintColor = .memoraAccent
        contentView.backgroundColor = .memoraFill
    }

    // MARK: - Setup
    private func setUp() {
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        backgroundColor = .memoraFill
        layer.cornerRadius = 20
    }

    // MARK: - Layout
    private func layoutConstraints() {
        contentView.addSubview(memorySymbolImageView)

        NSLayoutConstraint.activate([
            memorySymbolImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            memorySymbolImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            memorySymbolImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                    multiplier: 0.4),
            memorySymbolImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor,
                                                     multiplier: 0.4)
        ])
    }
}
