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

    @IBOutlet weak var mapView: MKMapView!
    
    let WalkingScoreNetworkController = NetworkController()
    
    let cityController = CityController()
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil
    var zip: String?
    private var userTrackingButton: MKUserTrackingButton!
    
    var starbucksLocations: [Location] = [] {
        didSet {
            
            let oldLocations = Set(oldValue)
            let newLocations = Set(starbucksLocations)
            print("starbucks Locations: \(newLocations.count)")
            let addedLocations = Array(newLocations.subtracting(oldLocations))
            let removedLocations = Array(oldLocations.subtracting(newLocations))

            mapView.removeAnnotations(removedLocations)
            mapView.addAnnotations(addedLocations)
        }
    }
    
    private var isCurrentlyFetchingWS = false
    private var shouldRequestWSAgain = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        
        mapView.delegate = self
        addUserTrackingButton()
        addSearchbarTable()
        fetchWalkScore()
    }
    
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
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 60)
        ])
    }
    
    func fetchWalkScore() {
        // if we were already requesting walk scores....
        guard !isCurrentlyFetchingWS else {
            //then we want to remember to refresh once request comes back
            shouldRequestWSAgain = true
            return
        }

        isCurrentlyFetchingWS = true
        let visibleRegion = mapView.visibleMapRect
        
        WalkingScoreNetworkController.fetchWalkScore(in: visibleRegion) { [self] (locations, error) in
            self.isCurrentlyFetchingWS = false
            
            defer {
                if self.shouldRequestWSAgain {
                    self.shouldRequestWSAgain = false
                    self.fetchWalkScore()
                }
            }
            
            if let error = error {
                print("Error fetching walk score: \(error)")
            }
            guard let locations = locations else {
                self.starbucksLocations = []
                return
            }
            print("count of locations in fetch: \(starbucksLocations.count)")
            let sortedLocation = locations.sorted(by: { (a, b) -> Bool in
                a.location > b.location
            })
        
            self.starbucksLocations = Array(sortedLocation.prefix(100))
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailViewController else { return }
        
        
        guard let locationTitle  = view.annotation?.subtitle else { return }

        if let locationTitle = locationTitle {
            
            let city = City(name: locationTitle, walkability: 99)
            detailVC.city = city
            detailVC.title = "\(locationTitle) \(zip ?? "still nill brah")"
            detailVC.walkability = 99
            detailVC.cityController = cityController
            detailVC.zip = view.annotation?.title ?? ""
            detailVC.address = view.annotation?.subtitle ?? ""
        }

        detailVC.modalTransitionStyle = .coverVertical
        detailVC.modalPresentationStyle = .formSheet
        self.present(detailVC, animated: true, completion: nil)


        
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchWalkScore()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let location = annotation as? Location else { return nil }
        
        guard let annotaionView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier, for: location) as? MKMarkerAnnotationView else {
            preconditionFailure("Missing the registered map annotation view")
        }
        
        annotaionView.image = #imageLiteral(resourceName: "Starbucks-Logo-1992")
        annotaionView.markerTintColor = .clear

        annotaionView.canShowCallout = true
        let detailView = LocationDView()
        detailView.location = location
        annotaionView.detailCalloutAccessoryView = detailView
        
        return annotaionView
    }
}

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
        let annotation = MKPointAnnotation()

        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
                
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


