//
//  Store.swift
//  PropperShopper
//
//  Created by Bartlomiej Siemieniuk on 26/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import MapKit

class Store: NSObject, MKAnnotation {
    let name: String
    let title: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(
        name: String,
        address: String,
        coordinate: CLLocationCoordinate2D
    ) {
        
        self.title = name
        self.name = name
        self.address = address
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return name
    }
}