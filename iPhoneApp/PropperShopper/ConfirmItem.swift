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
    
    func toProper (result: String) -> String {
        let lowercaseString = result.lowercaseString
        return lowercaseString.stringByReplacingCharactersInRange(lowercaseString.startIndex...lowercaseString.startIndex, withString: String(lowercaseString[lowercaseString.startIndex]).uppercaseString)

    }

    func setItem (item: Item) {
        quantity.text = toProper("\(item.quantity)")
        if count(item.name) == 0 { return }
        
        name.text = toProper(item.name)
        qualifier.text = item.qualifier
        downloadImage(item.imgurl)
    }
    
    
    func getDataFromUrl(url:String, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    
    func downloadImage(url:String){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.productShot.contentMode = .ScaleAspectFill
                self.productShot.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func confirm(sender: AnyObject) {
        delegate?.itemConfirmed()
    }
    

}
