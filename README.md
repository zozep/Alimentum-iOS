# Alimentum - (iOS)

######Credits

 >Developed by Joseph Park & Nitish Dayal <br />

###Core Functionality:
  - Request User location and generate list of 10 closest open food-related businesses in the area (more upon scroll), 
  sortable by "Delivery" or "All".
  - User can call businesses listed (if valid number is provided) directly from application, and will be returned to application on call's end.
  
###Installation:
 - Clone Github repository
 - Add new file 'Credentials.swift' to project and paste the following into said file, updating necessary information:

```
import UIKit
import OAuthSwift

struct Credentials {

   /* Please provide your own keys/tokens/secrets. This can be obtained at Yelp.com/developers */
    var c_key = "YOUR CONSUMER KEY HERE"
    var c_secret = "YOUR CONSUMER SECRET HERE"
    var a_Token = "YOUR TOKEN HERE"
    var a_TokenSecret = "YOUR TOKEN SECRET HERE"
}
```
  
### Resources Used:

######Development Environment: 
  - Swift 2.2
  - Xcode 7.3
  - Yelp API
  - OAuthSwift
  - iOS Core Frameworks: CoreLocation
  - Github and Git
  
######Research, Resources & Reference Material: 
  - The Swift Programming Language - Swift 2.2 Edition
  - Apple Developer Library
  - Stack Overflow
  - Github Search
  - Yelp API Documentation
  - App Icon by [Art White](https://www.iconfinder.com/ArtWhite)
  
###About:
  The purpose of this application was to **simplify** late night food searches.
  Often, a lot of food related apps have too much information that is irrelevant. All we wanted to check were:
  - Are there any restaurants near me that are open at this hour?
  - Do they deliver?
  - Restaurant rating?
  - Can we call them right away without separate search windows/additional typing?

###License:
  Released under MIT License
