//
//  DetailViewController.swift
//  labs-ios-starter
//
//  Created by Bronson Mullens on 2/3/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var isFavorite: Bool = false
    var walkability: Int?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var walkabilityScore: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    // MARK: - IBActions
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        isFavorite.toggle()
        favoriteButton.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        updateWalkabilityGrade()
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

}
