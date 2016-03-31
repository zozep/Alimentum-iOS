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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
//MARK: - Define variables to be used throughout app
    
    /* View Components */
    @IBOutlet weak var tableView: UITableView!
    
    
    /* Define var locationManager as onstance of CoreLocationLocationManager (CLLocationManager) */
    var json: JSON = JSON.null
    
    /* API Implementation (see YelpClient.swift) */
    let apiConsoleInfo = YelpAPIConsole()
    let client = YelpAPIClient()
    var apiSearchTerm: NSString!
    
    /* Define variables to be used for CoreLocation functionality */
    let locationManager = CLLocationManager()
    var locationStatus : NSString = "Not Started" // String updated based on location/privacy settings of User
    var userCurrentLocation: String! // Variable to store current location in form of City,State,ZIP,Country for API call
    let reverseGeolocation = CLGeocoder() // Set CoreLocationGeoCoder to var reverseGeolocation. This is not the only use of CoreLocationGeoCoder, but this is the only use we will be getting from it.
    
    /* Define variabled to be assigned to returned values from API GET request */
    var businessList: NSArray = []
    var amtOfBusinessesAvailable: Int!
    
    
    
//MARK: - Default functions that are a part of UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set tableView delegate & dataSource as current view controller, allow table row height to automatically adjust with a minimum value of 180
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180.0

        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        getUserLocation()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: - TableView Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businessList.count > 0 {
            print(businessList.count)
            return businessList.count
        }
        else {
            print(businessList.count)
            return 1
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCellIdentifier", forIndexPath: indexPath) as! BusinessListingTableViewCell
        
        cell.address.text = "123 Broadway St. Bellevue, WA 98004"
        cell.businessName.text = "Business Name"
        cell.phoneNumber.text = "1-800-BUSI-NES"
        cell.rating.text = "Mad stars bruh"
        cell.businessPic.image = nil
        return cell
    }
    
    

//MARK: - CoreLocation Functions
    
    
    /* Simply checks to see if user has provided us with location access, then prints to log what type of accesss we have been granted */
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
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
    /* Function is a required delegate method (this viewController conforms to the CLLocationManagerDelegate by including this function)
    that is called whenever the user's location is updated. Defaults to updating every second */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Throw it in reverse.
        reverseGeolocation.reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm) //calls displayLocationInfo function if reverseGeolocation is successful
            } else {
                print("Problem with the data received from geocoder")
            }
        }
    }
    
    
    /* This is the function of magic and mystery */
    func displayLocationInfo(placemark: CLPlacemark) {
        
        //Set var usercurrentLocation to the returned values from successful reverseGeolocation.
        userCurrentLocation = "\(placemark.locality!),\(placemark.postalCode!),\(placemark.administrativeArea!),\(placemark.country!)"
        print("Just checking for errors in the stored value of this variable...", userCurrentLocation)
        
        //stop updating location to save battery life (The location should essentially be grabbed only one time instead of updating every second)
        locationManager.stopUpdatingLocation()
        
        //Call function that sends API request, passing in the var userCurrentLocation = "City,State,ZIP,Country"
        apiSearchTerm = "all"
        getFoodNearMe(userCurrentLocation, term: apiSearchTerm)
        
    }
    
    
    /* Function is a optional delegate method (this viewController can take advantage of this method because it conforms to the 
    CLLocationManagerDelegate protocol) */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    
    
    
//MARK: - Custom Functions
    
    
    @IBAction func sortByDelivery(sender: UIButton) {
        print("Data count: \(businessList.count)")
        for value in businessList {
            print(value.count)
            print(value)
        }
//MARK: - Current WIP: working with API response data to display on main tableView
        if sender.titleLabel?.text == "Delivery Only" {
            self.apiSearchTerm = "delivery"
            sender.setTitle("Show All", forState: .Normal)
//            getFoodNearMe(userCurrentLocation, term: apiSearchTerm)
        } else if sender.titleLabel?.text == "Show All"{
            self.apiSearchTerm = "all"
            sender.setTitle("Delivery Only", forState: .Normal)
//            getFoodNearMe(userCurrentLocation, term: apiSearchTerm)
        }
        
        
    }
    /* Function to make API request, passing in users location for parameter "location", 
     term updates based on 'delivery' or 'all' */
    func getFoodNearMe(location: String, term: NSString){
        
        client.searchPlacesWithParameters(
            [
                "term": "\(term)",
                "location": "\(location)",
                "radius_filter": "8046.72",
                "category_filter": "food",
                "sort": "0",
                "limit": "5",
                "open_now": "3857"
            ], successSearch: { (data, response) -> Void in
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    self.businessList = result["businesses"]! as! NSArray
                    self.amtOfBusinessesAvailable = result["total"]! as! Int
                    self.tableView.reloadData()
                } catch let error as NSError {
                    print(error)
                }
        }) { (error) -> Void in
            print(error)
        }
    }
    
    
    
    /* This alert will be displayed if user does not have Location Services enabled. Will also direct them to their settings page so that they may turn it on */
    func showAlert() {
        
        let alert = UIAlertController(title: "Location Error", message: "Our application required the use of your location. Please check that Settings>Privacy>Location Services is set to 'ON'.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        showViewController(alert, sender: self)
    }
    
    func getUserLocation() {
        /* Once main view has appeared, check if user has enabled location services on their device */
        if CLLocationManager.locationServicesEnabled() == false {
            print("hello no location")
            showAlert() // If user has location services disabled, show UIAlertView described below in func showAlert
            
        } else {
            print("hello location")
            // If user has location services enabled, request use of current location while app is in foreground (hence 'requestWhenInUse')
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        }

    }


}

