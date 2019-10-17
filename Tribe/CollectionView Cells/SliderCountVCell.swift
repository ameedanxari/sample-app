//
//  SliderCountVCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class SliderCountVCell: UICollectionViewCell {
    @IBOutlet var imgMain: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        // Initialization code
        imgMain.roundCorners(corners: [.allCorners], radius: imgMain.frame.width / 2.0)
    }
}
