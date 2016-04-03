//
//  AppDelegate.swift
//  alimentum
//
//  Created by Nitish Dayal, Joseph Park
//  Copyright © 2016 Nitish Dayal, Joseph Park. All rights reserved.
//
//  Libraries used in project include: UIKit, CoreLocation, 0AuthSwift
//

import UIKit
import OAuthSwift

//MARK: - YelpAPIConsole struct, to hold key & secret values for API call
struct YelpAPIConsole {
    var consumerKey = Credentials().c_key
    var consumerSecret = Credentials().c_secret
    var accessToken = Credentials().a_Token
    var accessTokenSecret = Credentials().a_TokenSecret
}


//MARK: - Make custom class YelpAPIClient that conforms to class NSObject
class YelpAPIClient: NSObject {
    
    let APIBaseUrl = "https://api.yelp.com/v2"
    let clientOAuth: OAuthSwiftClient?
    let apiConsoleInfo: YelpAPIConsole
    
    override init() {
        apiConsoleInfo = YelpAPIConsole()
        self.clientOAuth = OAuthSwiftClient(consumerKey: apiConsoleInfo.consumerKey, consumerSecret: apiConsoleInfo.consumerSecret, accessToken: apiConsoleInfo.accessToken, accessTokenSecret: apiConsoleInfo.accessTokenSecret)
        super.init()
    }

    /* Add GET request functionality with Yelp! API authorized search URL */
    func searchPlacesWithParameters(searchParameters: Dictionary<String, String>, successSearch: (data: NSData, response: NSHTTPURLResponse) -> Void, failureSearch: (error: NSError) -> Void) {
        let searchUrl = APIBaseUrl + "/search"
        clientOAuth!.get(searchUrl, parameters: searchParameters, success: successSearch, failure: failureSearch)
    }
}
