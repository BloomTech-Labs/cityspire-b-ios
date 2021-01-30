//
//  FavoritesNeumorphicView.swift
//  labs-ios-starter
//
//  Created by Denis Cedeno on 1/30/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

protocol FaveViewDelegate: class {
    func didTapFaves()
}
class FavoritesNeumorphicView: UIView {
    @IBOutlet var favesView: UIView!
    
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    
    weak var delegate: FaveViewDelegate?

    func buttonTapAction() {
        delegate?.didTapFaves()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FavoritesNeumorphicView", owner: self, options: nil)
        addSubview(favesView)
        setupContentView()
        setshadow()
    }
    
    func setupContentView() {
        favesView.backgroundColor = .offWhite
        favesView.frame = self.bounds
        self.layer.cornerRadius = 15
        self.favesView.layer.cornerRadius = 15
        favesView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        tapGesture.minimumPressDuration = 0.1
        favesView.addGestureRecognizer(tapGesture)
        
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



