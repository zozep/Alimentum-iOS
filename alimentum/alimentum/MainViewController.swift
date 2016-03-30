//
//  ViewController.swift
//  alimentum
//
//  Created by Joseph Park on 3/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON
import CoreLocation

<<<<<<< HEAD
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
=======
class MainViewController: UIViewController, UITableViewDelegate {
>>>>>>> 951c434be87f3c10bcc7ba3c6df146401aaf292a

    @IBOutlet weak var tableView: UITableView!
    let apiConsoleInfo = YelpAPIConsole()
    let client = YelpAPIClient()
    let locationManager = CLLocationManager()
    var locationStatus : NSString = "Not Started"
    var latitude: String!
    var longitude: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set tableView delegate & dataSource as current view controller, allow table row height to automatically adjust with a minimum value of 180
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180.0

        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // Set up CoreLocation
        print(CLLocationManager.locationServicesEnabled())
        // Ask app user for permission to access current location
        if CLLocationManager.locationServicesEnabled() == false {
            showAlert()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
            
        }
        getFoodByMe()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Location Error", message: "Our application required the use of your location. Please check that Settings>Privacy>Location Services is set to 'ON'.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        showViewController(alert, sender: self)
    }
    
    @IBOutlet weak var deliveryOnlyButtonClicked: UIButton!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCellIdentifier", forIndexPath: indexPath) as! BusinessListingTableViewCell
        cell.address.text = "123 Broadway St. Bellevue, WA 98004"
        cell.businessName.text = "Mom and Pop Shop"
        cell.phoneNumber.text = "1-800-FUCK-OFF"
        cell.rating.text = "Mad stars bruh"
        cell.businessPic.image = nil
        return cell
    }
    
    func getFoodByMe(){
        client.searchPlacesWithParameters(["ll": "37.788022,-122.399797", "category_filter": "burgers", "radius_filter": "3000", "sort": "0", "limit": "5"], successSearch: { (data, response) -> Void in
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        }) { (error) -> Void in
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            longitude = String(location.coordinate.latitude)
            latitude = String(location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        } else {
            print("Unable to update current location")
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed access to location"
            shouldIAllow = true
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            NSLog("Location set to allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }


}

