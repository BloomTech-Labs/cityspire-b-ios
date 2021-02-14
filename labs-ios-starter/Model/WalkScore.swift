//
//  WalkScore.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/10/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import MapKit

struct ZipResults: Decodable {
    let features: [Location]
}

class Location: NSObject, Decodable {
    let name: String
    let latitude: Double?
    let longitude: Double?
    let location: String

    enum CodingKeys: String, CodingKey {
        case text
        case place_name
        case center
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .text)
        self.location = try container.decode(String.self, forKey: .place_name)
        var center = try container.nestedUnkeyedContainer(forKey: .center)
        self.longitude = try center.decode(Double.self)
        self.latitude = try center.decode(Double.self)
        
    }
}

extension Location: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    var title: String? {
        String(name)
    }
    var subtitle: String? {
        "Address: \(location)"
    }
}
