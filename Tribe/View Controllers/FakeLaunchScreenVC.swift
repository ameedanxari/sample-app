//
//  FakeLaunchScreenVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class FakeLaunchScreenVC: UIViewController {
    
    
    var entryPoint = ""
    var userId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatVC), name: NSNotification.Name(rawValue: "notificationChatVC"), object: nil)
        
        // Do any additional setup after loading the view.
        //check internet connectivity
        ServerManager.Instance.checkInternetConnectivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        loadDefaults()
        if entryPoint == "notification"
        {
            Global.messageRequestFromVC = "fakescreen"
            ServerManager.Instance.getUserDetail(userID: userId)
        }
        else
        {
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(nextVC), userInfo: nil, repeats: false)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Opens chat with the user. Used when the chat notification was selected and user profile was not fully available. This function is triggered based on server response of function triggered in `viewWillAppear`
     */
    @objc func chatVC()
    {
        entryPoint = ""
        let name = Global.profileCache[userId]?.firstName
        let picUrl = Global.profileCache[userId]?.picUrl.first
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.messageToNum = userId
        chatVC.messageToName = name
        chatVC.picUrl = picUrl
        chatVC.messageToDeviceType = Global.profileCache[userId]?.deviceType
        chatVC.messageToToken = Global.profileCache[userId]?.firebaseToken
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    /**
     Decides next view controller to display based on the login state of user
     */
    @objc func nextVC()
    {
        if Global.myProfile == nil {
            Global.user = TribeUser(fromDictionary: [:])
            
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(loginVC, animated: true)
        } else {
            let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            self.navigationController?.pushViewController(dashboardVC, animated: true)
        }
    }
    
    /**
     Loads saved user data from UserDefaults, if user was already logged in.
     */
    func loadDefaults()
    {
        if UserDefaults.standard.object(forKey: "v") == nil || UserDefaults.standard.integer(forKey: "v") != 2 {
            UtilManager.logoutUser()
            UserDefaults.standard.set(2, forKey: "v")
        }
        
        if UserDefaults.standard.object(forKey: "myProfile") != nil {
            if let serverProfile = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "myProfile") as? Data)!) as? TribeNUser) {
                Global.myProfile = serverProfile
                
                ServerManager.Instance.getUserData(phoneNumber: Global.myProfile.phone)
                ServerManager.Instance.getUserDetail(userID: Global.myProfile.id)
                ServerManager.Instance.getAllMessages()
                ServerManager.Instance.getTribe()
                ServerManager.Instance.getTribeMatches()
            } else {
                Global.myProfile = nil
            }
            
            if UserDefaults.standard.object(forKey: "contacts") != nil {
                if let contacts = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "contacts") as? Data)!) as? TribeNContacts) {
                    Global.serverContacts = contacts
                }
            }
            
            if UserDefaults.standard.object(forKey: "myTribe") != nil {
                if let tribeData = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "myTribe") as? Data)!) as? TribeNTribeData) {
                    Global.myTribe = tribeData
                }
            }
            
            if UserDefaults.standard.object(forKey: "tribeMatches") != nil {
                if let tribeMatchesData = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "tribeMatches") as? Data)!) as? [TribeNTribeMember]) {
                    Global.tribeMatches = tribeMatchesData
                }
            }
            
            if UserDefaults.standard.object(forKey: "profileCache") != nil {
                if let profileCache = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "profileCache") as? Data)!) as? [String:TribeNUser]) {
                    Global.profileCache = profileCache
                }
            }
            
            if UserDefaults.standard.object(forKey: "blockList") != nil {
                if let blockList = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "blockList") as? Data)!) as? [String]) {
                    Global.blockList = blockList
                }
            }
            
            if UserDefaults.standard.object(forKey: "deletedIds") != nil {
                if let deletedUserIds = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "deletedIds") as? Data)!) as? [String]) {
                    Global.deletedUserIds = deletedUserIds
                }
            }
        } else {
            Global.user = nil
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

