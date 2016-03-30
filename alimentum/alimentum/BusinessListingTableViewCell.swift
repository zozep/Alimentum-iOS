//
//  BusinessListingTableViewCell.swift
//  alimentum
//
//  Created by Nitish Dayal on 3/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class BusinessListingTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var businessPic: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
