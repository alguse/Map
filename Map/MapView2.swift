//
//  MapView2.swift
//  Map
//
//  Created by Sergio Albarran on 06/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import UIKit
import MapKit

class MapView2: MKMapView,CLLocationManagerDelegate, MKMapViewDelegate{
    var previousLocation : CLLocation!
    var distanceT : Double = 0.0
    let manejador = CLLocationManager()

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(frame : CGRect, controler : UIViewController){
        self.frame = frame
        self.showsUserLocation = true
        manejador.requestWhenInUseAuthorization()
        manejador.delegate = self
        self.delegate = self
        controler.view.addSubview(self)
        controler.view.sendSubviewToBack(self)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manejador.desiredAccuracy = kCLLocationAccuracyBest
            self.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
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
                self.addOverlay(polyline)
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
