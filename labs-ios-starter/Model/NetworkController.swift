//
//  NetworkController.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/10/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case noData
}

protocol NetworkPlaceholder {
    func get(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkController: GetUserInput {
    
    var myUserInput: String?
    let network: NetworkPlaceholder
    init(network: NetworkPlaceholder = URLSession.shared) {
        self.network = network
    }
    
    func capturingUserInput(userInput: String) {
        myUserInput = userInput
        print(myUserInput)
    }
    
    func fetch(completion: @escaping (Walkability?, Error) -> Void) {
        let url = URL(string: "https://api.walkscore.com/score?format=json&address=$address")!
        let request = URLRequest(url: url)
        network.get(request: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(nil, NetworkError.invalidResponse)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let walkScore = try jsonDecoder.decode(Walkability.self, from: data)
                completion(walkScore, NetworkError.noData)
                
            } catch (let error) {
                completion(nil, error)
            }
        }
    }
}
