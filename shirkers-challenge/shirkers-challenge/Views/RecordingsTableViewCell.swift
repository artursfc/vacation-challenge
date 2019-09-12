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
    private var playButton : UIButton?
    private var stopButton : UIButton?
    private var fileName : String?
    private var progressBar : UIView?
    
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = .clear
        
        borderView = UIView()
        guard let borderView = borderView else { return }
        borderView.backgroundColor = .clear
        borderView.layer.cornerRadius = 5
        borderView.layer.borderColor = ColorPalette.grey.cgColor
        borderView.layer.borderWidth = 3
        
        progressBar = UIView()
        guard let progressBar = progressBar else { return }
        progressBar.backgroundColor = ColorPalette.grey
        progressBar.frame = CGRect(origin: borderView.center, size: CGSize(width: 0, height: 50))
        
        playButton = UIButton()
        guard let playButton = playButton else { return }
        playButton.backgroundColor = ColorPalette.lightGrey
        playButton.layer.cornerRadius = 10
        playButton.clipsToBounds = true
        
        playButton.addTarget(self, action: #selector(playAudio), for: .touchDown)
        
        stopButton = UIButton()
        guard let stopButton = stopButton else { return }
        stopButton.backgroundColor = ColorPalette.lightGrey
        stopButton.layer.cornerRadius = 5
        stopButton.clipsToBounds = true
        
        stopButton.addTarget(self, action: #selector(stopAudio), for: .touchDown)
        
        self.addSubview(borderView)
        self.addSubview(progressBar)
        self.addSubview(stopButton)
        self.addSubview(playButton)
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        borderView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        borderView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -3).isActive = true
//        self.layer.cornerRadius = 10
//        self.layer.borderWidth = 2
//        self.layer.borderColor = ColorPalette.lightGrey.cgColor
        
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stopButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        stopButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButton.rightAnchor.constraint(equalTo: stopButton.leftAnchor, constant: -10).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        guard let textLabel = self.textLabel else { return }
        
        textLabel.textColor = ColorPalette.lightGrey
        textLabel.font = UIFont(name: Fonts.main, size: 20)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc private func playAudio() {
        guard let fileName = fileName else { return }
        AudioSession.shared.setFile(name: fileName)
        AudioSession.shared.setupPlayer()
        AudioSession.shared.play()
//        progressBarAnimation()
    }
    
    @objc private func stopAudio() {
        AudioSession.shared.stopPlaying()
    }
    
    public func setFileName(name: String) {
        fileName = name
    }
    
//    private func progressBarAnimation() {
//        guard let progressBar = progressBar else { return }
//        UIView.animate(withDuration: 3) {
//            progressBar.frame.size.width = Dimensions.screenWidth - 20
//        }
//    }

}
