//
//  LoginViewController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth
import EMTNeumorphicView

class LoginViewController: UIViewController {
    
    let profileController = ProfileController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationSuccessful,
                                               object: nil,
                                               queue: .main,
                                               using: checkForExistingProfile)
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationExpired,
                                               object: nil,
                                               queue: .main,
                                               using: alertUserOfExpiredCredentials)
        
        view.backgroundColor = UIColor.offWhite
        configureUI()
    }
    
    func configureUI() {
        
        let mapButton = EMTNeumorphicButton(type: .custom)
        view.addSubview(mapButton)
        mapButton.contentVerticalAlignment = .fill
        mapButton.contentHorizontalAlignment = .fill
        mapButton.titleEdgeInsets = UIEdgeInsets(top: 50, left: 130, bottom: 50, right: 50)
        mapButton.setTitle("Map", for: .normal)
        mapButton.setTitleColor(.offBlack, for: .normal)
        mapButton.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.addTarget(self, action: #selector(didTapMap), for: .touchUpInside)
        // set parameters
        mapButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        mapButton.neumorphicLayer?.cornerRadius = 22.5
        mapButton.isSelected = false
        

        let loginButton = EMTNeumorphicButton(type: .custom)
        view.addSubview(loginButton)
        loginButton.titleEdgeInsets = UIEdgeInsets(top: 20, left: 125, bottom: 20, right: 20)
        loginButton.setTitle("Sign in", for: .normal)
        loginButton.setTitleColor(.offBlack, for: .normal)
        loginButton.contentVerticalAlignment = .fill
        loginButton.contentHorizontalAlignment = .fill
        loginButton.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        loginButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        loginButton.neumorphicLayer?.cornerRadius = 22.5

        let favoritesButton = EMTNeumorphicButton(type: .custom)
        view.addSubview(favoritesButton)
        favoritesButton.titleEdgeInsets = UIEdgeInsets(top: 20, left: 115, bottom: 20, right: 50)
        favoritesButton.setTitle("Favorites", for: .normal)
        favoritesButton.setTitleColor(.offBlack, for: .normal)
        favoritesButton.contentVerticalAlignment = .fill
        favoritesButton.contentHorizontalAlignment = .fill
        favoritesButton.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesButton.addTarget(self, action: #selector(didTapFaves), for: .touchUpInside)
        favoritesButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        favoritesButton.neumorphicLayer?.cornerRadius = 22.5
    
        NSLayoutConstraint.activate([
            mapButton.widthAnchor.constraint(equalToConstant: 300),
            mapButton.heightAnchor.constraint(equalToConstant: 200),
            mapButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 100),
            loginButton.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 64),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            favoritesButton.widthAnchor.constraint(equalToConstant: 300),
            favoritesButton.heightAnchor.constraint(equalToConstant: 100),
            favoritesButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 64),
            favoritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        
    }
    
    // MARK: - Actions
    
    @objc func didTapMap() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
        let detailView = storyboard.instantiateViewController(identifier: "mapView")
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @objc func didTapLogin() {
        UIApplication.shared.open(ProfileController.shared.oktaAuth.identityAuthURL()!)
    }
    
    @objc func didTapFaves() {
        let storyboard: UIStoryboard = UIStoryboard(name: "FavoritesView", bundle: nil)
        let detailView = storyboard.instantiateViewController(identifier: "favoritesView")
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentSimpleAlert(with: "Your Okta credentials have expired",
                           message: "Please sign in again",
                           preferredStyle: .alert,
                           dismissText: "Dimiss")
        }
    }
    
    // MARK: Notification Handling
    
    private func checkForExistingProfile(with notification: Notification) {
        checkForExistingProfile()
    }
    
    private func checkForExistingProfile() {
        profileController.checkForExistingAuthenticatedUserProfile { [weak self] (exists) in
            
            guard let self = self,
                self.presentedViewController == nil else { return }
            
            if exists {
                self.performSegue(withIdentifier: "ShowDetailProfileList", sender: nil)
            } else {
                self.performSegue(withIdentifier: "ModalAddProfile", sender: nil)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalAddProfile" {
            guard let addProfileVC = segue.destination as? AddProfileViewController else { return }
            addProfileVC.delegate = self
        }
    }
}

// MARK: - Add Profile Delegate

extension LoginViewController: AddProfileDelegate {
    func profileWasAdded() {
        checkForExistingProfile()
    }
}
