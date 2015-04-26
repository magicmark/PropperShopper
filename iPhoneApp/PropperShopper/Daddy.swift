//
//  Daddy.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit

class Daddy: UIViewController {

    var searchVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        initSubviewControllers()
        
    }
    
    func initSubviewControllers () {
        searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        self.addChildViewController(searchVC!)
        self.view.addSubview(searchVC!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
