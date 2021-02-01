//
//  ColorConstants.swift
//  labs-ios-starter
//
//  Created by Denis Cedeno on 2/1/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

struct ButtonRadius {
    
    static let cornerRadius: CGFloat = 8
    static let shadowOffsetNotTapped = CGSize(width: 6, height: 6)
    static let shadowOffsetTapped = CGSize(width: -4, height: -4)
    static let lightBackgroundColor = UIColor.offpaperWhite.cgColor
    static let lightShadowColor = UIColor.offpaperWhite.withAlphaComponent(0.9).cgColor
    static let darkBackgroundColor = UIColor.offBlack.cgColor
    static let darkShadowColor = UIColor.offBlack.withAlphaComponent(0.2).cgColor
}

extension UIColor {
    static let offWhite = UIColor.init(red: 225/255, green: 225/255, blue: 235/255, alpha: 1)
    static let offpaperWhite = UIColor.init(red: 255/255, green: 250/255, blue: 240/255, alpha: 1)
    static let offTan = UIColor.init(red: 234/255, green: 221/255, blue: 193/255, alpha: 1)
    static let offGreen = UIColor.init(red: 0/255, green: 145/255, blue: 117/255, alpha: 1)
    static let offBlack = UIColor.init(red: 62/255, green: 58/255, blue: 50/255, alpha: 1)
}

extension UIViewController {
    
    func configureGradientBackground() {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.offpaperWhite.cgColor, UIColor.offTan.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
    }
}
