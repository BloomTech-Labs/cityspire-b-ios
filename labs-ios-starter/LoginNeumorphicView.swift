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
        setupContentView(view: signinView)
        setshadow()
    }
    
    func setupContentView(view: UIView) {
        view.backgroundColor = .offpaperWhite
        view.frame = self.bounds
        self.layer.cornerRadius = ButtonRadius.cornerRadius
        view.layer.cornerRadius = ButtonRadius.cornerRadius
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        tapGesture.minimumPressDuration = 0.1
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            darkShadow.shadowOffset = ButtonRadius.shadowOffsetTapped
            lightShadow.shadowOffset = ButtonRadius.shadowOffsetNotTapped
        } else if gesture.state == .ended {
            lightShadow.shadowOffset = ButtonRadius.shadowOffsetTapped
            darkShadow.shadowOffset = ButtonRadius.shadowOffsetNotTapped
            buttonTapAction()
        }
    }
    
    func setshadow() {
        darkShadow.frame = self.bounds
        darkShadow.cornerRadius = ButtonRadius.cornerRadius
        darkShadow.backgroundColor = ButtonRadius.darkBackgroundColor
        darkShadow.shadowColor = ButtonRadius.darkShadowColor
        darkShadow.shadowOffset = ButtonRadius.shadowOffsetNotTapped
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = ButtonRadius.cornerRadius
        self.layer.insertSublayer(darkShadow, at: 0)
        
        lightShadow.frame = self.bounds
        lightShadow.cornerRadius = ButtonRadius.cornerRadius
        lightShadow.backgroundColor = ButtonRadius.lightBackgroundColor
        lightShadow.shadowColor = ButtonRadius.lightShadowColor
        lightShadow.shadowOffset = ButtonRadius.shadowOffsetTapped
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = ButtonRadius.cornerRadius
        self.layer.insertSublayer(lightShadow, at: 0)
    }
}
