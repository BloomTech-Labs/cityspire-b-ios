//
//  FavoritesCollectionViewCell.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/3/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        // Setting cells shape and look
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        
        // cell shadow
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.borderWidth = 5.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 5
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
    }
    
    // MARK: IBOutlets

    @IBOutlet var cityStateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
}
