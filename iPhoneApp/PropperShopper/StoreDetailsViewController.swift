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
    var store: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.map.delegate = self
        
        let initialLocation = self.store!.coordinate;
        
        let artwork = Store(
            name: self.store!.name,
            address: self.store!.address,
            coordinate: initialLocation,
            price: self.store!.price
        )
        
        let xyz = CLLocation(latitude: initialLocation.latitude, longitude: initialLocation.longitude)
        
        map.addAnnotation(artwork)
        
        centerMapOnLocation(xyz)
        

        
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
