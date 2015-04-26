//
//  SearchViewController.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {

    var currentItem: Item?
    
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
    var searching = Searching(nibName: "Searching", bundle: nil)

    
    var ob1 = onboard1(nibName: "onboard1", bundle: nil)
    var ob2 = onboard2(nibName: "onboard2", bundle: nil)
    var ob3 = onboard3(nibName: "onboard3", bundle: nil)
    
    @IBOutlet var pageViewController: UIPageViewController!

    var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviewsAndShit()
    }
    
    func setUpSubviewsAndShit() {
        voiceRecorder.delegate = self
        communicator.delegate = self
        confirmItem.delegate = self
        searching.delegate = self
        setupActivityIndicator()
        self.addChildViewController(confirmItem)
        view.addSubview(confirmItem.view)
        self.addChildViewController(searching)
        view.addSubview(searching.view)
        
        
        confirmItem.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width,  UIScreen.mainScreen().bounds.height)
        searching.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width, 150, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)        
        
        self.pageViewController.setViewControllers([ob1], direction: .Forward, animated: true, completion: nil)
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
//            itemObjectRecieved("dsfs")
        } else {
            blackenView()
            voiceRecorder.record()
            micButton.setImage(UIImage(named: "micOn"), forState: .Normal)
        }
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

extension SearchViewController: RecorderDelegate {
    func finished(file: NSURL) {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.startAnimating()
        })
        communicator.sendVoice(file)
        
    }
}

extension SearchViewController: CommunicatorDelegate {
    func itemObjectRecieved(data: NSData) {
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.stopAnimating()
        
        
            let result = JSON(data: data)["obj"]
            println(result)
            
            var item = Item(name: result["name"].stringValue, quantity: result["quantity"].intValue, qualifier: result["qualifier"].stringValue, imgurl: result["imgurl"].stringValue)
            
            self.currentItem = item
            
            self.confirmItem.setItem(item)
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                
                self.confirmItem.view.frame = CGRectMake(0, 150, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
                
            }, completion: nil)
        
        })

        
    }
}

extension SearchViewController: ConfirmItemDelegate {
    func itemConfirmed() {
        communicator.startSearch(currentItem!, coords: "51.5083,0.0594")
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.confirmItem.view.frame = CGRectMake(0-UIScreen.mainScreen().bounds.width, 150, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
            self.searching.view.frame = CGRectMake(0, 150, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
            
            }, completion: nil)
    }
    func itemRejected() {
        
    }
}

extension SearchViewController: SearchingDelegate {
    func searchDone () {
        let sb = UIStoryboard(name: "StoryboardBro", bundle: nil)
        let searchVC = sb.instantiateInitialViewController() as! UIViewController
        self.view.window?.rootViewController = searchVC;
        (searchVC as! ResultsTableViewController).item = currentItem!
    }
}


extension SearchViewController: UIPageViewControllerDataSource {
    

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
//        let pageIndex = (viewController as! OnBoarder).pageIndex;
        
        if let nibname = viewController.nibName {
            switch nibname {
                case "onboard1":
                return nil
            case "onboard2":
                return ob1
            case "onboard3":
                return ob2
            default:
                return nil
            }
        }
        
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let nibname = viewController.nibName {
            switch nibname {
            case "onboard1":
                return ob2
            case "onboard2":
                return ob3
            case "onboard3":
                return nil
            default:
                return nil
            }
        }
        
        return nil
    }
}

extension SearchViewController: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }
//    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
//        self.pageViewController.doubleSided = false;
//        //Return the spine location
//        return UIPageViewControllerSpineLocation.Min
//    }
}