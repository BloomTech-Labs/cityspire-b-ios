//
//  NeumorphicView.swift
//  labs-ios-starter
//
//  Created by Denis Cedeno on 1/29/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
protocol MyViewDelegate: class {
    func didTapButton()
}

class NeumorphicView: UIView {
    
    
    @IBOutlet var contentView: UIView!
    
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    
    weak var delegate: MyViewDelegate?

    func buttonTapAction() {
        delegate?.didTapButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NeumorphicView", owner: self, options: nil)
        addSubview(contentView)
        setupContentView()
        setshadow()
    }
    
    func setupContentView() {
        contentView.backgroundColor = .offWhite
        contentView.frame = self.bounds
        self.layer.cornerRadius = 15
        self.contentView.layer.cornerRadius = 15
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        tapGesture.minimumPressDuration = 0.1
        contentView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func viewTapped(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            darkShadow.shadowOffset = CGSize(width: -5, height: -5)
            lightShadow.shadowOffset = CGSize(width: 10, height: 10)

        } else if gesture.state == .ended {
            lightShadow.shadowOffset = CGSize(width: -5, height: -5)
            darkShadow.shadowOffset = CGSize(width: 10, height: 10)
            buttonTapAction()
        }
        
    }

    
    func setshadow() {
        darkShadow.frame = self.bounds
        darkShadow.cornerRadius = 15
        darkShadow.backgroundColor = UIColor.offWhite.cgColor
        darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        darkShadow.shadowOffset = CGSize(width: 10, height: 10)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = 15
        self.layer.insertSublayer(darkShadow, at: 0)
        
        lightShadow.frame = self.bounds
        lightShadow.cornerRadius = 15
        lightShadow.backgroundColor = UIColor.offWhite.cgColor
        lightShadow.shadowColor = UIColor.white.withAlphaComponent(0.9).cgColor
        lightShadow.shadowOffset = CGSize(width: -5, height: -5)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = 15
        self.layer.insertSublayer(lightShadow, at: 0)
    }
}


extension UIColor {
    static let offWhite = UIColor.init(red: 225/255, green: 225/255, blue: 235/255, alpha: 1)
}

