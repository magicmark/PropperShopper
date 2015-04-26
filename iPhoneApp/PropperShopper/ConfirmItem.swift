//
//  ConfirmItem.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import QuartzCore

protocol ConfirmItemDelegate {
    func itemConfirmed()
    func itemRejected()
}

class ConfirmItem: UIViewController {

    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var qualifier: UILabel!
    
    @IBOutlet weak var productShot: UIImageView!
    
    var delegate: ConfirmItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var imageLayer = productShot.layer
        productShot.layer.cornerRadius = productShot.frame.width/2
        productShot.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    func setItem (item: Item) {
        quantity.text = "\(item.quantity)"
        name.text = item.name
        qualifier.text = item.qualifier
    }
    
    @IBAction func confirm(sender: AnyObject) {
        delegate?.itemConfirmed()
    }
    

}
