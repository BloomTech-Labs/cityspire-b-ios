//
//  NetworkController.swift
//  labs-ios-starter
//
//  Created by Alex Thompson on 2/10/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import MapKit

enum NetworkError: Int, Error {
    case invalidURL
    case noDataReturned
    case dateMathError
    case decodeError
}

protocol NetworkPlaceholder {
    func get(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}


let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

class NetworkController {
    
    var zipCode: String?
    
    var myUserInput: String?
    let network: NetworkPlaceholder
    
    init(network: NetworkPlaceholder = URLSession.shared) {
        self.network = network
    }
    
    let baseURL = URL(string: "https://api.walkscore.com/score?")!
    
    func fetchWalkScore(lat: Double?, lon: Double?, completion: @escaping (Welcome?, Error?) -> Void) {
        
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        var queryItems: [URLQueryItem] = []
        
        if let lat = lat,
           let lon = lon {
            queryItems.append(URLQueryItem(name: "format", value: "json"))
            queryItems.append(URLQueryItem(name: "lat", value: "\(lat)"))
            queryItems.append(URLQueryItem(name: "lon", value: "\(lon)"))
        }
        
        queryItems.append(URLQueryItem(name: "wsapikey", value: "f420dfca879f37bc5288cd895a3c1dd7"))
        
        urlComponents?.queryItems = queryItems
        
        
        guard let url = urlComponents?.url else {
            print("Error creating URL from components")
            completion(nil, NetworkError.invalidURL)
            return
        }
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching walk Score: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                print("No data")
                DispatchQueue.main.async {
                    completion(nil, NetworkError.noDataReturned)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()

                let walkScoreResults = try decoder.decode(Welcome.self, from: data)
                
                DispatchQueue.main.async {
                    completion(walkScoreResults.self, nil)
                }
                
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}

