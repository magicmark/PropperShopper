//
//  ConfirmItem.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import QuartzCore

class Searching: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    
    
    @IBAction func waitForResults(sender: AnyObject) {
        
        let sb = UIStoryboard(name: "StoryboardBro", bundle: nil)
        let searchVC = sb.instantiateInitialViewController() as! UIViewController
        
        self.view.window?.rootViewController = searchVC;
    
    }
    
    
    
}
