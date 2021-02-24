//
//  WalkScore.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/10/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import MapKit

struct Welcome: Codable {
    let status, walkscore: Int
    let welcomeDescription, updated: String
    let logoURL: String
    let moreInfoIcon: String
    let moreInfoLink, wsLink, helpLink: String
    let snappedLat, snappedLon: Double

    enum CodingKeys: String, CodingKey {
        case status, walkscore
        case welcomeDescription = "description"
        case updated
        case logoURL = "logo_url"
        case moreInfoIcon = "more_info_icon"
        case moreInfoLink = "more_info_link"
        case wsLink = "ws_link"
        case helpLink = "help_link"
        case snappedLat = "snapped_lat"
        case snappedLon = "snapped_lon"
    }
}

struct ZipResults: Decodable {
    let features: [Text]
}

class Text: NSObject, Decodable {
    let zipCode: String
    
    enum CodingKeys: String, CodingKey {
        case text
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.zipCode = try container.decode(String.self, forKey: .text)
    }
}

