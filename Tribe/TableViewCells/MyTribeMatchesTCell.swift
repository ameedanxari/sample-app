//
//  MyTribeMatchesTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class MyTribeMatchesTCell: UITableViewCell {
    @IBOutlet weak var swRating: UISwitch!
    @IBOutlet weak var lblRatingPermission: UILabel!
    @IBOutlet weak var ratingPermissionTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: RoundedImageView!
    @IBOutlet weak var btnViewProfile: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func hideRatingSwitch() {
        ratingPermissionTrailingConstraint.constant = -110
        swRating.isHidden = true
        lblRatingPermission.isHidden = true
    }
    
    func showRatingSwitch() {
        ratingPermissionTrailingConstraint.constant = 10
        swRating.isHidden = false
        lblRatingPermission.isHidden = false
    }
}
