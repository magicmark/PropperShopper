//
//  FinalUiViewController.swift
//  PropperShopper
//
//  Created by Mark Larah on 26/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FinalUiViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let store = appDelegate.currentStore!
//        
//        self.name.text = store.name
//        
//        let initialLocation = store.coordinate;
//        
//        let xyz = CLLocation(latitude: initialLocation.latitude, longitude: initialLocation.longitude)
//        
//        
//        centerMapOnLocation(xyz)

    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

}