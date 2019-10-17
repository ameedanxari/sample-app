//
//  AddMoreContactsTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class AddMoreContactsTCell: UITableViewCell {
    @IBOutlet weak var btnAddMoreContacts: UIButton!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //styling add contacts button
        btnAddMoreContacts.layer.borderWidth = 1
        btnAddMoreContacts.layer.borderColor = UIColor.tribe_purple.cgColor
        btnAddMoreContacts.layer.cornerRadius = btnAddMoreContacts.frame.height / 2
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
import Foundation
