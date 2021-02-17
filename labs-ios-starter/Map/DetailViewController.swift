//
//  DetailViewController.swift
//  labs-ios-starter
//
//  Created by Bronson Mullens on 2/8/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import EMTNeumorphicView

class DetailViewController: UIViewController {

    // MARK: - Properties
    
    var isFavorite: Bool = false
    var walkability: Int?
    var cityController: CityController?
    var city: City?
    var cityName: String?
    var address: String?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var walkabilityScore: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
        updateViews()
    }
    
    func updateViews() {
        updateWalkabilityGrade()
        updateCityName()
        updateAddress()
        configureFaveButton()
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
    
    func updateCityName() {
        if let cityName = cityName {
            cityLabel.text = cityName
        }
    }
    
    func updateAddress() {
        if let address = address {
            addressTextView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
            addressTextView.text = address
        }
    }
    
    func configureFaveButton() {
        
        let button0 = EMTNeumorphicButton(type: .custom)
        view.addSubview(button0)
        button0.setImage(UIImage(named: "heart-solid"), for: .selected)
        button0.setImage(UIImage(named: "heart-outline"), for: .normal)
        
        if let cityController = cityController,
           let city = city {
            if cityController.favoriteCities.contains(city) {
                print("we have a city: \(city)")
                button0.isSelected = true
            } else {
                button0.isSelected = false
            }
        }
        
        button0.contentVerticalAlignment = .fill
        button0.contentHorizontalAlignment = .fill
        button0.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        button0.translatesAutoresizingMaskIntoConstraints = false
        button0.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        // set parameters
        button0.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        button0.neumorphicLayer?.cornerRadius = 22.5
        
        NSLayoutConstraint.activate([
            button0.widthAnchor.constraint(equalToConstant: 70),
            button0.heightAnchor.constraint(equalToConstant: 70),
            button0.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            button0.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 160 - 16),
        ])
    }
    
    @objc func tapped(_ button: EMTNeumorphicButton) {
        button.isSelected = !button.isSelected
        isFavorite.toggle()
        if let cityController = cityController,
           let city = city {
            if isFavorite {
                cityController.favoriteToggled(city: city)
            } else {
                if cityController.favoriteCities.contains(city) {
                    cityController.favoriteToggled(city: city)
                }
            }
        }
    }
}
