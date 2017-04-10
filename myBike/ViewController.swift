//
//  ViewController.swift
//  myBike
//
//  Created by David T Judd on 4/9/17.
//  Copyright © 2017 Tracer Tech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //map
    @IBOutlet var map: MKMapView!
    //toggle Button
    @IBOutlet var toggleButton: UIButton!
    //lables
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    

    let manager = CLLocationManager()
    var tracking = false
    var myRoute: [CLLocationCoordinate2D] = []
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let bikeLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(bikeLocation, span)
        map.setRegion(region, animated: false)
        self.map.showsUserLocation = true
        
        if tracking {
            //clear map??
            map.removeOverlays(map.overlays)
            //addcurrent location to array
            myRoute.append(bikeLocation)
            //print route form array
            let myRoutePolyline = MKPolyline(coordinates: &myRoute, count: myRoute.count)
            self.map.add(myRoutePolyline)
            //update label information
            altitudeLabel.text = String(location.altitude)
            speedLabel.text = String(location.speed)
            latitudeLabel.text = String(location.coordinate.latitude)
            longitudeLabel.text = String(location.coordinate.longitude)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor(red: 0.5569, green: 0.6431, blue: 0.8235, alpha: 1.0) /* #8ea4d2 */
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        self.map.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toggleTrackingActiong(_ sender: Any) {
        tracking = !tracking
        if tracking {
            toggleButton.setImage(#imageLiteral(resourceName: "notTracking"), for: UIControlState.normal)
        } else {
            toggleButton.setImage(#imageLiteral(resourceName: "Tracking"), for: UIControlState.normal)
        }
        myRoute = []
        altitudeLabel.text = ""
        speedLabel.text = ""
        latitudeLabel.text = ""
        longitudeLabel.text = ""
    }

}

