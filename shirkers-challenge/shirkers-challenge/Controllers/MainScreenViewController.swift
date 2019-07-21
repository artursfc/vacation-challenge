//
//  MainScreenViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 11/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    private var memoryTitle : UITextField?
    private var cassetteTapeView : CassetteTapeView?
    
    private var isTapeRunning : Bool = false
    private var recordButton : CassetteTapeButtonView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorPalette.darkGrey
        
        cassetteTapeView = CassetteTapeView()
        guard let cassetteTapeView = cassetteTapeView else { return }
        
        memoryTitle = UITextField()
        guard let memoryTitle = memoryTitle else { return }
        
        memoryTitle.attributedPlaceholder = NSAttributedString(string: "memory title", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.grey])
        memoryTitle.keyboardAppearance = .dark
        memoryTitle.autocorrectionType = .no
        memoryTitle.returnKeyType = .done
        memoryTitle.textColor = ColorPalette.lightGrey
        memoryTitle.font = UIFont(name: Fonts.main, size: 24)
        
        recordButton = CassetteTapeButtonView(color: ColorPalette.red, altColor: ColorPalette.grey, text: "REC")
        guard let recordButton = recordButton else { return }
        recordButton.addTarget(self, action: #selector(startRec), for: .touchUpInside)
    
        self.view.addSubview(recordButton)
        self.view.addSubview(cassetteTapeView)
        self.view.addSubview(memoryTitle)

        cassetteTapeView.translatesAutoresizingMaskIntoConstraints = false
        cassetteTapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cassetteTapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cassetteTapeView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Dimensions.cassetteTapeWidthConstant)).isActive = true
        cassetteTapeView.heightAnchor.constraint(equalToConstant: Dimensions.cassetteTapeHeight).isActive = true

        memoryTitle.translatesAutoresizingMaskIntoConstraints = false
        memoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryTitle.bottomAnchor.constraint(equalTo: cassetteTapeView.topAnchor, constant: -50).isActive = true
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            recordButton.widthAnchor.constraint(equalToConstant: 65),
            recordButton.heightAnchor.constraint(equalToConstant: 65)
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func startRec() {
        guard let cassetteTapeView = cassetteTapeView else { return }
        guard let recordButton = recordButton else { return }
        if isTapeRunning == false {
            cassetteTapeView.startSpoolsAnimation(duration: 1)
            cassetteTapeView.startOutlineAnimation(duration: 15)
            recordButton.switchColors()
            isTapeRunning = true
        } else {
            cassetteTapeView.stopSpoolsAnimation()
            cassetteTapeView.stopOutlineAnimation()
            recordButton.switchColors()
            isTapeRunning = false
        }
    }
    

}

