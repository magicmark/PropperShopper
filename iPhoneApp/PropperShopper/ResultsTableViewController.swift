//
//  ResultsTableViewController.swift
//  PropperShopper
//
//  Created by Bartlomiej Siemieniuk on 26/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController, PTPusherDelegate {

    
    var channel: PTPusherChannel?
    var client: AnyObject?
    
    @IBOutlet weak var preResults: UIView!
    
    var items = [[String:String]]()
    
    var dict: [Dictionary<String, String>] = [
       // ["name":"Location XYZ", "distance":"2 miles", "open":"till 21","price": "2.38$"],
       // ["name":"Location Super Uper", "distance":"2 miles", "open":"till 21","price": "2.38$"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dodgyUiShit()
        registerChannel()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func registerChannel() {
        client = PTPusher.pusherWithKey("4887a850bf459bd31fc9", delegate: self)
        client!.bindToEventNamed("shop", handleWithBlock: { event in
            let data: AnyObject! = event.data;
            println(data)
        })
        //        channel = self.client!.subscribeToChannelNamed("shopChannel")
//        channel?.bindToEventNamed("shop", handleWithBlock: { channelEvent in
//            let data: AnyObject! = channelEvent.data;
//            println(data)
//        })
    }

    func dodgyUiShit() {
        let image = UIImage(named: "items");
        let frame = CGRect(origin: CGPoint(x: 10, y: 3), size: CGSize(width: 35, height: 35))
        
        let thumbnail   = UIImageView(image: image)
        thumbnail.frame = frame
        
        
        let frame2 = CGRect(origin: CGPoint(x: 60, y: 5), size: CGSize(width: 100, height: 35))
        let name = UILabel(frame: frame2)
        name.text = "2 Batteries"
        name.textColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.addSubview(thumbnail)
        thumbnail.tag = 999
        name.tag      = 999
        
        self.navigationController?.navigationBar.addSubview(name)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("store-cell", forIndexPath: indexPath) as! UITableViewCell

        let data = self.items[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = data["name"]
        
        let distance = cell.viewWithTag(2) as! UILabel
        distance.text = data["distance"]
        
        let open     = cell.viewWithTag(3) as! UILabel
        open.text = data["open"]
        
        let price    = cell.viewWithTag(4) as! UILabel
        price.text = data["price"]
        
        
        return cell
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        while let removeView = self.navigationController?.navigationBar.viewWithTag(999) {
            removeView.removeFromSuperview()
        }

        
    }
    

}
