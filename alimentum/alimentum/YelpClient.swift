//
//  YelpClient.swift
//  alimentum
//
//  Created by Nitish Dayal on 3/30/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import OAuthSwift

struct YelpAPIConsole {
    var consumerKey = Credentials().c_key
    var consumerSecret = Credentials().c_secret
    var accessToken = Credentials().a_Token
    var accessTokenSecret = Credentials().a_TokenSecret
}

class YelpAPIClient: NSObject {
    
    let APIBaseUrl = "https://api.yelp.com/v2"
    let clientOAuth: OAuthSwiftClient?
    let apiConsoleInfo: YelpAPIConsole
    
    override init() {
        apiConsoleInfo = YelpAPIConsole()
        self.clientOAuth = OAuthSwiftClient(consumerKey: apiConsoleInfo.consumerKey, consumerSecret: apiConsoleInfo.consumerSecret, accessToken: apiConsoleInfo.accessToken, accessTokenSecret: apiConsoleInfo.accessTokenSecret)
        super.init()
    }

    
    func searchPlacesWithParameters(searchParameters: Dictionary<String, String>, successSearch: (data: NSData, response: NSHTTPURLResponse) -> Void, failureSearch: (error: NSError) -> Void) {
        let searchUrl = APIBaseUrl + "/search"
        clientOAuth!.get(searchUrl, parameters: searchParameters, success: successSearch, failure: failureSearch)
    }
}
