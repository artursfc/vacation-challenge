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
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 5
        self.layer.borderColor = ColorPalette.lightGrey.cgColor
        
        guard let textLabel = self.textLabel else { return }
        
        textLabel.textColor = ColorPalette.lightGrey
        textLabel.font = UIFont(name: Fonts.main, size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
