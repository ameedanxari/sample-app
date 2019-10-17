//
//  MyContactsTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class MyContactsTCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgTick: UIImageView!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnInvite.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        btnInvite.layer.borderWidth = 1
        btnInvite.layer.cornerRadius = btnInvite.frame.height / 2
        
        btnAdd.layer.borderColor = UIColor.tribe_purple.cgColor
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.cornerRadius = btnAdd.frame.height / 2
        
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
