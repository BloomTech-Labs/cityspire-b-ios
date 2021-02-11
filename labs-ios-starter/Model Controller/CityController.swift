//
//  CityController.swift
//  labs-ios-starter
//
//  Created by Bronson Mullens on 2/11/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CityController {
    
    // MARK: - Properties
    
    var favoriteCities: [City] = []
    
    // MARK: - Methods
    
    func favoriteToggled(city: City) {
        if favoriteCities.contains(city) {
            favoriteCities.removeAll { $0 == city }
            print("Removed \(city)")
            print("Favorite cities: \(favoriteCities)")
        } else {
            favoriteCities.append(city)
            print("Appended \(city)")
        }
    }
    
}
