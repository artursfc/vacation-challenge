//
//  RecordingsTableViewCell.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class RecordingsTableViewCell: UITableViewCell {
    
    private var borderView : UIView?
    
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = .clear
        
        borderView = UIView()
        guard let borderView = borderView else { return }
        borderView.backgroundColor = .clear
        borderView.layer.cornerRadius = 5
        borderView.layer.borderColor = ColorPalette.grey.cgColor
        borderView.layer.borderWidth = 3
        
        self.addSubview(borderView)
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        borderView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        borderView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -3).isActive = true
//        self.layer.cornerRadius = 10
//        self.layer.borderWidth = 2
//        self.layer.borderColor = ColorPalette.lightGrey.cgColor
        
        guard let textLabel = self.textLabel else { return }
        
        textLabel.textColor = ColorPalette.lightGrey
        textLabel.font = UIFont(name: Fonts.main, size: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
