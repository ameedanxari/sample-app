//
//  UtilManager.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import Foundation
import UIKit
import JHTAlertController
import MBProgressHUD

struct UtilManager {
    
    static var hud:MBProgressHUD = MBProgressHUD()
    
    public static func showAlertMessage(message:String)
    {
        
        let alertController = JHTAlertController(title: "CoDate", message: message, preferredStyle: .alert )
        alertController.titleViewBackgroundColor = .white
        alertController.titleTextColor = .black
        alertController.alertBackgroundColor = .white
        alertController.messageFont = .systemFont(ofSize: 12)
        alertController.messageTextColor = .black
        alertController.setButtonTextColorFor(.default, to: .white)
        alertController.setButtonTextColorFor(.cancel, to: .white)
        alertController.dividerColor = .black
        alertController.hasRoundedCorners = true
        
        // Create the action.
        let okAction = JHTAlertAction(title: "OK", style: .cancel,  bgColor: UIColor.tribe_theme_orange, handler: nil)
        alertController.addAction(okAction)
        // Show alert
        //get the current VC
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        //display the alert
        rootViewController?.present(alertController, animated:true, completion:nil);
    }
    
    public static func showBlockMessageDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Oh no!", message: "Please share more details so that we can address this", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            //getting the input values from user
            let incidentDetails = alertController.textFields?[0].text
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Incident details"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // Show alert
        //get the current VC
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        //display the alert
        rootViewController?.present(alertController, animated:true, completion:nil);
    }
    
    //Progress Bar
    public static func showGlobalProgressHUDWithTitle(_ title:String)
    {
        let window = UIApplication.shared.keyWindow?.rootViewController
        //let window:UIWindow = UIApplication.shared.windows.last!
        hud.mode = MBProgressHUDMode.indeterminate
        if !Global.isHudShowing {
            hud = MBProgressHUD.showAdded(to: (window?.view)!, animated: true)
        }
        //hud.color = UIColor.lightGrayColor()
        //hud.activityIndicatorColor = UIColor.lightGrayColor();
        hud.label.numberOfLines = 0
        hud.label.text = title;
        
        Global.isHudShowing = true
    }
    
    public static func dismissGlobalHUD()
    {
        hud.hide(animated: true)
        Global.isHudShowing = false
    }
    
    public static func prefetchImages() {
        //cancel any previous queues
        //then download the main picture of first profile
        //then download the main picture of the next profile
        //then all the pictures of current user
        //then all the pictures of the next user
        //#BYPASSED
//        SDWebImagePrefetcher.shared().cancelPrefetching()
//
//        var urlList:[URL] = []
//
//        if Global.currentMatchable < Global.matchables.count && Global.matchables[(Global.currentMatchable)].pictures != nil  && (Global.matchables[(Global.currentMatchable)].pictures?.count)! > 0 {
//            urlList.append(URL(string: (Global.matchables[(Global.currentMatchable)].pictures?[0].file)!)!)
//        }
//        if Global.currentMatchable + 1 < Global.matchables.count && Global.matchables[(Global.currentMatchable + 1)].pictures != nil  && (Global.matchables[(Global.currentMatchable + 1)].pictures?.count)! > 0 {
//            urlList.append(URL(string: (Global.matchables[(Global.currentMatchable + 1)].pictures?[0].file)!)!)
//        }
//        if Global.currentMatchable < Global.matchables.count {
//            for picture in Global.matchables[Global.currentMatchable].pictures! {
//                urlList.append(URL(string: picture.file!)!)
//            }
//        }
//        if Global.currentMatchable + 1 < Global.matchables.count {
//            for picture in Global.matchables[Global.currentMatchable + 1].pictures! {
//                urlList.append(URL(string: picture.file!)!)
//            }
//        }
//
//        SDWebImagePrefetcher.shared().prefetchURLs(urlList)
    }
    
    public static func logoutUser() {
        UserDefaults.standard.set(nil, forKey: "myProfile")
        UserDefaults.standard.set(nil, forKey: "contacts")
        UserDefaults.standard.set(nil, forKey: "myTribe")
        UserDefaults.standard.set(nil, forKey: "tribeMatches")
        UserDefaults.standard.set(nil, forKey: "profileCache")
        UserDefaults.standard.set(nil, forKey: "blockList")
        
        UIApplication.shared.unregisterForRemoteNotifications()
        Global.messageRequestFromVC = ""
        Global.fbToken = ""
        Global.fbID = ""
        Global.currentProfile = nil
        Global.serverContacts = nil
        Global.myTribe = TribeNTribeData(fromDictionary: [:])
        Global.matchables = []
        Global.currentMatchable = 0
        Global.matchMade = nil
        Global.tribeMatches = []
        Global.currentTribeMatch = nil
        Global.tribeSwipeList = []
        Global.blockList = []
        Global.currentTribeMemberId = ""
        Global.currentTribeMatchable = 0
        Global.currentProfileImageIndex = 0
        Global.localContactsArray.removeAll()
        Global.lastMessage.removeAll()
        Global.myProfile = nil
        Global.user = nil
    }
    
    public static func updateData(){
        ServerManager.Instance.getTribeMatches()
        ServerManager.Instance.getTribe()
        //ServerManager.Instance.getUserDetail(userID: Global.myProfile.id)
    }
}


