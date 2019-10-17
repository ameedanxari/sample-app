//
//  RingOfFireFriendsTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class SettingsPrivacyTCell: UITableViewCell {

    // MARK: - Outlets
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - 
    @IBAction func showTermsOfService(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Constants.TERMS_URL)!)
    }
    
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Constants.PRIVACY_URL)!)
    }
    
    
}
