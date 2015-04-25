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
    var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceRecorder.delegate = self
        communicator.delegate = self
        setupActivityIndicator()
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
            micButton.setImage(UIImage(named: "micOff"), forState: .Normal)
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
       
        UIView.animateWithDuration(0.5, animations: {
            self.bottomBlacker?.alpha = 0.7
            self.topBlacker?.alpha    = 0.7
            self.line1?.alpha    = 0.0
            self.line2?.alpha    = 0.0
            self.iamlokking4?.alpha    = 0.0
            self.listeningLabel!.alpha = 1
        })
        
        searchField!.hidden = true
        textSearchEnter!.hidden = true
    }

}

extension SearchViewController: CommunicatorDelegate {
    func itemObjectRecieved(data: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.stopAnimating()
        })
        println(data)
    }
}