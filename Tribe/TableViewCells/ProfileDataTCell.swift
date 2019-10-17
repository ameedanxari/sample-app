//
//  ProfileDataTCell.swift
//  Tribe
//
//  Created by Saim Tanveer on 08/03/2018.
//  Copyright © 2018 Hassan. All rights reserved.
//

import UIKit
import RangeSeekSlider

class ProfileDataTCell: UITableViewCell, RangeSeekSliderDelegate {

    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtInput: UITextField!
  
    @IBOutlet weak var vwHeightSlider: RangeSeekSlider!
    @IBOutlet weak var vwGender: UIView!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()
        vwGender.backgroundColor = .clear
        vwHeightSlider.delegate = self
        vwHeightSlider.backgroundColor = .clear
        vwHeightSlider.numberFormatter.maximumFractionDigits = 2
        vwHeightSlider.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - RangeSeekSLider Delegates
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        let val = (Int(maxValue)) / 12
        print ("Feet \(val)")
        vwHeightSlider.maxLabelAccessibilityLabel = "\(val)"
        slider.maxLabelAccessibilityLabel = "\(val)"
        print ("Height \(maxValue)")
    }
}
