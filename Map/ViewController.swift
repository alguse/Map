//
//  ViewController.swift
//  Map
//
//  Created by Sergio Albarran on 26/02/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    private let manejador = CLLocationManager()
    var previousLocation : CLLocation!
    @IBOutlet weak var vista: UISegmentedControl!
    var distanceT : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manejador.requestWhenInUseAuthorization()
        manejador.delegate = self
        
        map.delegate = self
        map.showsUserLocation = true
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchType(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            map.mapType = .Standard
        case 1:
            map.mapType = .Satellite
        default:
            map.mapType = .Hybrid
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manejador.desiredAccuracy = kCLLocationAccuracyBest
            map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
            manejador.startUpdatingLocation()
        }else{
            manejador.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
 
        if oldLocation != nil{
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            

            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            map.addOverlay(polyline)
        }
        }
            
        if let _ = previousLocation as CLLocation?{
            //solo colocar marca cada x metros
            if previousLocation.distanceFromLocation(newLocation) > 50 {
                addAnnotationsOnMap(newLocation, locationPrevious: previousLocation)
                previousLocation = newLocation
            }
        }else{
            addAnnotationsOnMap(newLocation, locationPrevious: nil)
            previousLocation = newLocation
        }

    }
    
    func addAnnotationsOnMap(locationToPoint : CLLocation, locationPrevious : CLLocation?){
        var currentLocation = CLLocation!()
        currentLocation = manejador.location
        
        var punto = CLLocationCoordinate2D()
        let pin = MKPointAnnotation()
        
        var distance : Double = 0.0
        if locationPrevious != nil{
            distance = locationPrevious!.distanceFromLocation(locationToPoint)
            punto.latitude = locationToPoint.coordinate.latitude
            punto.longitude = locationToPoint.coordinate.longitude
            if distance > 70 {
                distanceT = 0.0
            }else{
                distanceT += distance
            }
            //pin.title = "Lat: \(punto.latitude)" + " Lon: \(punto.longitude)"
            pin.subtitle = "Distancia = \(distanceT)"
            pin.coordinate = punto
            //map.addAnnotation(pin)
        }else{
            distance = 0.0
            punto.latitude = currentLocation.coordinate.latitude
            punto.longitude = currentLocation.coordinate.longitude
        }
    }
 
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        //if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
            polylineRenderer.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        //}
        //return nil
    }
    
}

