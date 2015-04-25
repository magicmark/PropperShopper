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
    
    var voiceRecorder = VoiceRecorder()
    var communicator = Communicator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceRecorder.delegate = self
    }

    
    
    @IBAction func micClicked(sender: AnyObject) {
        if voiceRecorder.isRecording {
            voiceRecorder.stop()
        } else {
            blackenView()
            voiceRecorder.record()
        }
    }

    func finished(file: NSURL) {
        communicator.sendVoice(file)
    }
    
    func blackenView () {
       
        UIView.animateWithDuration(0.5, animations: {
            self.bottomBlacker?.alpha = 0.7
            self.topBlacker?.alpha    = 0.7
        })
        
        searchField!.hidden = true
        listeningLabel!.hidden = false
        textSearchEnter!.hidden = true
    }

}
