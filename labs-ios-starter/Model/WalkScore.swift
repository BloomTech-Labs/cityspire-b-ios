//
//  WalkScore.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/10/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

struct Walkability: Codable {
    let walkscore: Int
    let status: Int
    
    enum CodingKeys: Int, CodingKey {
        case walkscore
        case status
    }
}
