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


//MARK: - Define custom cell in MainViewController
class BusinessListingTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var callPhoneNumber: UIButton!
    


}
