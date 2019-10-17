//
//  MessagesChatsTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class MessagesChatsTCell: UITableViewCell {

    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var imgProfile: RoundedImageView!
    @IBOutlet weak var lblNewMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwDot: UIView!
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        imgProfile.borderWidth = 4.0
    }

}
