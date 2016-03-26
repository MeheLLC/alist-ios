//
//  AppMap.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import MapKit
import Crashlytics
import CoreLocation

class AppMap: BaseViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        //self.mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            // Request users location permission
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            //self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
            mapView.showsUserLocation = true // Show current location of user
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enable location services in your settings application.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        AWLoader.show(blurStyle: .Light, shape: .Circle)
        locateFriends()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locateFriends() {
        var annotations = [FriendMapPin]()
        let c1 = CLLocationCoordinate2D(latitude: 30.267566, longitude: -97.740980)
        let ann1 = FriendMapPin(coordinate: c1, title: "John Doe", subtitle: "within 2 miles")
        
        annotations.append(ann1)
        
        self.mapView.addAnnotations(annotations)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            AWLoader.hide()
        }
    }
}
