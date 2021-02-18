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

    // MARK: - Properties

    var cityController: CityController?
    let emptyFavoritesLabel = UILabel()

    // MARK: - IBOutlets
    
    @IBOutlet var cell: UICollectionViewCell!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
        cityController?.delegate = self
        updateViews()
    }

    func updateViews() {
        collectionView.reloadData()
        collectionView.delegate = self
        configureLabel()
    }

    func configureLabel() {
        if let count = cityController?.favoriteCities.count {
            if count == 0 {
                if !view.contains(emptyFavoritesLabel) {
                    view.addSubview(emptyFavoritesLabel)
                }
                emptyFavoritesLabel.isHidden = false
                emptyFavoritesLabel.text = "Looks like you should add some favorites!"
                emptyFavoritesLabel.textAlignment = .center
                emptyFavoritesLabel.textColor = .systemGray2
                emptyFavoritesLabel.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    emptyFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    emptyFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
            } else {
                emptyFavoritesLabel.removeFromSuperview()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityController?.favoriteCities.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoritesCollectionViewCell
        cell.cityStateLabel.text = cityController?.favoriteCities[indexPath.row].name
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteFavoriteCity(sender:)), for: .touchUpInside)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
              
        // we need to pass data to the detail view here.........
        
        let city = cityController?.favoriteCities[indexPath.row]
        
        
        guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailViewController else { return }
        
        
            let address = city?.name
            
            detailVC.city = city
            detailVC.walkability = 99
            detailVC.cityController = cityController
            detailVC.cityName = city?.name
            detailVC.address = address
    
        
        detailVC.city = city
        detailVC.modalTransitionStyle = .coverVertical
        detailVC.modalPresentationStyle = .formSheet
        self.present(detailVC, animated: true, completion: nil)
    }

    // MARK: - OBJC Methods

    @objc func deleteFavoriteCity(sender: UIButton) {
        guard let cityController = cityController else { return }
        cityController.removeFavoriteCity(deleting: (cityController.favoriteCities[sender.tag]))
        updateViews()
    }

}

// MARK: - Protocol extensions

extension FavoritesCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 3 * 20) / 2
        return CGSize(width: width, height: 1.2 * width)
    }

}

extension FavoritesCollectionViewController: CityControllerDelegate {

    func favoriteWasChanged() {
        updateViews()
    }

}

