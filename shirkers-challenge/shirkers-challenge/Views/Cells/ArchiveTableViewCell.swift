//
//  ArchiveTableViewCell.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 30/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Representation of a `ArchiveViewController`'s cell.
final class ArchiveTableViewCell: UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: MemoryViewModel) {
        setUp()
        textLabel?.text = viewModel.title
    }

    private func setUp() {
        textLabel?.textColor = .memoraAccent
        textLabel?.font = UIFont.preferredFont(forTextStyle: .title2).bold()

        contentView.backgroundColor = .memoraBackground
    }
}
