//
//  FavoritesCollectionViewController.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/2/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CityCell"

class FavoritesCollectionViewController: UICollectionViewController {
    
    let dummyFavorites: [Favorites] = [Favorites(city: "Southaven", state: "Mississippi"),
                                       Favorites(city: "Memphis", state: "Tennessee"),
                                       Favorites(city: "Olive Branch", state: "Mississippi")]
    
    @IBOutlet var cell: UICollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dummyFavorites.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoritesCollectionViewCell else { return UICollectionViewCell() }
        
        // Configure the cell
        let favorites: Favorites
        
        favorites = dummyFavorites[indexPath.item]
        
        // updating UI's
        cell.cityStateLabel.text = "\(favorites.city.capitalized), \(favorites.state.capitalized)"
        
        return cell
    }
}

extension FavoritesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 3 * 20) / 2
        return CGSize(width: width, height: 1.2 * width)
    }
}
