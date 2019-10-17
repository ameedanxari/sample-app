//
//  MessagesMatchesQueueCCell.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class MessagesMatchesQueueCCell: UICollectionViewCell {
    
    // MARK: - Outlets
    weak var timer: Timer!
    var remainingTime: Int = 0
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgMatches: UIImageView!
    @IBOutlet weak var imgClock: UIImageView!
    
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var btnDislikes: UIButton!
    
    func startTimer() {
        if timer == nil {
            timerTick()
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerTick() {
        if remainingTime <= 0 {
            if timer != nil {
                timer.invalidate()
                self.lblTime.text = "Chat Now!"
                self.imgClock.isHidden = true
            }
            return
        }
        remainingTime -= 1
        
        hmsFrom(seconds: remainingTime) { hours, minutes, seconds in
            
            let hours = self.getStringFrom(seconds: hours)
            let minutes = self.getStringFrom(seconds: minutes)
            let seconds = self.getStringFrom(seconds: seconds)
            
//            self.lblTime.text = "    \(hours):\(minutes):\(seconds)"
            self.lblTime.text = "    \(hours):\(minutes)"
            self.imgClock.isHidden = false
        }
    }
    
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
}
