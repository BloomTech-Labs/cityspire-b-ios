//
//  LoginNeumorphicView.swift
//  labs-ios-starter
//
//  Created by Denis Cedeno on 1/30/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func didTapLogin()
}
class LoginNeumorphicView: UIView {
    
    @IBOutlet var signinView: UIView!
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    
    weak var delegate: LoginViewDelegate?

    func buttonTapAction() {
        delegate?.didTapLogin()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LoginNeumorphicView", owner: self, options: nil)
        addSubview(signinView)
        setupContentView()
        setshadow()
    }
    
    func setupContentView() {
        signinView.backgroundColor = .offWhite
        signinView.frame = self.bounds
        self.layer.cornerRadius = 15
        self.signinView.layer.cornerRadius = 15
        signinView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        tapGesture.minimumPressDuration = 0.1
        signinView.addGestureRecognizer(tapGesture)
        
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


