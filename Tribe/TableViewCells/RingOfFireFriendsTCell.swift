//
//  RingOfFireFriendsTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class RingOfFireFriendsTCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var collecFriends: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var vwBackground: UIView!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwBackground.layer.borderWidth = 1.0
        vwBackground.layer.borderColor = UIColor.tribe_theme_orange.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
