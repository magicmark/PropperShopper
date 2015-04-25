//
//  SearchViewController.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, RecorderDelegate {

    @IBOutlet weak var listeningLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var textSearchEnter: UIButton!
    @IBOutlet weak var topBlacker: UIView!
    @IBOutlet weak var bottomBlacker: UIView!
    
    @IBOutlet var line1: UIView!
    @IBOutlet var line2: UIView!
    @IBOutlet weak var iamlokking4: UILabel!
    
    var voiceRecorder = VoiceRecorder()
    var communicator = Communicator()
    var confirmItem = ConfirmItem(nibName: "ConfirmItem", bundle: nil)


    var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceRecorder.delegate = self
        communicator.delegate = self
        setupActivityIndicator()
        self.addChildViewController(confirmItem)
        view.addSubview(confirmItem.view)
        confirmItem.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width,  UIScreen.mainScreen().bounds.height)
    }

    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        activityIndicator.backgroundColor = UIColor.blueColor()
        view.addSubview(activityIndicator)
    }
    
    
    @IBAction func micClicked(sender: AnyObject) {
        if voiceRecorder.isRecording {
            voiceRecorder.stop()
            micButton.setImage(UIImage(named: "micoff"), forState: .Normal)
            itemObjectRecieved("dsfs")
        } else {
            blackenView()
            voiceRecorder.record()
            micButton.setImage(UIImage(named: "micOn"), forState: .Normal)
        }
    }

    func finished(file: NSURL) {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.startAnimating()
        })
        communicator.sendVoice(file)
        
    }
    
    func blackenView () {
       
        dispatch_async(dispatch_get_main_queue(), {
            self.searchField!.hidden = true
            self.textSearchEnter!.hidden = true
        })
        
        UIView.animateWithDuration(0.5, animations: {
            self.bottomBlacker?.alpha = 0.7
            self.topBlacker?.alpha    = 0.7
            self.line1?.alpha    = 0.0 
            self.line2?.alpha    = 0.0
            self.iamlokking4?.alpha    = 0.0
            self.listeningLabel!.alpha = 1
        })
        

    }

}

extension SearchViewController: CommunicatorDelegate {
    func itemObjectRecieved(data: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.stopAnimating()
        })
        
        
        var item = Item(name: "Dildo", quantity: 28, qualifier: "Pink")
        
        confirmItem.setItem(item)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.confirmItem.view.frame = CGRectMake(0, 150, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
            
            }, completion: nil)
        
        println(data)
    }
}