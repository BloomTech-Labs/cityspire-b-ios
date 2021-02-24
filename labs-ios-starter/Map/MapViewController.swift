//
//  MapViewController.swift
//  labs-ios-starter
//
//  Created by Denis Cedeno on 1/26/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

extension String {
    static let annotationReuseIdentifier = "LocationAnnotationView"
}

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Properties

    let WalkingScoreNetworkController = NetworkController()

    let cityController = CityController()
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var lat: Double?
    var lon: Double?
    var zip: String?
    var walkScore: Int?
    var walkScoreDescription: String?

    var selectedPin: MKPlacemark? = nil
    private var userTrackingButton: MKUserTrackingButton!


    private var isCurrentlyFetchingWS = false
    private var shouldRequestWSAgain = false

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityController.load()
        self.tabBarController?.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
        mapView.delegate = self
        addUserTrackingButton()
        addSearchbarTable()
        fetchWalkScore()
    }

    // MARK: - Methods
    
    func addSearchbarTable() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "locationSearchTable") as! LocationSearchTableVC
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func addUserTrackingButton() {
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 90)
        ])
    }
    
    func fetchWalkScore() {
 
        WalkingScoreNetworkController.fetchWalkScore(lat: lat, lon: lon, completion: { (walkScore, error) in
        
            if let error = error {
                print("Error fetching walk score: \(error)")
            }
            
            self.walkScore = walkScore?.walkscore
            self.walkScoreDescription = walkScore?.welcomeDescription
            
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailViewController else { return }
        
        guard let locationTitle  = view.annotation?.subtitle else { return }
        
        if let locationTitle = locationTitle {
            
            let city = City(name: locationTitle, walkability: 99)
            let address = view.annotation?.subtitle ?? ""
            
            detailVC.city = city
            detailVC.walkability = walkScore
            detailVC.walkScoreDescription = walkScoreDescription
            detailVC.cityController = cityController
            detailVC.cityName = city.name
            detailVC.address = address
            detailVC.zip = zip
        }
        
        detailVC.modalTransitionStyle = .coverVertical
        detailVC.modalPresentationStyle = .formSheet
        self.present(detailVC, animated: true, completion: nil)
        
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchWalkScore()
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoritesSegue" {
            guard let favoritesVC = segue.destination as? FavoritesCollectionViewController else { return }
            favoritesVC.cityController = cityController
        }
    }

}

// MARK: - Extensions

extension MapViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("error:: \(error.localizedDescription)")
    }
}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // todo: clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        let lat = placemark.coordinate.latitude
        let lon = placemark.coordinate.longitude

        fetchWalkScore()
        self.WalkingScoreNetworkController.fetchZipCodes(lat: lat, lon: lon) { zipResults, error in
            if let zipResults = zipResults {
                self.zip = zipResults.features[0].zipCode
                print(self.zip)
            }
        }
        
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }

}

extension MapViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 1 {
            if let navController = viewController as? UINavigationController, let favController = navController.children.first as? FavoritesCollectionViewController {
                favController.cityController = cityController
            }
         }
    }

}
