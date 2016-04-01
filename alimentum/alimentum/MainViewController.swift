//
//  ViewController.swift
//  alimentum
//
//  Created by Joseph Park on 3/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import OAuthSwift
import CoreLocation
import MapKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
//MARK: - Define variables to be used throughout app
    
    /* View Components */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    /* Define var locationManager as onstance of CoreLocationLocationManager (CLLocationManager) */
    
    /* API Implementation (see YelpClient.swift) */
    let apiConsoleInfo = YelpAPIConsole()
    let client = YelpAPIClient()
    var apiSearchTerm: NSString!
    
    /* Define variables to be used for CoreLocation functionality */
    let locationManager = CLLocationManager()
    var locationStatus : NSString = "Not Started" // String updated based on location/privacy settings of User
    var userCurrentLocation: String! // Variable to store current location in form of City,State,ZIP,Country for API call
    let reverseGeolocation = CLGeocoder() // Set CoreLocationGeoCoder to var reverseGeolocation. This is not the only use of CoreLocationGeoCoder, but this is the only use we will be getting from it.
    
    /* Variables for filtering returned address from API GET request */
    let chars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890,.:".characters)
    
    /* Define variabled to be assigned to returned values from API GET request */
    var businessList: NSArray = []
    var amtOfBusinessesAvailable: Int!
    var phoneNumber = String()

    
    
//MARK: - Default functions that are a part of UIViewController
    override func viewDidLoad() {
        print("viewdidload")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        initAppearance()
        
    }
    
    func initAppearance() -> Void {
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Set tableView delegate & dataSource as current view controller, allow table row height to automatically adjust with a minimum value of 180
        print("viewwillappear")
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        loadingSpinner.layer.cornerRadius = 2.5
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: - TableView Functions

    
    //Making separate section for each business to allow for spacing between cells
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if businessList.count > 1 {
            print("sectionsintable \(businessList.count)")
            return businessList.count
        }
        else {
            print("sectionsintable false")
            return 1
        }
    }
    
    //Each section should only have one row, for the one business it will hold
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            print("rowsinsection")
            return 1
        } else {
            print(section, "rowsinsection")
            return 0
        }
    }
    
    
    //Clear header for each section so that background view appears.
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("headerview")
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCellIdentifier", forIndexPath: indexPath) as! BusinessListingTableViewCell
        print("tableview cellforrow ", indexPath.section)
        if businessList.count > 0 {
            let currentBusiness = businessList[indexPath.section]
            let dirtyCity = String(currentBusiness["location"]!!["city"]!!)
            let dirtyAddress = String(currentBusiness["location"]!!["display_address"]!!)
            let phone: String!
            if (currentBusiness["display_phone"]!) != nil {
                phone = String(currentBusiness["display_phone"]!!)
            } else {
                print(String(currentBusiness["display_phone"]!))
                phone = "N/A"
                
            }
            let businessAddress = cleanReturnedAddress(dirtyAddress, city: dirtyCity)
            cell.businessName.text = "\(currentBusiness["name"]!! as! String)"
            self.phoneNumber = "\(phone)"
            cell.callPhoneNumber.tag = indexPath.section
            cell.phoneNumber.text = "Phone: \(phone)"
            cell.address.text = "Address: \n\(businessAddress)"
            cell.rating.text = "Yelp! Rating: \(String(currentBusiness["rating"]!! as! Int))"
        }
        return cell
    }
    
//MARK: - Phone Call function
    
    @IBAction func phoneCallButton(sender: UIButton) {
        print(sender.tag)
        if let numberToDial = businessList[sender.tag]["display_phone"]! as? String {
            let url = NSURL(string: "tel://\((numberToDial))")
            if let url = url {
                UIApplication.sharedApplication().openURL(url)
                print("making phonecalls!")
                
            }
            print(url)
        } else {
            showNilPhoneAlert()
        }
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
    

    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.apiSearchTerm = "all"
        case 1:
            self.apiSearchTerm = "delivery"
        default:
            break
        }
        getFoodNearMe(userCurrentLocation, term: apiSearchTerm)
    }
    
    
    /* Function to make API request, passing in users location for parameter "location", 
     term updates based on 'delivery' or 'all' */
    func getFoodNearMe(location: String, term: NSString){
        loadingSpinner.startAnimating()
        client.searchPlacesWithParameters(
            [
                "term": "\(term)",
                "location": "\(location)",
                "radius_filter": "8046.72",
                "category_filter": "food",
                "sort": "0",
                "actionlinks" : "false",
                "limit" : "10"
            ], successSearch: { (data, response) -> Void in
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    self.businessList = result["businesses"]! as! NSArray
                    self.amtOfBusinessesAvailable = result["total"]! as! Int
                    self.animateTable()
                } catch let error as NSError {
                    print(error)
                }
        }) { (error) -> Void in
            print(error)
        }
    }
    
    
    
    /* This alert will be displayed if user does not have Location Services enabled. Will also direct them to their settings page so that they may turn it on */
    func showLocationAlert() {
        let alert = UIAlertController(title: "Location Error", message: "Our application required the use of your location. Please check that Settings>Privacy>Location Services is set to 'ON'.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        showViewController(alert, sender: self)
    }
    
    func showNilPhoneAlert() {
        let alert = UIAlertController(title: "No Number Listed", message: "Sorry, this business does not have a valid number listed! 😥", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        showViewController(alert, sender: self)
    }
    
    
    func getUserLocation() {
        print("getuserlocation")
        /* Once main view has appeared, check if user has enabled location services on their device */
        if CLLocationManager.locationServicesEnabled() == false {
            showLocationAlert() // If user has location services disabled, show UIAlertView described below in func showAlert
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            // If user has location services enabled, request use of current location while app is in foreground (hence 'requestWhenInUse')
        }

    }
    
    
    func cleanReturnedAddress(str: String, city: String) -> String {
        let testThingy = String(str.characters.filter { chars.contains($0) })
        var returnString = testThingy.removeWhitespace().stringByReplacingOccurrencesOfString(",", withString: "\n")
        let insertCommaHere = returnString.endIndex.advancedBy(-10)
        returnString.removeAtIndex(insertCommaHere)
        returnString.insert(",", atIndex: insertCommaHere)
        return returnString
    }
    
    
    func animateTable() {
        dispatch_async(dispatch_get_main_queue(), {
            print("dispatchAsync animatetable")
            self.tableView.reloadData()
            self.scrollToFirstRow()
            let cells = self.tableView.visibleCells
            let tableHeight: CGFloat = self.tableView.bounds.size.height
            
            for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
                cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
            }
            
            var index = 0
            
            for a in cells {
                let cell: UITableViewCell = a as UITableViewCell
                UIView.animateWithDuration(1.3, delay: 0.02 * Double(index), usingSpringWithDamping: 2.0, initialSpringVelocity: 0, options: .TransitionFlipFromTop, animations: {
                    cell.transform = CGAffineTransformMakeTranslation(0, 0);
                    }, completion: nil)
                
                index += 1
            }
        })
        loadingSpinner.stopAnimating()
    }
    
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 1)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }

}









extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace("  ", replacement: "")
    }
}


extension CAGradientLayer {
    
    func turquoiseColor() -> CAGradientLayer {
        let topColor = UIColor(red: (15/255.0), green: (148/255.0), blue: (180/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: Array <AnyObject> = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: Array <AnyObject> = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as? [NSNumber]
        
        return gradientLayer
    }
}