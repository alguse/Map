//
//  MapView2.swift
//  Map
//
//  Created by Sergio Albarran on 06/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import UIKit
import MapKit
import CoreMotion

class MapView2: MKMapView,CLLocationManagerDelegate, MKMapViewDelegate{
    var previousLocation : CLLocation!
    var distanceT : Double = 0.0
    let manejador = CLLocationManager()
    var motionManager = CMMotionManager()
    var timer: NSTimer!
    var highVector: Double = 0
    var lastVector: Double!
    var tresshold: Double = 9.5
    var gameStarted: Bool = false
    var itStartedPop: UILabel!
    var sTimer: NSTimer!
    var utt: Int = 0
    var lastUtt: Int!
    var btnStop: UIButton!
    var msgGivven: Bool = false
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var Control: StartingView!
    var lastPin: MKPointAnnotation!
    var lastPinView: MKPinAnnotationView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
//        self.itStartedPop.center = self.center
        
        self.motionManager.accelerometerUpdateInterval = 0.0001
        self.motionManager.startAccelerometerUpdates()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "motTrigger:", userInfo: nil, repeats: true)
        self.sTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "addTime:", userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(frame : CGRect, controler : UIViewController){
        self.frame = frame
        self.Control = (controler as! StartingView)
        self.itStartedPop = (controler as! StartingView).labelView
        self.btnStop = (controler as! StartingView).StopButton
        self.showsUserLocation = true
        manejador.requestWhenInUseAuthorization()
        manejador.delegate = self
        self.delegate = self
        controler.view.addSubview(self)
        self.itStartedPop.center = controler.view.center
        controler.view.addSubview(itStartedPop)
        controler.view.bringSubviewToFront(itStartedPop)
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
        if gameStarted {
            
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
        
        
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        //if overlay is MKPolyline {
        if gameStarted{
            polylineRenderer.alpha = 1
        } else {
            polylineRenderer.alpha = 0
        }
    
        
        polylineRenderer.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5);
        polylineRenderer.lineWidth = 5
        return polylineRenderer
        //}
        //return nil
    }
    
    func motTrigger(sender: NSTimer!){
        if self.motionManager.accelerometerAvailable == true {
            let acceleration = self.motionManager.accelerometerData?.acceleration
            let argumentx = (acceleration!.x)*(acceleration!.x)
            let argumenty = (acceleration!.y)*(acceleration!.y)
            let argumentz = (acceleration!.z)*(acceleration!.z)
            let vector = sqrt(argumentx + argumentz + argumenty)
//            print(vector)
            self.lastVector = vector
            if lastVector >= highVector {
                highVector = lastVector
                print(highVector)
            }
            if gameStarted == false {
                if lastVector >= tresshold {
                    gameStarted = true
                    print("hip")
//                  animatePOP(0)
                }
            }
            if gameStarted && msgGivven != true{
                animatePOP(0, label: itStartedPop)
                msgGivven = true
            }

        }
    }
    
    func stopGame(){
        self.gameStarted = false
        self.msgGivven = false
        self.highVector = 0
        UIView.animateWithDuration(1, animations: {
            self.btnStop.transform = CGAffineTransformMakeTranslation(0, self.frame.height)
        })
    }
    
    func animatePOP(state: Int, label: UILabel){
        UIView.animateWithDuration(1, animations: {
            label.alpha = 0.65
            self.btnStop.transform = CGAffineTransformMakeTranslation(0, 0 - 100)
        })
        UIView.animateWithDuration(1, animations: {
            label.alpha = 0
        })
    }
    
    func addTime(sender: NSTimer!){
        if gameStarted {
            self.utt += 1
            self.lastUtt = self.utt
//            
            
        } else {
            
            self.utt = 0
            if lastUtt != nil {
//                print(lastUtt)
            }
        }
    }
    
    func getTime()->Int{
        if lastUtt != nil{
        return lastUtt
        } else {
            return 0
        }
    }
    
    func searchBarSearchButtonClicked(searchTerm: String){
        
        if lastPin != nil {
            self.removeAnnotation(lastPin)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchTerm
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "No se encontro el Lugar", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "😨", style: UIAlertActionStyle.Default, handler: nil))
                self.Control.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            let newPoint = MKPointAnnotation()
            newPoint.title = searchTerm
            newPoint.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            let newPinAnnotationView = MKPinAnnotationView(annotation: newPoint, reuseIdentifier: nil)
            self.centerCoordinate = newPoint.coordinate
            self.addAnnotation(newPinAnnotationView.annotation!)
        }
    }
            
}
