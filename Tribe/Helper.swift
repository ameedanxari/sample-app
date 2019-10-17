//
//  Helper.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import Foundation
import UIKit
class RoundedImageView: UIImageView
{
    var borderColor = UIColor.tribe_icon_grey.cgColor
    var borderWidth:CGFloat = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
}

class CurvedBorderImageView: UIImageView
{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}

class IntrinsicTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}
