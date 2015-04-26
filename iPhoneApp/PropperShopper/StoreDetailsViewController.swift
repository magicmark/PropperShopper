//
//  StoreDetailsViewController.swift
//  PropperShopper
//
//  Created by Bartlomiej Siemieniuk on 26/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class StoreDetailsViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    var geoloc: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        
        let artwork = Store(
            name: "Penis Town",
            address: "Waikiki Gateway Park",

            coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        map.addAnnotation(artwork)
        
        centerMapOnLocation(initialLocation)
        
        self.map.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dealWithMap() {
   
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
