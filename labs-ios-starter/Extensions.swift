//
//  ColorConstants.swift
//  labs-ios-starter
//
//  Created by Denis Cedeno on 2/1/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIColor {
    static let offWhite = #colorLiteral(red: 0.9215686275, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
    static let offBlack = #colorLiteral(red: 0.2431372549, green: 0.2274509804, blue: 0.2509803922, alpha: 1)
    static let offGreen = #colorLiteral(red: 0, green: 0.568627451, blue: 0.4588235294, alpha: 1)
    static let offLightGreen = #colorLiteral(red: 0.3882352941, green: 0.7137254902, blue: 0.6666666667, alpha: 1)
    static let offPurple = #colorLiteral(red: 0.2862745098, green: 0.09411764706, blue: 0.3333333333, alpha: 1)
}

extension UIViewController {
    
    func configureGradientBackground() {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.offWhite.cgColor, UIColor.offLightGreen.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
    }
}
