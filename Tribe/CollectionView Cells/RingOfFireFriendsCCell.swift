//
//  RingOfFireFriendsCCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class RingOfFireFriendsCCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var btnLikeDislike: UIButton!
    @IBOutlet weak var lblFriend: UILabel!
    @IBOutlet weak var imgFriend: RoundedImageView!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnLikeDislike.imageView?.contentMode = .scaleAspectFit
    }
}
