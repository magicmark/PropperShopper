//
//  Communicator.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import Foundation
import Alamofire

class Communicator {
    
    func sendVoice () {
        
        Alamofire.request(.GET, "http://localhost:5000/test")
            .responseJSON {(request, response, JSON, error) in
                
                println(JSON)
                
        }
        
    }
    
}