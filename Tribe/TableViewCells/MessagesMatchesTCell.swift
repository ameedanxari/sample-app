//
//  MessagesMatchesTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class MessagesMatchesTCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var cvMatchesQueue: UICollectionView!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "reloadCollections"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func reloadCollectionView(){
        cvMatchesQueue.reloadData()
    }
}
