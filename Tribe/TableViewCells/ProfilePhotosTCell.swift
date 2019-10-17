//
//  ProfilePhotosTCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class ProfilePhotosTCell: UITableViewCell {

    // MARK: - Variables
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    // MARK: - Outlets
    @IBOutlet weak var cvProfileImages: UICollectionView!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //re-ordering the images
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        cvProfileImages.addGestureRecognizer(longPressGesture)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Functions
    //#BYPASSED# do something for the missing index if cell is dragged outside of screen
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = cvProfileImages.indexPathForItem(at: gesture.location(in: cvProfileImages)) else {
                break
            }
            cvProfileImages.beginInteractiveMovementForItem(at: selectedIndexPath)
            (cvProfileImages.cellForItem(at: selectedIndexPath) as! ProfilePictureVCell).btnRemovePic.isHidden = true
        case .changed:
            cvProfileImages.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            cvProfileImages.endInteractiveMovement()
            Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(reloadCollectionView), userInfo: nil, repeats: false)
        default:
            cvProfileImages.cancelInteractiveMovement()
            Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(reloadCollectionView), userInfo: nil, repeats: false)
        }
    }
    
    @objc func reloadCollectionView() {
        cvProfileImages.reloadData()
    }
    
    // MARK: - ACtions
    @IBAction func btnDeleteImageAction(_ sender: UIButton) {
    }
}
