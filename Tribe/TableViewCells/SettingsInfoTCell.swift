//
//  SettingsInfoTCell.swift
//  Tribe
//
//  Created by Apple on 3/9/18.
//  Copyright © 2018 Hassan. All rights reserved.
//

import UIKit
import RangeSeekSlider
import DLRadioButton

class SettingsInfoTCell: UITableViewCell, RangeSeekSliderDelegate {

    // MARK: - Outlets
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var vwAgeSlider: RangeSeekSlider!
    @IBOutlet weak var vwDistanceSlider: RangeSeekSlider!
    @IBOutlet weak var btnGender: DLRadioButton!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var vwOverLay: UIView!
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var swPublicProfile: UISwitch!
    
    // MARK: - Load
    override func awakeFromNib() {
        super.awakeFromNib()

        vwDistanceSlider.delegate = self
        vwAgeSlider.delegate = self
        //vwDistanceSlider.delegate = self
        
        //setting gender values
        if Global.myProfile.settings.daterSetting.interested == "Male" { //Men
            btnGender.isSelected = true
        } else {
            for btn in btnGender.otherButtons {
                if btn.tag == 1 { //Women
                    btn.isSelected = Global.myProfile.settings.daterSetting.interested == "Female"
                } else if btn.tag == 2 { //Everyone
                    btn.isSelected = Global.myProfile.settings.daterSetting.interested == "Everyone"
                }
            }
        }
    
        // Initialization code
        if let distance = Global.myProfile?.settings?.daterSetting?.distanceRange {
            vwDistanceSlider.selectedMaxValue = CGFloat(distance)
        } else {
            vwDistanceSlider.selectedMaxValue = 60
        }
        
        if let ageMax = Global.myProfile?.settings?.daterSetting?.ageRange?.max {
            vwAgeSlider.selectedMaxValue = CGFloat(ageMax)
        } else {
            vwAgeSlider.selectedMaxValue = 80
        }
        
        if let ageMin = Global.myProfile?.settings?.daterSetting?.ageRange?.min {
            vwAgeSlider.selectedMinValue = CGFloat(ageMin)
        } else {
            vwAgeSlider.selectedMinValue = 18
        }
        
        //setting slider label values
        lblAge.text = "Between \(Int(vwAgeSlider.selectedMinValue)) and \(Int(vwAgeSlider.selectedMaxValue))"
        
        let val:Int = Int(vwDistanceSlider.selectedMaxValue)
        if val == 0 {
            lblDistance.text = "Up to 1/2 miles away"
        } else {
            lblDistance.text = "Up to \(val) miles away"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - RangeSeekSlider Delegates
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        if slider.tag == 0
        {
            let val:Int = Int(maxValue)
            if val == 0 {
                lblDistance.text = "Up to 1/2 miles away"
                Global.myProfile.settings.daterSetting.distanceRange = 0.5
            } else {
                lblDistance.text = "Up to \(val) miles away"
                Global.myProfile.settings.daterSetting.distanceRange = Double(val)
            }
        }
        else
        {
            let valMax:Int = Int(maxValue)
            let valMin: Int = Int (minValue)
            lblAge.text = "Between \(valMin) and \(valMax)"
            Global.myProfile.settings.daterSetting.ageRange.min = valMin
            Global.myProfile.settings.daterSetting.ageRange.max = valMax
        }
        
    }
    
    @IBAction func btnGenderPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            Global.myProfile.settings.daterSetting.interested = "Male"
        case 1:
            Global.myProfile.settings.daterSetting.interested = "Female"
        case 2:
            Global.myProfile.settings.daterSetting.interested = "Everyone"
        default:
            Global.myProfile.settings.daterSetting.interested = ""
        }
    }
    
}
