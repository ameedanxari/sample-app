//
//  CustomOverlayView.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

private let overlayRightImageName = "ic_like"
private let overlayInviteImageName = ""
private let overlayLeftImageName = "ic_dislike"

class CustomOverlayView: OverlayView {
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgDislike: UIImageView!
    @IBOutlet weak var overlayImageView: UIImageView!

    override var overlayState: PanResultDirection? {
        didSet {
            switch overlayState {
            case .Left? :
                imgLike.isHidden = true
                imgDislike.isHidden = false
                
                overlayImageView.image = UIImage(named: overlayLeftImageName)
                if Constants.IS_DEBUG {
                    print("gray")
                }
            case .Right? :
                imgLike.isHidden = false
                imgDislike.isHidden = true
                
                overlayImageView.image = UIImage(named: overlayRightImageName)
                if Constants.IS_DEBUG {
                    print("purple")
                }
            default:
                imgLike.isHidden = true
                imgDislike.isHidden = true
                
                overlayImageView.backgroundColor = UIColor.clear
                if Constants.IS_DEBUG {
                    print("clear")
                }
            }
        }
    }
    
    override var circleRadius: CGFloat? {
        didSet {
            //the circle
            var newFrame = overlayImageView.frame
            newFrame.size.height = self.bounds.height/4 //* circleRadius!
            newFrame.size.width = newFrame.size.height
            overlayImageView.frame = newFrame
            var centerPoint:CGPoint = self.center

            overlayImageView.center = centerPoint
            overlayImageView.roundCorners(corners: [.allCorners], radius: overlayImageView.frame.size.height/2)
            //the icon
            var icFrame:CGRect!
            if self.overlayState == .Right {
                icFrame = imgLike.frame
                if circleRadius! < CGFloat(1) {
                    icFrame.size.height = 75.0 * circleRadius!
                } else {
                    icFrame.size.height = 75.0
                }
                icFrame.size.width = icFrame.size.height
                imgLike.frame = icFrame
                imgLike.center = overlayImageView.center
            } else {
                icFrame = imgDislike.frame
                if circleRadius! < CGFloat(1) {
                    icFrame.size.height = 75.0 * circleRadius!
                } else {
                    icFrame.size.height = 75.0
                }
                icFrame.size.width = icFrame.size.height
                imgDislike.frame = icFrame
                imgDislike.center = overlayImageView.center
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
}

