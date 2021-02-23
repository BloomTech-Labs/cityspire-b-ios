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
    var walkScoreDescription: String?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var walkabilityScore: UILabel!
    @IBOutlet weak var walkabilityDescriptionTextView: UITextView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
        updateViews()
    }
    
    func updateViews() {
        updateWalkabilityGrade()
        updateDescription()
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
            if address == cityName {
                addressLabel.text = ""
            } else {
                addressLabel.text = address
            }
        }
    }
    
    func updateDescription() {
        walkabilityDescriptionTextView.text = "Shafter is a city in Kern County, California, United States. It is located 18 miles (29 km) west-northwest of Bakersfield. The population was 16,988 at the 2010 census, up from 12,736 at the 2000 census. The city is located along State Route 43. Suburbs of Shafter include Myricks Corner, North Shafter, Smith's Corner, and Thomas Lane."
        if let description = walkScoreDescription {
            walkabilityDescriptionTextView.text = description
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
