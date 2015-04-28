//
//  AppDelegate.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var daddy: Daddy?
    
    var locationM: CLLocationManager?
    var cords: CLLocation?
    var pm: CLPlacemark?
    
    var currentStore: Store?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.location()
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        daddy  = Daddy();
        daddy?.view.frame = UIScreen.mainScreen().bounds;
        window?.rootViewController = daddy!;
        window?.makeKeyAndVisible()
        
        Braintree.setReturnURLScheme("Team-Goat.PropperShopper.payments")

        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return Braintree.handleOpenURL(url, sourceApplication: sourceApplication)
    }
    
    func location() {
        self.locationM = CLLocationManager()
        self.locationM!.delegate = self;
        self.locationM!.desiredAccuracy = kCLLocationAccuracyBest
        self.locationM!.requestAlwaysAuthorization()
        self.locationM!.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        
        self.cords = manager.location;
        self.locationM?.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(
            manager.location,
            completionHandler: { (placemarks, NSError) -> Void in
                
            if placemarks.count > 0 {
                self.pm = placemarks[0] as? CLPlacemark
            }
        })
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if placemark != nil {
            //stop updating location to save battery life
            self.locationM?.stopUpdatingLocation()
            println(placemark!.locality)
            println(placemark!.postalCode)

            println(placemark!.administrativeArea)
            println(placemark!.country)
        }
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

