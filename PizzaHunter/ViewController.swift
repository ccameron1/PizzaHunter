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
            if actualTitle == "Pizza Hut" {
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        getAddressFromLatLon(pdblLatitude: "\(view.annotation?.coordinate.latitude)", withLongitude: "\(view.annotation?.coordinate.longitude)")
//        view.annotation?.subtitle =
    }

//
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//            {(placemarks, error) in
//                if (error != nil)
//                {
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                let pm = placemarks! as [CLPlacemark]
//
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
//                    var addressString : String = ""
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//
//
//                    print(addressString)
//                }
//        })
//
//    }
}

