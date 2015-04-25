//
//  Daddy.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit

class Daddy: UIViewController {

    var searchVC: SearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubviewControllers()
        
    }
    
    func initSubviewControllers () {
        searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
