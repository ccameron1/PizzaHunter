//
//  ViewController.swift
//  PizzaHunter
//
//  Created by Carly Cameron on 5/22/19.
//  Copyright © 2019 Carly Cameron. All rights reserved.
//

import UIKit
import MapKit

class ViewController:  UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var parks : [MKMapItem] = []
    var address : String = ""
    var name : String = "name"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self; locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
    }
    
    @IBAction func zoomButtonPressed(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
    }
   
    @IBAction func searchButtonPressed(_ sender: Any) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pizza"
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: span)
        request.region = region
        let search = MKLocalSearch(request: request)
        
        
        search.start { (response, error) in
            guard let response = response else {return}
            for mapItem in response.mapItems {
                self.parks.append(mapItem)
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                annotation.subtitle = mapItem.phoneNumber
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "pins")
          pin.image = UIImage(named: "MobileMakerIconPinImage")
        if let title = annotation.subtitle, let actualTitle = title {
            if actualTitle != "Pizza Hkjlut" {
                pin.image = UIImage(named: "MobileMakerIconPinImage")
            }
            else {
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            }
        }
        pin.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
        if annotation.isEqual(mapView.userLocation) {
            return nil
        } else {
            return pin
        }
    }
    
    func reverseGeocode(location: CLLocation) -> String{
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks : [CLPlacemark]?, error : Error?) in
            let placemark = placemarks?.first
            if let subthoroughfare = placemark?.subThoroughfare {
                self.address = "\(subthoroughfare) \(placemark!.thoroughfare!) \n \(placemark!.locality!), \(placemark!.administrativeArea!)"
                print("\(self.address)")
                let alertController = UIAlertController(title: "Address", message: "\(self.address)", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
                }
                
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("no subthroughoufare")
            }
        }
        return self.address
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        var placeLat = view.annotation?.coordinate.latitude
        var placeLong = view.annotation?.coordinate.longitude
        var place = CLLocation(latitude: placeLat!, longitude: placeLong!)
        let address2 = reverseGeocode(location: place)
        
    }
}

