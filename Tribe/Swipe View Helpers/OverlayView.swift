//
//  OverlayView.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

open class OverlayView: UIView {
    public var isDisplayingNearbyMatchables = false
    open var overlayState: PanResultDirection?
    open var circleRadius: CGFloat?
    
    open func update(progress: CGFloat) {
        alpha = progress
    }
    
}
