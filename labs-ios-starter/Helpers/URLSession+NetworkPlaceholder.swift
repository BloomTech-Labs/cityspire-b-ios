//
//  URLSession+NetworkPlaceholder.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/10/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

extension URLSession: NetworkPlaceholder {
    
    func get(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let newTask = dataTask(with: request, completionHandler: completionHandler)
        newTask.resume()
    }
}
