//
//  MessagesVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, lastMessageReceivedDelegate {
    
    
    @IBOutlet weak var tblMessages: UITableView!
    
    var messageTo : String!
    var tappedUserId: String!
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerManager.Instance.lastMessageDelegate = self
        Global.messageRequestFromVC = "messagesvc"
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushChatVC), name: NSNotification.Name(rawValue: "pushChatVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTables), name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
        
        if Global.newMatch == true{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newChat"), object: nil)
        }
        
        
        tblMessages.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Sorts user matches and gets profile detail for the chat users.
     
     - Parameter animated:   Decides whether the view loading should be animated or not.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        ServerManager.Instance.getUserDetail(userID: Global.myProfile.id)
        
        //ServerManager.Instance.getAllMessages()
        
        //sort matches
        if Global.myProfile.matches == nil {
            Global.myProfile.matches = []
        }
        Global.myProfile.matches = Global.myProfile.matches.sorted(by: { Date().timeIntervalSince(Date.getDateFromString(string: $0.matchedDate)) > Date().timeIntervalSince(Date.getDateFromString(string: $1.matchedDate)) })
        
        tblMessages.bounces = Global.lastMessage.count != 0
        
        if Global.myProfile.matches != nil {
            for match in Global.myProfile.matches{
                if Global.deletedUserIds.contains(match.matcher){
                    let index = Global.myProfile.matches.index(of: match)
                    Global.myProfile.matches.remove(at: index!)
                }
            }
        }
        
    }
    
    /**
     Updates the UI when a new message is recieved on chats
     */
    func lastMessageReceived() {
        tblMessages.bounces = Global.lastMessage.count != 0
        
        Global.lastMessage = Global.lastMessage.sorted { (first: users, second: users) -> Bool in
            first.tim > second.tim
        }
        
        tblMessages.reloadData()
    }
    
    // MARK: - TableView Delegates and DataSoruce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && Global.myProfile.matches?.count ?? 0 != 0
        {
            return 1
        }
        else
        {
            if Global.lastMessage.count == 0 {
                return 1
            }
            return Global.lastMessage.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && Global.myProfile.matches?.count ?? 0 != 0
        {
            return "Matches Queue"
        }
        else
        {
            return "Chats"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if Global.myProfile.matches?.count ?? 0 == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && Global.myProfile.matches?.count ?? 0 != 0
        {
            let messagesMatchesTCell = tableView.dequeueReusableCell(withIdentifier: "MessagesMatchesTCell") as! MessagesMatchesTCell
            
            messagesMatchesTCell.imgBg.isHidden = Global.myProfile.matches?.count ?? 0 != 0
            //messagesMatchesTCell.lblDetail.isHidden = Global.myProfile.matches?.count ?? 0 != 0
            messagesMatchesTCell.cvMatchesQueue.delegate = self
            messagesMatchesTCell.cvMatchesQueue.dataSource = self
            messagesMatchesTCell.cvMatchesQueue.tag = indexPath.row
            if Global.myProfile.matches?.count == 0
            {
                messagesMatchesTCell.lblDetail.isHidden = true
            }
            else
            {
                  messagesMatchesTCell.lblDetail.isHidden = false
            }
            return messagesMatchesTCell
        }
        else
        {
            let messagesChatsTCell = tableView.dequeueReusableCell(withIdentifier: "MessagesChatsTCell") as! MessagesChatsTCell
            messagesChatsTCell.imgBg.isHidden = Global.lastMessage.count != 0
            messagesChatsTCell.vwMessage.isHidden = Global.lastMessage.count == 0
            
            
            if Global.lastMessage.count != 0 {
                //get user profile if not cached already
                if Global.profileCache[Global.lastMessage[indexPath.row].ID] == nil {
                    ServerManager.Instance.getUserDetail(userID: Global.lastMessage[indexPath.row].ID)
                }
                //display and format messages
                if Global.lastMessage[indexPath.row].st == "false"
                {
                    messagesChatsTCell.lblNewMessage.textColor = UIColor.tribe_purple
                    messagesChatsTCell.vwDot.isHidden = false
                    messagesChatsTCell.lblNewMessage.text = Global.lastMessage[indexPath.row].msg
                    messagesChatsTCell.lblName.font = UIFont.tribe_txt_Bold
                    messagesChatsTCell.lblName.text = Global.lastMessage[indexPath.row].na
                    var imgURL = Global.lastMessage[indexPath.row].pic
                    if (imgURL.starts(with: "public")) {
                        imgURL = imgURL.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                    }
                    messagesChatsTCell.imgProfile.sd_setShowActivityIndicatorView(true)
                    messagesChatsTCell.imgProfile.sd_setIndicatorStyle(.gray)
                    messagesChatsTCell.imgProfile.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "graydient"))
                }
                else
                {
                    messagesChatsTCell.lblNewMessage.textColor = UIColor.tribe_purple
                    messagesChatsTCell.vwDot.isHidden = true
                    messagesChatsTCell.lblName.font = UIFont.tribe_txt_heading
                    messagesChatsTCell.lblName.text = Global.lastMessage[indexPath.row].na
                    var imgURL = Global.lastMessage[indexPath.row].pic
                    if (imgURL.starts(with: "public")) {
                        imgURL = imgURL.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                    }
                    messagesChatsTCell.imgProfile.sd_setShowActivityIndicatorView(true)
                    messagesChatsTCell.imgProfile.sd_setIndicatorStyle(.gray)
                    messagesChatsTCell.imgProfile.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "graydient"))
                    messagesChatsTCell.lblNewMessage.text = Global.lastMessage[indexPath.row].msg
                }
                
                
                if let matchType = Global.lastMessage[indexPath.row].type, matchType == "match" {
                    messagesChatsTCell.imgProfile.borderColor = UIColor.tribe_theme_orange.cgColor
                } else {
                    messagesChatsTCell.imgProfile.borderColor = UIColor.tribe_purple.cgColor
                }
            }
            
            return messagesChatsTCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Global.lastMessage.count == 0 {
            return
        }
        
        tappedUserId = Global.lastMessage[indexPath.row].ID
        
        if Global.profileCache[tappedUserId!] == nil {
            if !Global.deletedUserIds.contains(tappedUserId!){
                UtilManager.showGlobalProgressHUDWithTitle("")
                ServerManager.Instance.getUserDetail(userID: tappedUserId!)
            }
            else{
                let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                chatVC.messageToNum = tappedUserId
                chatVC.messageToName = Global.lastMessage[indexPath.row].na
                chatVC.picUrl = ""
                chatVC.messageToDeviceType = ""
                chatVC.messageToToken = ""
                chatVC.userFound = false
                self.navigationController?.pushViewController(chatVC, animated: true)
                //UtilManager.showAlertMessage(message: "User not found")
            }
            
        } else {
            if let matchType = Global.lastMessage[indexPath.row].type, matchType == "match" {
                pushChatVCWith(chatType: "match")
            } else {
                pushChatVC()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .white
        header.textLabel?.textColor = UIColor.tribe_purple
        header.textLabel?.font = UIFont.tribe_heading
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.lastMessage.count == 0 && Global.myProfile.matches?.count ?? 0 == 0 {
            return tableView.frame.height - 40 //40 + 40 - section headers ; 120 - match queue cell height
        }
        if Global.lastMessage.count == 0 && indexPath.section == 1 {
            return tableView.frame.height - 200 //40 + 40 - section headers ; 120 - match queue cell height
        }
        return UITableView.automaticDimension
    }
    // MARK: - CollectionView Delegates and DataSoruce
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Global.myProfile.matches?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let messagesMatchesQueueCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessagesMatchesQueueCCell", for: indexPath) as! MessagesMatchesQueueCCell
        
        messagesMatchesQueueCCell.remainingTime = Constants.MATCH_QUEUE_TIMER - Int(Date().timeIntervalSince(Date.getDateFromString(string: Global.myProfile.matches[indexPath.row].matchedDate)))
        messagesMatchesQueueCCell.startTimer()
        
        if let matchedProfile = Global.profileCache[Global.myProfile.matches[indexPath.row].matcher] {
            if var imgURL = matchedProfile.picUrl?.first {
                if imgURL.starts(with: "public") {
                    imgURL = imgURL.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                }
                messagesMatchesQueueCCell.imgMatches.sd_setShowActivityIndicatorView(true)
                messagesMatchesQueueCCell.imgMatches.sd_setIndicatorStyle(.gray)
                messagesMatchesQueueCCell.imgMatches.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "graydient"))
            } else {
                messagesMatchesQueueCCell.imgMatches.image = UIImage(named: "profile_normal_90")
            }
            
            if let userName = matchedProfile.firstName.components(separatedBy: " ") as? [String]{
                let firstName = userName[0]
                let lastName = userName[1].first
                messagesMatchesQueueCCell.lblName.text = firstName + " \(lastName!)"
                
            }
            else{
                messagesMatchesQueueCCell.lblName.text = matchedProfile.firstName
            }
            
            
            //#BYPASSED
            messagesMatchesQueueCCell.btnLikes.setTitle("0", for: .normal)
            messagesMatchesQueueCCell.btnDislikes.setTitle("0", for: .normal)
            messagesMatchesQueueCCell.btnLikes.setTitle(String(Global.myProfile.matches[indexPath.row].liked.count), for: .normal)
            messagesMatchesQueueCCell.btnDislikes.setTitle(String(Global.myProfile.matches[indexPath.row].disliked.count), for: .normal)
            
        } else {
            messagesMatchesQueueCCell.imgMatches.image = UIImage(named: "profile_normal_90")
            messagesMatchesQueueCCell.lblName.text = ""
        }
        
        return messagesMatchesQueueCCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Constants.MATCH_QUEUE_TIMER - Int(Date().timeIntervalSince(Date.getDateFromString(string: Global.myProfile.matches[indexPath.row].matchedDate))) > 0 {
            
            var matchId  = Global.myProfile.matches[indexPath.row].matcher
            
            if let profile = Global.profileCache[matchId!] {
                UtilManager.showGlobalProgressHUDWithTitle("")
                
                let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
                profileVC.isChatHidden = true
                
                profileVC.currentProfile = TribeNMatchable(fromDictionary: profile.toDictionary())
                
                (self.parent as! DashboardVC).addChildView(controller: profileVC)
                
                UtilManager.dismissGlobalHUD()
            } else {
                //#BYPASSED
                //do something for users whose object is not available
            }
            //            UtilManager.showAlertMessage(message: "You can only chat with your match after the ring of fire completes. To chat immediately, please upgrade your subscription.")
        } else {
            tappedUserId = Global.myProfile.matches[indexPath.row].matcher
            if Global.profileCache[tappedUserId!] == nil {
                if !Global.deletedUserIds.contains(tappedUserId!){
                    UtilManager.showGlobalProgressHUDWithTitle("")
                    ServerManager.Instance.getUserDetail(userID: tappedUserId!)
                }
                else{
                    let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                    chatVC.messageToNum = tappedUserId
                    chatVC.messageToName = ""
                    chatVC.picUrl = ""
                    chatVC.messageToDeviceType = ""
                    chatVC.messageToToken = ""
                    chatVC.userFound = false
                    self.navigationController?.pushViewController(chatVC, animated: true)
                    //UtilManager.showAlertMessage(message: "User not found")
                }
                
            } else {
                pushChatVCWith(chatType: "match")
            }
        }
    }
    
    /**
     Opens the chat VC. Uses the parameter to decide if the chat is with a match of with a tribe user
     
     - Parameter chatType:   String that differentiates between chat user and tribe user. Possible values `match` and `` (empty)
     */
    func pushChatVCWith(chatType:String!)
    {
        if tappedUserId == nil {
            return
        }
        
        let name = Global.profileCache[tappedUserId]?.firstName
        let phoneNumber = Global.profileCache[tappedUserId]?.phone
        let picUrl = Global.profileCache[tappedUserId]?.picUrl.first
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.messageToNum = tappedUserId
        chatVC.messageToName = name
        chatVC.picUrl = picUrl
        chatVC.chatType = chatType
        chatVC.messageToDeviceType = Global.profileCache[tappedUserId]?.deviceType
        chatVC.messageToToken = Global.profileCache[tappedUserId]?.firebaseToken
        self.navigationController?.pushViewController(chatVC, animated: true)
        //pushed, now nothing else required
        tappedUserId = nil
    }
    
    /**
     Opens the chat VC.
     */
    @objc func pushChatVC()
    {
        if tappedUserId == nil {
            return
        }
        
        let name = Global.profileCache[tappedUserId]?.firstName
        let phoneNumber = Global.profileCache[tappedUserId]?.phone
        let picUrl = Global.profileCache[tappedUserId]?.picUrl.first
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.messageToNum = tappedUserId
        chatVC.messageToName = name
        chatVC.picUrl = picUrl
        //chatVC.userFound = true
        chatVC.messageToDeviceType = Global.profileCache[tappedUserId]?.deviceType
        chatVC.messageToToken = Global.profileCache[tappedUserId]?.firebaseToken
        self.navigationController?.pushViewController(chatVC, animated: true)
        //pushed, now nothing else required
        tappedUserId = nil
    }
    
    /**
     Reloads the messages TableView UI when a new message is recieved. Triggered via notification.
     */
    @objc func reloadTables()
    {
        tblMessages.reloadData()
    }
    
    
}

