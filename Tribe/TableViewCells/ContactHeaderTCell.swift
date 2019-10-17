//
//  ContactHeaderTCell.swift
//  Tribe
//
//  Created by Creatrixe on 10/07/2018.
//  Copyright © 2018 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class ContactHeaderTCell: UITableViewCell {

    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnUser.layer.cornerRadius = btnUser.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
