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

    let manager = CLLocationManager()
    var tracking = true
    var myRoute: [CLLocationCoordinate2D] = []
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let bikeLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(bikeLocation, span)
        map.setRegion(region, animated: false)
        self.map.showsUserLocation = true
        
        if tracking {
            map.removeOverlays(map.overlays)
            myRoute.append(bikeLocation)
            print(myRoute)
            let myRoutePolyline = MKPolyline(coordinates: &myRoute, count: myRoute.count)
            self.map.add(myRoutePolyline)
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


}

