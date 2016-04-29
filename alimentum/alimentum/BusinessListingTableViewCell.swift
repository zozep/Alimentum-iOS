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


//MARK: - Define custom cell in MainViewController
class BusinessListingTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var foodType: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var callPhoneNumber: UIButton!

}
