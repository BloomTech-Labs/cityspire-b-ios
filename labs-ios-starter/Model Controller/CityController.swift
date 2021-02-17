//
//  CityController.swift
//  labs-ios-starter
//
//  Created by Bronson Mullens on 2/11/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

protocol CityControllerDelegate {
    func favoriteWasChanged()
}

class CityController {
    
    // MARK: - Properties

    var favoriteCities: [City] = []
    var delegate: CityControllerDelegate?
    
    // MARK: - Methods
    
    func favoriteToggled(city: City) {
        if favoriteCities.contains(city) {
            favoriteCities.removeAll { $0 == city }
        } else {
            favoriteCities.append(city)
        }
        save()
        delegate?.favoriteWasChanged()
    }

    func removeFavoriteCity(deleting city: City) {
        if favoriteCities.contains(city) {
            favoriteCities.removeAll { $0 == city }
        }
        save()
        delegate?.favoriteWasChanged()
    }

    // MARK: - Persistence

    var favoritesURL: URL? {
        let fm = FileManager.default
        guard let directory = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return directory.appendingPathComponent("Favorites.plist")
    }

    func save() {
        let encoder = PropertyListEncoder()

        do {
            let favoritesData = try encoder.encode(favoriteCities)

            if let favoritesURL = favoritesURL {
                try favoritesData.write(to: favoritesURL)
            }
        } catch {
            NSLog("Error encoding items: \(error.localizedDescription)")
        }
    }

    func load() {
        let decoder = PropertyListDecoder()
        let fm = FileManager.default

        guard let favoritesURL = favoritesURL,
              fm.fileExists(atPath: favoritesURL.path) else { return }

        do {
            let favoritesData = try Data(contentsOf: favoritesURL)

            let decodedFavorites = try decoder.decode([City].self, from: favoritesData)
            favoriteCities = decodedFavorites
        } catch {
            NSLog("Error decoding items: \(error.localizedDescription)")
        }
    }
    
}
