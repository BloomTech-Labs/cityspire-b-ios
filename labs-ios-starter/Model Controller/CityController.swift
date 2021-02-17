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

    // Mock data is being used for now
//    var favoriteCities: [City] = [
//        City(name: "Shafter, CA", walkability: 40),
//        City(name: "Bakersfield, CA", walkability: 65),
//        City(name: "Bellevue, WA", walkability: 78)
//    ]
    var favoriteCities: [City] = []
    
    // MARK: - Methods
    
    func favoriteToggled(city: City) {
        if favoriteCities.contains(city) {
            favoriteCities.removeAll { $0 == city }
        } else {
            favoriteCities.append(city)
            print(favoriteCities)
        }
        save()
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
