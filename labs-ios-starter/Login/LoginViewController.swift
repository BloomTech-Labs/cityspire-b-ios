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
        
        let button0 = EMTNeumorphicButton(type: .custom)
        view.addSubview(button0)
        button0.setImage(UIImage(named: "heart-outline"), for: .normal)
        button0.setImage(UIImage(named: "heart-solid"), for: .selected)
        button0.contentVerticalAlignment = .fill
        button0.contentHorizontalAlignment = .fill
        button0.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        button0.translatesAutoresizingMaskIntoConstraints = false
        button0.addTarget(self, action: #selector(didTapMap), for: .touchUpInside)
        // set parameters
        button0.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        button0.neumorphicLayer?.cornerRadius = 22.5

        let button1 = EMTNeumorphicButton(type: .custom)
        view.addSubview(button1)
        button1.setImage(UIImage(named: "heart-outline"), for: .normal)
        button1.setImage(UIImage(named: "heart-solid"), for: .selected)
        button1.contentVerticalAlignment = .fill
        button1.contentHorizontalAlignment = .fill
        button1.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button1.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        button1.neumorphicLayer?.cornerRadius = 22.5

        let button5 = EMTNeumorphicButton(type: .custom)
        view.addSubview(button5)
        button5.setImage(UIImage(named: "heart-outline"), for: .normal)
        button5.setImage(UIImage(named: "heart-solid"), for: .selected)
        button5.contentVerticalAlignment = .fill
        button5.contentHorizontalAlignment = .fill
        button5.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        button5.translatesAutoresizingMaskIntoConstraints = false
        button5.addTarget(self, action: #selector(didTapFaves), for: .touchUpInside)
        button5.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        button5.neumorphicLayer?.cornerRadius = 22.5
    
        NSLayoutConstraint.activate([
            button0.widthAnchor.constraint(equalToConstant: 300),
            button0.heightAnchor.constraint(equalToConstant: 200),
            button0.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            button0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button1.widthAnchor.constraint(equalToConstant: 300),
            button1.heightAnchor.constraint(equalToConstant: 100),
            button1.topAnchor.constraint(equalTo: button0.bottomAnchor, constant: 64),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button5.widthAnchor.constraint(equalToConstant: 300),
            button5.heightAnchor.constraint(equalToConstant: 100),
            button5.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 64),
            button5.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        
    }
    
    // MARK: - Actions
    
    @objc func didTapMap() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
        let detailView = storyboard.instantiateViewController(identifier: "mapView")
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @objc func didTapLogin() {
        print("login tapped")
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
