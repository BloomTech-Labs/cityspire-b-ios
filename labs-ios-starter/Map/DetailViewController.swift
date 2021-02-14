//
//  DetailViewController.swift
//  labs-ios-starter
//
//  Created by Bronson Mullens on 2/8/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var isFavorite: Bool = false
    var walkability: Int?
    var cityController: CityController?
    var city: City?
    var zip: String?
    var address: String?
    // MARK: - IBOutlets
    
    @IBOutlet weak var walkabilityScore: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    // MARK: - IBActions
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        isFavorite.toggle()
        if let cityController = cityController,
           let city = city {
            if isFavorite {
                favoriteButton.image = UIImage(systemName: "heart.fill")
                cityController.favoriteToggled(city: city)
            } else {
                favoriteButton.image = UIImage(systemName: "heart")
                if cityController.favoriteCities.contains(city) {
                    cityController.favoriteToggled(city: city)
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        updateWalkabilityGrade()
        checkIfFavorite()
        updateZip()
        updateAddress()
    }
    
    // MARK: - Methods
    
    func updateWalkabilityGrade() {
        guard let walkability = walkability else { return }
        walkabilityScore.text = String(walkability)
        if walkability >= 85 {
            walkabilityScore.textColor = .systemGreen
        } else if walkability >= 50 {
            walkabilityScore.textColor = .systemYellow
        } else {
            walkabilityScore.textColor = .systemRed
        }
    }
    
    func checkIfFavorite() {
        if let cityController = cityController,
           let city = city {
            if cityController.favoriteCities.contains(city) {
                favoriteButton.image = UIImage(systemName: "heart.fill")
            }
        }
    }
    
    func updateZip() {
        if let zip = zip {
            zipLabel.text = zip
        }
    }
    
    func updateAddress() {
        if let address = address {
            addressTextView.text = address
        }
    }
    
}
