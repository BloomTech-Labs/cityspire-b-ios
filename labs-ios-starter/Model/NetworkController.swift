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

extension CoordinateRegion {
    
    fileprivate var queryItems: [URLQueryItem] {
        let coordinates = "\(origin.longitude),\(origin.latitude),\(origin.longitude + size.width),\(origin.latitude + size.height)"
        return [
            URLQueryItem(name: "bbox", value: coordinates)
        ]
    }
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

    let baseURL = URL(string: "https://api.mapbox.com/geocoding/v5/mapbox.places/starbucks.json")!
    
    func fetchWalkScore(in region: MKMapRect? = nil, completion: @escaping ([Location]?, Error?) -> Void) {

            
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        var queryItems: [URLQueryItem] = []
        
        if let region = region {
            let coordinates = CoordinateRegion(mapRect: region)
            queryItems.append(contentsOf: coordinates.queryItems)
        }
    
        queryItems.append(URLQueryItem(name: "access_token", value: "pk.eyJ1IjoiYWphbmV1c2hlciIsImEiOiJja2tobzlwYWgwOTNwMndwNzVpNzBienphIn0.fpobc7QzezSeYn67p0jGDg"))
        
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
                decoder.dateDecodingStrategy = .millisecondsSince1970
                let LocationResults = try decoder.decode(ZipResults.self, from: data)
                print("\(LocationResults.features.count)")
                
                for i in LocationResults.features[0...] {
                    print("\(i.location), \(i.name), \(String(describing: i.latitude)), \(String(describing: i.longitude))")
                }
                
                DispatchQueue.main.async {
                    completion(LocationResults.features, nil)
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

    
    
//    func fetch(completion: @escaping (Walkability?, Error) -> Void) {
//        let url = URL(string: "https://api.walkscore.com/score?format=json&address=$address")!
//        let request = URLRequest(url: url)
//        network.get(request: request) { data, response, error in
//            if let error = error {
//                completion(nil, error)
//            }
//
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200 else {
//                completion(nil, NetworkError.invalidResponse)
//                return
//            }
//
//            guard let data = data else {
//                completion(nil, NetworkError.noData)
//                return
//            }
//
//            do {
//                let jsonDecoder = JSONDecoder()
//                let walkScore = try jsonDecoder.decode(Walkability.self, from: data)
//                completion(walkScore, NetworkError.noData)
//
//            } catch (let error) {
//                completion(nil, error)
//            }
//        }
//    }
//
//    func fetchZipCode(lat: String, long: String, completion: @escaping (ZipResults?, Error) -> Void) {
//
//        guard let url = URL(string: "https://api.mapbox.com/geocoding/v5/mapbox.places/\(long),\(lat).json?types=postcode&access_token=pk.eyJ1IjoiYWphbmV1c2hlciIsImEiOiJja2tobzlwYWgwOTNwMndwNzVpNzBienphIn0.fpobc7QzezSeYn67p0jGDg") else {
//            fatalError()
//        }
//
//        let task = session.dataTask(with: url) { data, response, error in
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200..<300).contains(httpResponse.statusCode) else {
//                completion(nil, NetworkError.invalidResponse)
//                return
//            }
//            guard let data = data else {
//                completion(nil, NetworkError.invalidResponse)
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let zipResults = try decoder.decode(ZipResults.self, from: data)
//                self.zipCode = zipResults.features[0].zipCode
//
//                DispatchQueue.main.async {
//                    print("\(zipResults.features[0].zipCode)")
//                    completion(zipResults, NetworkError.noData)
//                }
//
//            } catch {
//                print("Decoding error: \(error)")
//                completion(nil, error)
//            }
//
//        }
//        task.resume()
//    }
//}
