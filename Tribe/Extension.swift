//
//  Extension.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor Extension
extension UIColor {
    static let tribe_theme_orange = UIColor(hex: 0xF7B801)
    static let tribe_purple = UIColor(hex: 0x673090)
    static let tribe_txt_grey = UIColor(hex: 0x95989A)
    static let tribe_bg_grey = UIColor(hex: 0x000000, a: 0.2)
    static let tribe_txt_blue = UIColor(hex: 0x3598B5)
    static let tribe_icon_grey = UIColor(hex: 0x4a4a4a)
    static let tribe_tabbar_icon_disable = UIColor(hex: 0x49395A)
    static let tribe_txt_green = UIColor(red: 20, green: 192, blue: 167)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}

// MARK: - UIFont Extension
extension UIFont {
    static let tribe_result_label = UIFont(name: "Dosis", size: 36.0)
    static let tribe_heading = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
    static let tribe_txt_label = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
    static let tribe_txt_heading = UIFont(name: "HelveticaNeue-Regular", size: 16.0)
    static let tribe_txt_Bold = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

public enum PanResultDirection: Int {
    case Up
    case Down
    case Left
    case Right
    
    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return !isX }
}

extension UIPanGestureRecognizer {
    
    public var direction: PanResultDirection? {
        let velocity = self.velocity(in: view)
        let vertical = fabs(velocity.y) > fabs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .Up
        case (true, _, let y) where y > 0: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return nil
        }
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath.init(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

extension Date {
    static func getAgeFromString(string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: string) {
            print("Date",dateFormatterPrint.string(from: date)) // Feb 01,2018
            
            let calendar = NSCalendar.current
            
            let components = calendar.dateComponents([.year], from: date, to: Date())
            
            return String(components.year!)
        }
        return ""
    }
    
    static func getDisplayDateFromString(string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/YYYY"
        
        if let date = dateFormatterGet.date(from: string) {
            print("Date",dateFormatterPrint.string(from: date))
            
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }
    
    static func getDateFromString(string: String) -> Date{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterGet.timeZone = TimeZone(identifier: "UTC")
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/YYYY"
        
        
        
        if let date = dateFormatterGet.date(from: string) {
            print("Date",dateFormatterPrint.string(from: date))
            
            return date
        } else if let date = dateFormatterPrint.date(from: string) {
            print("Date",dateFormatterPrint.string(from: date))
            
            return date
        }
        return Date()
    }
    
    static func getMinutesAgoFromString(string: String) -> Int{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: string) {
            print("Date",dateFormatterPrint.string(from: date)) // Feb 01,2018
            
            let calendar = NSCalendar.current
            
            let components = calendar.dateComponents([.minute], from: date, to: Date())
            
            return components.minute!
        }
        return -1
    }
}

extension String{
    static func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date as Date)
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return dateString
            }
        } else if (components.month! >= 2) {
            //return "\(components.month!) months ago"
            return dateString
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return dateString
            }
        } else if (components.weekOfYear! >= 2) {
            //return "\(components.weekOfYear!) weeks ago"
            return dateString
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return dateString
            }
        } else if (components.day! >= 2) {
            return dateString
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            //return "\(components.hour!) hours ago"
            return "Today"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "Today"
            }
        } else if (components.minute! >= 2) {
            //return "\(components.minute!) minutes ago"
            return "Today"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "Today"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Today"
        }
    }
}
extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
