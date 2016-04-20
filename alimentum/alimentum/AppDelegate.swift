//
//  AppDelegate.swift
//  alimentum
//
//  Created by Joseph Park, Nitish Dayal
//  Copyright © 2016 Joseph Park, Nitish Dayal. All rights reserved.
//
//  Libraries used in project include: UIKit, CoreLocation, 0AuthSwift
//

import UIKit
import CoreLocation
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        return true
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
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
    // MARK: - OAuthSwift Implementation
    
    func applicationHandleOpenURL(url: NSURL) {
        if (url.host == "oauth-callback") {
            OAuthSwift.handleOpenURL(url)
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        applicationHandleOpenURL(url)
        return true
    }
    
    @available(iOS 9.0, *)
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        applicationHandleOpenURL(url)
        return true
    }
}


//MARK: - Class Extentions

extension String {
    
    //Returns string where all instances of parameter "string" are replaced by parameter "replacement"
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    //Returns string where all instances of "  " are replaced by ""
    func removeWhitespace() -> String {
        return self.replace("  ", replacement: "")
    }
}


extension CAGradientLayer {
    
    //Pretty background is pretty.
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

