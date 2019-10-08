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
    private var playButtonShape: UIView?
    private var stopButton : UIButton?
    private var fileName : String?
    
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = .clear
        
        borderView = UIView()
        guard let borderView = borderView else { return }
        borderView.backgroundColor = .clear
        borderView.layer.cornerRadius = 5
        borderView.layer.borderColor = ColorPalette.grey.cgColor
        borderView.layer.borderWidth = 3
        
        playButton = UIButton(frame: .zero)
        guard let playButton = playButton else { return }
        playButton.backgroundColor = .clear

        playButton.addTarget(self, action: #selector(playAudio), for: .touchDown)
        
        playButtonShape = UIView(frame: .zero)
        guard let playButtonShape = playButtonShape else { return }
        playButtonShape.layer.cornerRadius = 2
        playButtonShape.clipsToBounds = true
        
        let shapeLayer = CAShapeLayer()
        playButtonShape.layer.addSublayer(shapeLayer)
        
        shapeLayer.strokeColor = ColorPalette.lightGrey.cgColor
        shapeLayer.fillColor = ColorPalette.lightGrey.cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 20/2))
        path.addLine(to: CGPoint(x: 0, y: 20))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        shapeLayer.path = path.cgPath

        stopButton = UIButton()
        guard let stopButton = stopButton else { return }
        stopButton.backgroundColor = ColorPalette.lightGrey
        stopButton.layer.cornerRadius = 5
        stopButton.clipsToBounds = true

        stopButton.addTarget(self, action: #selector(stopAudio), for: .touchDown)
        
        self.addSubview(borderView)
        self.addSubview(stopButton)
        self.addSubview(playButtonShape)
        self.addSubview(playButton)
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        borderView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        borderView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -3).isActive = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = ColorPalette.lightGrey.cgColor
        
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
        
        playButtonShape.translatesAutoresizingMaskIntoConstraints = false
        playButtonShape.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButtonShape.rightAnchor.constraint(equalTo: stopButton.leftAnchor, constant: -10).isActive = true
        playButtonShape.widthAnchor.constraint(equalToConstant: 20).isActive = true
        playButtonShape.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        guard let textLabel = self.textLabel else { return }
        
        textLabel.textColor = ColorPalette.lightGrey
        textLabel.font = UIFont(name: Fonts.main, size: 20)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    @objc private func playAudio() {
        guard let fileName = fileName else { return }
        AudioSession.shared.clearFileNames()
        AudioSession.shared.setFile(name: fileName)
        AudioSession.shared.setupPlayer()
        AudioSession.shared.play()
    }

    @objc private func stopAudio() {
        AudioSession.shared.stopPlaying()
    }
    
    public func setFileName(name: String) {
        fileName = name
    }

}
