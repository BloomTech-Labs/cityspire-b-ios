//
//  LocationDView.swift
//  labs-ios-starter
//
//  Created by Denis Cedeno on 2/14/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class LocationDView: UIView {

    // MARK: - Properties
    var location: Location? {
        didSet {
            updateSubviews()
            
        }
    }
    
    private let nameLabel = UILabel()
    private let locationLabel = UILabel()
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    
    
    private lazy var latLonFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.minimumIntegerDigits = 1
        result.minimumFractionDigits = 2
        result.maximumFractionDigits = 2
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        latitudeLabel.setContentHuggingPriority(.defaultLow+1, for: .horizontal)
        
        let placeDateStackView = UIStackView(arrangedSubviews: [nameLabel, locationLabel])
        placeDateStackView.spacing = UIStackView.spacingUseSystem
        let latLonStackView = UIStackView(arrangedSubviews: [latitudeLabel, longitudeLabel])
        latLonStackView.spacing = UIStackView.spacingUseSystem
        let mainStackView = UIStackView(arrangedSubviews: [placeDateStackView, latLonStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = UIStackView.spacingUseSystem
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func updateSubviews() {

        guard let location = location else { return }
        let name = location.name
        let adress = location.location
        let lLatitude = location.latitude
        let lLongitude = location.longitude
        nameLabel.text = String(name)
        locationLabel.text = String(adress)
        latitudeLabel.text = "Lat: " + latLonFormatter.string(from: lLatitude! as NSNumber)!
        longitudeLabel.text = "Lon: " + latLonFormatter.string(from: lLongitude! as NSNumber)!
    }
}
