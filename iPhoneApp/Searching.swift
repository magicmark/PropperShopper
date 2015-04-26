//
//  ConfirmItem.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import QuartzCore

protocol SearchingDelegate {
    func searchDone()
}

class Searching: UIViewController {
    
    var delegate: SearchingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    
    
    @IBAction func waitForResults(sender: AnyObject) {
        delegate?.searchDone()
        /*
        let sb = UIStoryboard(name: "StoryboardBro", bundle: nil)
        let searchVC = sb.instantiateInitialViewController() as! UIViewController
        
        self.view.window?.rootViewController = searchVC;
    */
    }
    
    
    
}
