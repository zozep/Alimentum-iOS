# Alimentum - (iOS)

######Credits

 >Developed by Nitish Dayal, Joseph Park <br />

###Core Functionality:
  Request User location and generate list of 10 closest open food-related businesses in the area (more upon scroll), 
  sortable by "Delivery" or "All".
  User can call businesses listed (if valid number is provided) directly from application, and will be returned to application on call's end.
  
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
  - iOS Core Frameworks: Core Location
  - Github and Git
  
######Research, Resources & Reference Material: 
  - The Swift Programming Language - Swift 2.2 Edition
  - Apple Developer Library
  - Stack Overflow
  - Github Search
  - Yelp API Documentation
  - App Icon by [Art White](https://www.iconfinder.com/ArtWhite)
  
###About:
  This application was designed and developed between Tuesday, 3/29/2016, and Friday, 4/01/2016, by Nitish Dayal & Joseph Park. The primary intent behind developing this application was to gain a better understanding of what was possible with the knowledge we obtained at Coding Dojo. Througout the development process, we utilized Git & Github for version control, Asana for task delegation, and many resources (both internal and external) to put together the necessary bits and pieces. While the current version is by no means complete, continued work on this project is being debated. The primary intent of this project was met; we set out to develop something that we could present during Project Week, and that was a success.
  
However we did not get a chance to finish the application the way **_we wanted to_**, which, frankly, is far more important to us. We want more usability: what if we allowed the user to select between different category options (ie; food, parks, bars, events, etc.), or choose how many results they wanted returned, or save generated lists under location-based categories (ie; home-food-list, school-parks-list, work-bars-list, etc.) to allow for some offline functionality? We wanted to integrate Social Networking/Sharing services. We wanted _pictures_. 

###Brief list of ideas to implement:
- [ ] Use CoreData to save offline lists
- [ ] Find a way to do ^ without breaking Yelp ToC
- [ ] Add drop-down list of basic category options
- [ ] Change Main View Controller title label to update value based on current category 

###License:
  Released under MIT License
