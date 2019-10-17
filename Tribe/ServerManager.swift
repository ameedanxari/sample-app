//
//  ServerManager.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import Alamofire
import ContactsUI
protocol messageReceivedDelegate: class {
    func messageReceived(messageTo: String,messageTime: Double, Message: String)
    
}

protocol lastMessageReceivedDelegate: class {
    func lastMessageReceived()
    
}

class ServerManager {
    
    private static let _instance = ServerManager()
    weak var delegate: messageReceivedDelegate?
    weak var lastMessageDelegate: lastMessageReceivedDelegate?
    static var Instance: ServerManager
    {
        return _instance
    }
    
    
    var notificationRef: DatabaseReference
    {
        return Database.database().reference().child("Notifications")
    }
    
    var userRef: DatabaseReference
    {
        return Database.database().reference().child(Constants.users)
    }
    
    var chatRef: DatabaseReference
    {
        return Database.database().reference().child(Constants.chats)
    }
    
    func registerUser(phoneNumber: String, name: String, email: String, age:String, gender: String, picUrl: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        let nodes = [Constants.phoneNumber: phone, Constants.name: name, Constants.email: email, Constants.age: age, Constants.gender: gender, Constants.picUrl: picUrl]
        userRef.child(phoneNumber).setValue(nodes)
        //post notification for Registration goto LoginVC
        ServerManager.Instance.getUserData(phoneNumber: phoneNumber)
    }
    
    func getUserData(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        userRef.child(phone).observe(DataEventType.value) { (snapShot: DataSnapshot) in
            if let data = snapShot.value as? NSDictionary
            {
                Global.user = TribeUser(fromDictionary: data as! [String : Any])
                Global.arrimg.append(Global.user.picUrl!)
                self.getUserRequest(phoneNumber: phoneNumber)
                self.getUserSendRequest(phoneNumber: phoneNumber)
                self.getUserMatches(phoneNumber: phoneNumber)
                //#CACHE#
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.user)
                UserDefaults.standard.set(encodedData, forKey: "user")
                
                print (Global.user)
            }
        }
    }
    
    func getUserRequest(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(phone).child(Constants.request).observe(DataEventType.value, with: { (snapShot: DataSnapshot) in
            
            if let data = snapShot.value as? NSDictionary
            {
                for (key ,value) in data
                {
                    if !Global.user.request.contains(value as! String)
                    {
                        Global.user.request.append(value as! String)
                        self.otherUserData(phoneNumber: value as! String)
                    }
                }
                print (Global.user.request)
                
            }
        })
        
    }
    func getUserSendRequest(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(phone).child(Constants.sendRequest).observeSingleEvent(of: DataEventType.value, with: { (snapShot: DataSnapshot) in
            
            if let sendRequest = snapShot.value as? NSDictionary
            {
                for (key, value) in sendRequest
                {
                    if !Global.user.sendRequest.contains(value as! String)
                    {
                        Global.user.sendRequest.append(value as! String)
                    }
                    
                }
            }
        })
        
    }
    func getUserMatches(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(phone).child(Constants.matches).observe(DataEventType.value, with: { (snapShot: DataSnapshot) in
            
            if let matches = snapShot.value as? NSDictionary
            {
                for (key, value) in matches
                {
                    if !Global.user.mactches.contains(key as! String)
                    {
                        Global.user.mactches.append(key as! String)
                        Global.key.append(key as! String)
                        self.getLikes(phoneNumber: key as! String)
                        self.getDislikes(phoneNumber: key as! String)
                        self.getMatchesUsersData(phoneNumber: key as! String)
                    }
                }
                
            }
        })
        
    }
    
    func getMatchesUsersData(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(phone).observeSingleEvent(of: DataEventType.value, with: { (snapShot: DataSnapshot) in
            
            if let user = snapShot.value as? NSDictionary
            {
                let userData = TribeUser(fromDictionary: user as! [String : Any])
                
                if Global.matches.contains(where: { $0.phoneNumber == userData.phoneNumber })
                {
                    
                    print("Already in Memmory array")
                }
                else{
                    Global.matches.append(userData)
                    self.otherFriendMatches(phoneNumber: phoneNumber)
                    //Globals.arrMemories.append(values)
                }
            }
            //To reload tableVIew goto MytibeVC
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadtblMyTribe"), object: nil)
        })
        
    }
    func updateProfile(parameterName: String, parameterValue: String)
    {
        let nodes = [parameterName: parameterValue]
        userRef.child(Global.user.phoneNumber).updateChildValues(nodes)
        getUserData(phoneNumber: Global.user.phoneNumber)
    }
    
    func sendRequest(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        let randomID = userRef.database.reference().childByAutoId()
        let randomAutoID = randomID.key
        
        userRef.child(phone).child(Constants.request).child(randomAutoID).setValue(Global.user.phoneNumber)
        
        userRef.child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.sendRequest).childByAutoId().setValue(phoneNumber)
    }
    
    func getAllPhoneNumber()
    {
        userRef.observeSingleEvent(of: DataEventType.value) { (snapShot : DataSnapshot) in
            if let data = snapShot.value
            {
                for (key, value) in (data as? NSDictionary)!
                {
                    Global.tribesPhonenumber.append(key as! String)
                    if Global.user.phoneNumber != key as? String
                    {
                        self.getAllUser(phoneNumber: key as! String)
                    }
                }
            }
        }
    }
    
    func getAllUser(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(phone).observe(DataEventType.value) { (snapShot: DataSnapshot) in
            if let user = snapShot.value as? NSDictionary
            {
                
                let userData = TribeUser(fromDictionary: user as! [String : Any])
                if (userData.dater == "Yes" && !Global.user.sendRequest.contains(phone)) && (userData.dater == "Yes" && !Global.user.request.contains(phone)) &&  (userData.dater == "Yes" && !Global.user.mactches.contains(phone))
                {
                    Global.otherUser.append(userData)
                    Global.valueArray.append(userData.picUrl)
                }
            }
        }
    }
    
    func otherUserData(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(phone).observeSingleEvent(of: DataEventType.value, with: { (snapShot: DataSnapshot) in
            if let user = snapShot.value as? NSDictionary
            {
                let userData = TribeUser(fromDictionary: user as! [String : Any])
                
                if Global.request.contains(where: { $0.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) == userData.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) })
                {
                    
                    print("Already in Memmory array")
                }
                else{
                    Global.request.append(userData)
                    // Globals.arrMemories.append(values)
                }
            }
            //To reload tableVIew goto MytibeVC
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadtblMyTribe"), object: nil)
        })
    }
    
    func requestAccept (phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        let values = [Constants.phoneNumber: Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)]
        let values2 = [Constants.phoneNumber: phone]
        userRef.child(phoneNumber).child(Constants.matches).child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).setValue(values)
        userRef.child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.matches).child(phone).setValue(values2)
        removeRequest(phoneNumber: phone)
        
    }
    
    
    func removeRequest(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.request).observeSingleEvent(of: DataEventType.value, with: { (snapShot: DataSnapshot) in
            if let data = snapShot.value as? NSDictionary
            {
                for (key ,value) in data
                {
                    if value as! String == phone
                    {
                        self.userRef.child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.request).child(key as! String).removeValue()
                        
                        let index = Global.request.index(where: { $0.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) == value as! String })
                        Global.request.remove(at: index!)
                        
                        
                        self.removeSendRequest(phoneNumber: phone)
                    }
                }
            }
        })
    }
    
    func removeSendRequest(phoneNumber: String)
    {
        //phone number cleanup
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        
        userRef.child(phone).child(Constants.sendRequest).observeSingleEvent(of: DataEventType.value, with: { (snapShot: DataSnapshot) in
            
            if let data = snapShot.value as? NSDictionary
            {
                for (key ,value) in data
                {
                    if value as! String == Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
                    {
                        self.userRef.child(phone).child(Constants.sendRequest).child(key as! String).removeValue()
                    }
                }
            }
        })
    }
    
    func sendMessage(messageTo: String, messageTime: Double, message: String, messageName: String, picUrl: String, type:String!)
    {
        let data: Dictionary<String, Any> = [Constants.MESSAGE: message, Constants.MESSAGE_TO: messageTo, Constants.MESSAGE_TIME: messageTime]
        
        
        let lastmessageData: Dictionary<String, Any> = [Constants.MESSAGE: message, Constants.LAST_MESSAGE_DATE: messageTime, Constants.READ_STATUS: "true", Constants.name: messageName, Constants.picUrl: picUrl, Constants.userid: messageTo]
        
        let lastmessageDataTo: Dictionary<String, Any> = [Constants.MESSAGE: message, Constants.LAST_MESSAGE_DATE: messageTime, Constants.READ_STATUS: "false", Constants.name: Global.myProfile.firstName, Constants.picUrl: Global.myProfile.picUrl[0], Constants.userid: Global.myProfile.id]
        
        //my node
        chatRef.child(Global.myProfile.id).child(Constants.chats).child(Global.myProfile.id + "_" + messageTo).child(Constants.allMessages).childByAutoId().setValue(data)
        
        chatRef.child(Global.myProfile.id).child(Constants.chats).child(Global.myProfile.id + "_" + messageTo).child(Constants.LAST_MESSAGE).setValue(lastmessageData)
        
        //other person node
        chatRef.child(messageTo).child(Constants.chats).child(messageTo + "_" + Global.myProfile.id).child(Constants.allMessages).childByAutoId().setValue(data)
        
        chatRef.child(messageTo).child(Constants.chats).child(messageTo + "_" + Global.myProfile.id).child(Constants.LAST_MESSAGE).setValue(lastmessageDataTo)
        
        //keeping track of whether the chat started as a match or not
        if type != nil {
            chatRef.child(messageTo).child(Constants.chats).child(messageTo + "_" + Global.myProfile.id).child(Constants.IS_MATCH_CHAT).setValue(type)
            chatRef.child(Global.myProfile.id).child(Constants.chats).child(Global.myProfile.id + "_" + messageTo).child(Constants.IS_MATCH_CHAT).setValue(type)
        }
    }
    
    
    func deleteChat(messageTo: String, id: String)
    {
        chatRef.child(id).child(Constants.chats).child(id + "_" + messageTo).removeValue()
        chatRef.child(id).child(Constants.chats).child(messageTo + "_" + id).removeValue()
    }
    
    func observeMessages(messageTo: String, id: String)
    {
        chatRef.child(id).child(Constants.chats).child(id + "_" + messageTo).child(Constants.allMessages).removeAllObservers()
        chatRef.child(id).child(Constants.chats).child(id + "_" + messageTo).child(Constants.allMessages).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            //   print(snapshot.key)
            
            if let data = snapshot.value as? NSDictionary
            {
                if let messageTo = data[Constants.MESSAGE_TO] as? String, let messageTime = data[Constants.MESSAGE_TIME] as? Double, let message = data[Constants.MESSAGE] as? String, id == Global.myProfile.id
                {
                    
                    self.delegate?.messageReceived(messageTo: messageTo, messageTime: messageTime, Message: message)
                }
            }
            
        }
    }
    
    
    func getAllMessages()
    {
        chatRef.child(Global.myProfile.id).child(Constants.chats).observe(DataEventType.value, with: { (snapshot: DataSnapshot) in
            if let messages = snapshot.value as? NSDictionary
            {
                
                for (key,value) in messages
                {
                    let messageData = value as? NSDictionary
                    if let lastMessageData = messageData![Constants.LAST_MESSAGE] as? NSDictionary
                    {
                        let name = lastMessageData[Constants.name] as! String
                        let time = lastMessageData[Constants.LAST_MESSAGE_DATE] as! Double
                        let userId = lastMessageData[Constants.userid] as! String
                        let picture = lastMessageData[Constants.picUrl] as! String
                        let readStatus = lastMessageData[Constants.READ_STATUS] as! String
                        let message = lastMessageData[Constants.MESSAGE] as! String
                        
                        let isMatchChat = messageData![Constants.IS_MATCH_CHAT] as? String
                        
                        let values = users.init(msg: message, tim: time, st: readStatus, na: name, pic: picture, id: userId, matchType: isMatchChat)
                        if readStatus == "false"{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newChat"), object: nil)
                        }
                        if Global.lastMessage.contains(where: { $0.ID == userId })
                        {
                            let index = Global.lastMessage.index(where: { $0.ID == userId })
                            Global.lastMessage.remove(at: index!)
                            Global.lastMessage.append(values)
                        }
                        else
                        {
                            Global.lastMessage.append(values)
                            
                        }
                        
                        self.lastMessageDelegate?.lastMessageReceived()
                    }
                }
            }
        })
    }
    
    func messageRead(messageTo: String)
    {
        chatRef.child(Global.myProfile.id).child(Constants.chats).child(Global.myProfile.id + "_" + messageTo).child(Constants.LAST_MESSAGE).observeSingleEvent(of: DataEventType.value) { (snapshot: DataSnapshot) in
            if (snapshot.value as? NSDictionary) != nil
            {
                let data = [Constants.READ_STATUS: "true"]
                self.chatRef.child(Global.myProfile.id).child(Constants.chats).child(Global.myProfile.id + "_" + messageTo).child(Constants.LAST_MESSAGE).updateChildValues(data)
            }
            else
            {
                return
            }
        }
    }
    
    func otherFriendMatches(phoneNumber: String)
    {
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        userRef.child(phone).child(Constants.matches).observe(DataEventType.value, with: { (snapShot: DataSnapshot) in
            
            if let matches = snapShot.value as? NSDictionary
            {
                for (key, value) in matches
                {
                    if Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) != key as! String
                    {
                        if !Global.user.otherFriendMatches.contains(key as! String)
                        {
                            Global.user.otherFriendMatches.append(key as! String)
                            self.getotherFriendMatchesData(phoneNumber: key as! String, friendNumber: phoneNumber)
                            
                        }
                    }
                }
            }
        })
    }
    
    func getotherFriendMatchesData(phoneNumber: String, friendNumber: String)
    {
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        userRef.child(phone).observeSingleEvent(of: DataEventType.value, with: { (snapShot: DataSnapshot) in
            if let user = snapShot.value as? NSDictionary
            {
                let userData = TribeUser(fromDictionary: user as! [String : Any])
                
                if Global.otherUserMatches.contains(where: { $0.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) == userData.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) })
                {
                    print("Already in Memmory array")
                }
                else{
                    
                    Global.testHashMap.updateValue([userData], forKey: friendNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil))
                    Global.otherUserMatches.append(userData)
                }
            }
        })
    }
    
    func vote(friendNumnber: String, voteNumber:String, status: String, to: String, from: String)
    {
        userRef.child(friendNumnber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.matches).child(voteNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(status).child(from).childByAutoId().setValue(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil))
        
        userRef.child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.matches).child(friendNumnber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(status).child(to).childByAutoId().setValue(voteNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil))
    }
    
    func getLikes(phoneNumber: String)
    {
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        userRef.child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.matches).child(phone).child("Like").child("LikedTo").observe(DataEventType.value) { (snapShot: DataSnapshot) in
            if let users = snapShot.value as? NSDictionary
            {
                for (key, value) in users
                {
                    if !Global.user.likes.contains(value as! String)
                    {
                        Global.user.likes.append(value as! String)
                    }
                }
            }
        }
    }
    
    func getDislikes(phoneNumber: String)
    {
        var phone = phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
        userRef.child(Global.user.phoneNumber.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)).child(Constants.matches).child(phone).child("Dislike").child("DisLikedBy").observe(DataEventType.value) { (snapShot: DataSnapshot) in
            if let users = snapShot.value as? NSDictionary
            {
                for (key, value) in users
                {
                    if !Global.user.disLikes.contains(value as! String)
                    {
                        Global.user.disLikes.append(value as! String)
                    }
                }
            }
        }
    }
    
    func getFacebookAlbum()
    {
        
//        FBSDKGraphRequest(graphPath: "/me/albums", parameters: ["fields":"id,name,user_photos"], httpMethod: "GET").start(completionHandler: {  (connection, result, error) in
//
//            Global.facebookAlbum = TribeFacebookAlbumResponse(fromDictionary: result! as! [String : Any])
//
//            print (Global.facebookAlbum.name)
//            //To reload tableVIew goto FacebookAlbumVC
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "realodtblAlbum"), object: nil)
//
//
//        })
        
        GraphRequest(graphPath: "/me?", parameters: ["fields":"id,name,albums.limit(10000){photo_count,name,picture}"], httpMethod: HTTPMethod(rawValue: "GET")).start(completionHandler: {  (connection, result, error) in

            Global.facebookAlbum = TribeFacebookAlbumResponse(fromDictionary: result! as! [String : Any])

            print (Global.facebookAlbum.name)
            //To reload tableVIew goto FacebookAlbumVC
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "realodtblAlbum"), object: nil)

        })
    }
    
    func getAlbumPictures(albumId: String)
    {
        GraphRequest(graphPath: "/"+albumId, parameters: ["fields":"photos.limit(1000){images,picture}"], httpMethod: HTTPMethod(rawValue: "GET")).start(completionHandler: {  (connection, result, error) in
            
            Global.albumPictures  = AlbumsPicturesResponse(fromDictionary: result! as! [String : Any])
            
            print (Global.albumPictures)
            
            //To reload CollectionView goto AlbumPicturesVC
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollecPictures"), object: nil)
        })
    }
    
    func sendPushNotification(name: String, token: String, deviceType: String, message: String, extraInfo: String)
    {
        let values = ["id": name, "token": token, "devicetype": deviceType, "message": message, "text": extraInfo]
        notificationRef.setValue(values)
    }
    
    //MARK:- Node Server API Calls
    func checkInternetConnectivity() {
        //let url = "https://creatrixe.co/checkInternetConnectivity.php?app=tribe"
        let url = "https://bit.ly/2JygLNr"
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200: //success
                        //to get JSON return value
                        if let result = response.result.value {
                            if Constants.IS_DEBUG, let jdict = result as? NSDictionary {
                                print(jdict)
                            }
                        } else {
                            UserDefaults.standard.set(nil, forKey: "myProfile")
                        }
                    default:
                        UserDefaults.standard.set(nil, forKey: "myProfile")
                    }
                }
        }
    }
    
    func checkUser(phone: String, fb_id: String, fb_token: String)
    {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.Login.rawValue)"
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let params = ["phone":phone.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil), "fb_id":fb_id, "fb_token":fb_token]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            //serialize data into object, store to nsuserdefaults for future
                            Global.myProfile = TribeNUser(fromDictionary: jdict as! [String : Any])
                            
                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.myProfile)
                            UserDefaults.standard.set(encodedData, forKey: "myProfile")
                            UserDefaults.standard.synchronize()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginUserSuccess"), object: nil)
                    case 403, 406: //fb ID and phone number mismatch
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                UtilManager.showAlertMessage(message: message)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    case 404: //user not registered
                        self.uploadPictureFromURL(picUrl: Global.user.picUrl)
                    default:
                        UtilManager.dismissGlobalHUD()
                        //UtilManager.showAlertMessage(message: "Something went wrong!")
                        
                        let err = NSError(domain: "TribeAPILogin", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                         UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                   
                }
        }
    }
    
    func createUser(phone: String, name: String, email: String, age:String, gender: String, picUrl: String)
    {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.Register.rawValue)"
        let headers = ["Content-Type": "application/json"]
        let params:Parameters = ["phone":phone.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil),
                                 "fb_id":Global.fbID,
                                 "fb_token":Global.fbToken,
                                 "device_token":Global.deviceToken,
                                 "firebase_token": Global.firebaseToken,
                                 "device_type":"ios",
                                 "first_name":name,
                                 "last_name":"",
                                 "email":email,
                                 "gender":gender.capitalized,
                                 "age":age,
                                 "pic_url":[picUrl],
                                 "about_me":"",
                                 "intersted":[],
                                 "settings":[
                                    "dater":false,
                                    "dater_setting":[
                                        "age_range":[
                                            "min":18,
                                            "max":80
                                        ],
                                        "distance_range":30,
                                        "interested":"Everyone"
                                    ],
                                    "public_profile":true
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //login success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            
                            //serialize data into object, store to nsuserdefaults for future
                            Global.myProfile = TribeNUser(fromDictionary: jdict as! [String : Any])
                            
                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.myProfile)
                            UserDefaults.standard.set(encodedData, forKey: "myProfile")
                            UserDefaults.standard.synchronize()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginUserSuccess"), object: nil)
                    case 201: //create success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            //serialize data into object, store to nsuserdefaults for future
                            Global.myProfile = TribeNUser(fromDictionary: jdict as! [String : Any])
                            
                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.myProfile)
                            UserDefaults.standard.set(encodedData, forKey: "myProfile")
                            UserDefaults.standard.synchronize()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createUserSuccess"), object: nil)
                    case 415: //bad data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                UtilManager.showAlertMessage(message: message)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIRegister", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
    }
    
    func updateProfile(user: TribeNUser) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.Register.rawValue)\(user.id!)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        
        //some of the data cleanup
        user.deviceToken = Global.deviceToken
        user.firebaseToken = Global.firebaseToken
        user.deviceType = "ios"
        let params = user.toDictionaryForUpdate()
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //login success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            //serialize data into object, store to nsuserdefaults for future
                            Global.myProfile = TribeNUser(fromDictionary: jdict as! [String : Any])
                            
                            for user in Global.myProfile.matches {
                                self.getUserDetail(userID: user.matcher)
                            }
                            
                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.myProfile)
                            UserDefaults.standard.set(encodedData, forKey: "myProfile")
                            UserDefaults.standard.synchronize()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserSuccess"), object: nil)
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollections"), object: nil)
                    case 415: //bad data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                UtilManager.showAlertMessage(message: message)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIUpdateUser", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                         UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                   
                }
        }
    }
    
    func getUserDetail(userID: String) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.Register.rawValue)\(userID)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //login success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            //serialize data into object, store to nsuserdefaults for future
                            var user = TribeNUser(fromDictionary: jdict as! [String : Any])
                            if user.id == Global.myProfile.id {
                                
                                //deleting deleted users from new data to check count
                                for match in user.matches{
                                    if Global.deletedUserIds.contains(match.matcher){
                                        let index = user.matches.index(of: match)
                                        user.matches.remove(at: index!)
                                    }
                                }
                                
                                
                                if user.matches.count != Global.myProfile.matches.count{
                                    if Global.newMatch != true{
                                        Global.newMatch = true
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newChat"), object: nil)
                                    }
                                    
                                }
                                
                                Global.myProfile = user
                                Global.myProfile.firebaseToken = Global.firebaseToken
                                
                                for match in Global.myProfile.matches{
                                    if Global.deletedUserIds.contains(match.matcher){
                                        let index = Global.myProfile.matches.index(of: match)
                                        Global.myProfile.matches.remove(at: index!)
                                    }
                                }
                                
                                Global.profileCache[user.id] = user
                                
                                self.updateProfile(user: Global.myProfile)
                                
                                //#CACHE#
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.myProfile)
                                UserDefaults.standard.set(encodedData, forKey: "myProfile")
                                UserDefaults.standard.synchronize()
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollections"), object: nil)
                                
                            } else {
                                
                                Global.profileCache[user.id] = user
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollections"), object: nil)

                                
                                //#CACHE#
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.profileCache)
                                UserDefaults.standard.set(encodedData, forKey: "profileCache")
                                UserDefaults.standard.synchronize()
                                
                                if Global.messageRequestFromVC == "userprofile"
                                {
                                    //#Push Chat Controller#
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openChatVC"), object: nil)
                                }
                                else if Global.messageRequestFromVC == "fakescreen"
                                {
                                    //#Push Chat Controller#
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationChatVC"), object: nil)
                                }
                                else if Global.messageRequestFromVC == "userprofile"
                                {
                                    //#Push Chat Controller#
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushChatVC"), object: nil)
                                }
                                
                                
                            }
                        } else {
                            
                            if !Global.deletedUserIds.contains(userID){
                                Global.deletedUserIds.append(userID)
                            }

                            if Global.profileCache[userID] != nil{
                                Global.profileCache.removeValue(forKey: userID)
                            }
                            
                            for match in Global.myProfile.matches{
                                if match.matcher == userID{
                                    let index = Global.myProfile.matches.index(of: match)
                                    Global.myProfile.matches.remove(at: index!)
                                }
                            }
                           // self.updateProfile(user: Global.myProfile)

                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.deletedUserIds)
                            UserDefaults.standard.set(encodedData, forKey: "deletedIds")
                            UserDefaults.standard.synchronize()
                            
                           UtilManager.dismissGlobalHUD()
                            //UtilManager.showAlertMessage(message: "User deleted")
                        }
                    //self.getAllMessages()
                    case 404: //user deleted
                        
                        if userID == Global.myProfile.id{
                            UtilManager.logoutUser()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
                            
                        }
                        else{
                            if let result = response.result.value, let jdict = result as? NSDictionary {
                                if Constants.IS_DEBUG {
                                    print(jdict)
                                }
                                
                                Global.profileCache[userID] = nil
                                
                                //#CACHE#
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.profileCache)
                                UserDefaults.standard.set(encodedData, forKey: "profileCache")
                                UserDefaults.standard.synchronize()
                            }
                        }
                        
                        
                        UtilManager.dismissGlobalHUD()
                    case 415: //bad data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                UtilManager.showAlertMessage(message: message)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                               
                            } else {
                                if Constants.SHOW_ERRORS{
                                     UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                               
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                           
                        }
                        
                        let err = NSError(domain: "TribeAPIUpdateUser", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                   
                }
        }
    }
    
    func checkContacts(contacts: [String]) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.CheckContacts.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let contactString = contacts.joined(separator: ",")
        let params = ["phones": contactString]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //login success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            //serialize data into object, store to nsuserdefaults for future
                            Global.serverContacts = TribeNContacts(fromDictionary: jdict as! [String : Any])
                            
                            
                            for contact in Global.serverContacts.matched
                            {
                                for localContact in Global.localContactsArray{
                                    for number in localContact.phoneNumbers{
                                        let editedNumber =  number.value.stringValue.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil)
                                        print(editedNumber)
                                        let last10Local = String(editedNumber.characters.suffix(10))
                                        let last10Matched = String(contact.phone.characters.suffix(10))
                                        if last10Local == last10Matched{
                                            let index = Global.localContactsArray.index(of: localContact)
                                            Global.localContactsArray.remove(at: index!)
                                        }
                                    }
//                                    if localContact.phoneNumbers.contains(where: {($0.value.stringValue.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) == contact.phone)})
//                                    {
//
//                                    }
                                }
                            }
                            
                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.serverContacts)
                            UserDefaults.standard.set(encodedData, forKey: "contacts")
                            UserDefaults.standard.synchronize()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                    case 415: //bad data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                UtilManager.showAlertMessage(message: message)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }

                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }

                            
                        }
                        
                        let err = NSError(domain: "TribeAPIUpdateUser", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }

                    
                }
        }
    }
    
    func addToTribe(user_id: String) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.AddToTribe.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let params = ["userId": Global.myProfile.id!,
                      "user_name": Global.myProfile.firstName!,
                      "friendId": user_id]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 201: //add success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                    case 406: //bad data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIAddToTribe", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                    
                }
        }
    }
    
    func blockTribe(friendId: String, status: Bool) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.BlockUser.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let params: Parameters = ["userId": Global.myProfile.id!,
                      "friendId": friendId,
                      "active": status]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //value change success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                    case 406: //bad data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIAddToTribe", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
    }
    
    func getTribe() {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.GetTribe.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let params = ["userId": Global.myProfile.id!]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //login success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            let newData = TribeNTribeData(fromDictionary: jdict as! [String : Any])
                            if newData.requestedForTribe.count != Global.myTribe.requestedForTribe.count{
                                Global.newTribeNotification = true
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMyTribe"), object: nil)
                                
                            }
                            else if newData.mytribe.count != Global.myTribe.mytribe.count{
                                Global.newTribeNotification = true
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMyTribe"), object: nil)
                                
                            }
                            //serialize data into object, store to nsuserdefaults for future
                            Global.myTribe = TribeNTribeData(fromDictionary: jdict as! [String : Any])
                            
                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.myTribe)
                            UserDefaults.standard.set(encodedData, forKey: "myTribe")
                            UserDefaults.standard.synchronize()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                    case 404: //no tribe data
                        if let result = response.result.value {
                            if let jdict = result as? NSDictionary, Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            UserDefaults.standard.removeObject(forKey: "myTribe")
                            UserDefaults.standard.synchronize()
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                               
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIAddToTribe", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
    }
    
    func respondToTribeRequest(user_id: String, action: Int) {
        var url = ""
        if action == 1 {
            url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.AcceptTribe.rawValue)"
        } else {
            url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.RejectTribe.rawValue)"
        }
        
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        //from me to you
        var params:Parameters = ["userId": Global.myProfile.id!,
                                 "addedId": user_id,
                                 "action": action]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //add success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                        
                        self.getTribe()
                    case 406: //bad data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                        
                        self.getTribe()
                    default:
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                               
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIAddToTribe", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
        
        //from you to me - in case adding to tribe
//        if action == 1 {
//            let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.AddToTribe.rawValue)"
//            let headers = ["Content-Type": "application/json"]
//            let params = ["userId": Global.myProfile.id!,
//                          "friendId": user_id]
//
//            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
//                .responseJSON { response in
//                    //to get status code
//                    if let status = response.response?.statusCode {
//
//                        switch(status){
//                        case 201: //add success
//                            //to get JSON return value
//                            if let result = response.result.value, let jdict = result as? NSDictionary {
//                                if Constants.IS_DEBUG {
//                                    print(jdict)
//                                }
//                            }
//
//                            self.getTribe()
//                        case 406: //bad data
//                            if let result = response.result.value, let jdict = result as? NSDictionary {
//                                if Constants.IS_DEBUG {
//                                    print(jdict)
//                                }
//                            }
//
//                            UtilManager.dismissGlobalHUD()
//                        default:
//                            UtilManager.dismissGlobalHUD()
//                            if let result = response.result.value, let jdict = result as? NSDictionary {
//                                if Constants.IS_DEBUG {
//                                    print(jdict)
//                                }
//                                if let message = jdict["err"] as? String {
//                                    UtilManager.showAlertMessage(message: message)
//                                } else {
//                                    //UtilManager.showAlertMessage(message: "Something went wrong!")
//                                }
//                            } else {
//                                //UtilManager.showAlertMessage(message: "Something went wrong!")
//                            }
//
//                            let err = NSError(domain: "TribeAPIAddToTribe", code: status, userInfo: response.result.value as? [AnyHashable : Any])
//                            //                         Crashlytics.sharedInstance().recordError(err)
//                        }
//                    } else {
//                        UtilManager.dismissGlobalHUD()
//
//                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
//                    }
//            }
//        }
    }
    
    func uploadPictureFromURL(picUrl: String) {
        //download the image and upload it before creating the user
        if let url = URL(string: picUrl) {
            if let data = try? Data(contentsOf: url) {
                var picture = UIImage(data: data)!
                
                let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.UploadImage.rawValue)"
                //        let params = ["source": source]
                let headers:HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"]
                
                let imgData = picture.jpegData(compressionQuality: 1.0)!
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imgData, withName: "files",fileName: "file.jpg", mimeType: "image/jpg")
                }, to:url, headers: headers)
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            if Constants.IS_DEBUG {
                                print("Upload Progress: \(progress.fractionCompleted)")
                            }
                        })
                        
                        upload.responseJSON { response in
                            //to get status code
                            if let status = response.response?.statusCode {
                                
                                switch(status){
                                case 200: //success
                                    //to get JSON return value
                                    if let result = response.result.value {
                                        if Constants.IS_DEBUG, let jdict = result as? NSArray {
                                            print(jdict)
                                        }
                                    }
                                    
                                    if let imgURL = (response.result.value as? NSArray)?.firstObject as? String {
                                        Global.user.picUrl = imgURL
                                    }
                                    
                                    self.createUser(phone: Global.user.phoneNumber, name: Global.user.name, email: Global.user.email, age: Global.user.age, gender: Global.user.gender ?? "", picUrl: Global.user.picUrl)
                                default:
                                    UtilManager.dismissGlobalHUD()
                                    if let result = response.result.value, let jdict = result as? NSDictionary {
                                        if Constants.IS_DEBUG {
                                            print(jdict)
                                        }
                                        if let message = jdict["err"] as? String {
                                            if Constants.SHOW_ERRORS{
                                                UtilManager.showAlertMessage(message: message)
                                            }
                                            
                                        } else {
                                            if Constants.SHOW_ERRORS{
                                                UtilManager.showAlertMessage(message: "Something went wrong!")
                                            }
                                            
                                        }
                                    } else {
                                        if Constants.SHOW_ERRORS{
                                            UtilManager.showAlertMessage(message: "Something went wrong!")
                                        }
                                        
                                    }
                                    
                                    let err = NSError(domain: "TribeAPIUploadImage", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                                    //                         Crashlytics.sharedInstance().recordError(err)
                                }
                            } else {
                                UtilManager.dismissGlobalHUD()
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                                }
                                
                            }
                            
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
                
            } else {
                self.createUser(phone: Global.user.phoneNumber ?? "", name: Global.user.name ?? "", email: Global.user.email ?? "", age: Global.user.age ?? "", gender: Global.user.gender ?? "", picUrl: Global.user.picUrl ?? "")
            }
        } else {
            self.createUser(phone: Global.user.phoneNumber ?? "", name: Global.user.name ?? "", email: Global.user.email ?? "", age: Global.user.age ?? "", gender: Global.user.gender ?? "", picUrl: Global.user.picUrl ?? "")
        }
    }
    
    func uploadPicture(picture: UIImage, completion: @escaping (String) -> Void) {
        
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.UploadImage.rawValue)"
        let headers:HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"]
        let imgData = picture.jpegData(compressionQuality: 0.5)! //Reducing quality to reduce loading time
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "files",fileName: "file.jpg", mimeType: "image/jpg")
        }, to:url, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    if Constants.IS_DEBUG {
                        print("Upload Progress: \(progress.fractionCompleted)")
                    }
                })
                
                upload.responseJSON { response in
                    //to get status code
                    if let status = response.response?.statusCode {
                        
                        switch(status){
                        case 200: //success
                            //to get JSON return value
                            if let result = response.result.value {
                                if Constants.IS_DEBUG, let jdict = result as? NSDictionary {
                                    print(jdict)
                                }
                            }
                            
                            if let imgURL = (response.result.value as? NSArray)?.firstObject as? String {
                                Global.myProfile.picUrl.append(imgURL)
                                self.updateProfile(user: Global.myProfile)
                                completion("success")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
                            }
                        default:
                            //UtilManager.dismissGlobalHUD()
                            if let result = response.result.value, let jdict = result as? NSDictionary {
                                if Constants.IS_DEBUG {
                                    print(jdict)
                                }
                                if let message = jdict["err"] as? String {
                                    if Constants.SHOW_ERRORS{
                                        UtilManager.showAlertMessage(message: message)
                                    }
                                    
                                } else {
                                    if Constants.SHOW_ERRORS{
                                        UtilManager.showAlertMessage(message: "Something went wrong!")
                                    }
                                    
                                }
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                            completion("failure")
                            _ = NSError(domain: "TribeAPIUploadImage", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                            //                         Crashlytics.sharedInstance().recordError(err)
                        }
                    } else {
                        completion("failure")
                        UtilManager.dismissGlobalHUD()
                        if Constants.SHOW_ERRORS{
                            UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                        }
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                completion("failure")
                UtilManager.dismissGlobalHUD()
                print(encodingError)
            }
        }
    }
    
    func getMatchables(latitude: Double, longitude: Double) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.GetMatchables.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let params:Parameters = ["userId": Global.myProfile.id!,
                                 "lat": latitude,
                                 "lng": longitude]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //success
                        //to get JSON return value
                        if let result = response.result.value as? NSArray{
                            if Constants.IS_DEBUG {
                                print(result)
                            }
                            
                            Global.matchables = []

                            //#New One
                            //add new matchables to the queue
                            for matchable in result {
                                if let match = matchable as? NSDictionary{
                                    let matchableObject = TribeNMatchable(fromDictionary: match as! [String : Any])

                                    //checking in block list
                                    if !Global.blockList.contains(matchableObject.id) {
                                        Global.matchables.append(matchableObject)
                                    }
                                }
                                else{
                                    print("Null From Server")
                                }
                            }
                            
                            //#Old one
                            //add new matchables to the queue
//                            for matchable in result {
//
//                                    let matchableObject = TribeNMatchable(fromDictionary: matchable as! [String : Any])
//
//                                    //checking in block list
//                                    if !Global.blockList.contains(matchableObject.id) {
//                                        Global.matchables.append(matchableObject)
//                                    }
//
//                            }
                            
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                    case 404: //no tribe data
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                        
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                               
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIGetMatchables", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                    //reload whaterver be the case!
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "matchablesUpdated"), object: nil)
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
    }
    
    func sendJudgement(matchableId: String, isLike: Int) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.Judgement.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let params:Parameters = ["userId": Global.myProfile.id!,
                                 "swaperId": matchableId,
                                 "liked": isLike,
                                 "userName": Global.myProfile.firstName]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //add success
                        //to get JSON return value
                        if let result = response.result.value {
                            if let jdict = result as? NSDictionary{
                                if Constants.IS_DEBUG{
                                    print(jdict)
                                }
                            }
                            
                        }
                    case 201: //add success
                        //to get JSON return value
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            
                            //get object of the user with match
                            Global.matchMade = TribeNUser(fromDictionary: jdict as! [String : Any])
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "matchMade"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                        }
                    case 406: //bad data
                        //to get JSON return value
                        if let result = response.result.value {
                            if let jdict = result as? NSDictionary {
                                print(jdict)
                            }
                            
                            //get object of the user with match
                            //                            var matchData = (jdict["data"] as! NSArray).firstObject as! [String : Any]
                            
                            //                            Global.matchMade = TribeNUser(fromDictionary: matchData["user_to"] as! [String : Any])
                            //somehow figure out if it is a match!
                            //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "matchMade"), object: nil)
                        }
                    default:
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIMatchableSwipe", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
    }
    
    func getTribeMatches() {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.GetTribeMatches.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let params:Parameters = ["userId": Global.myProfile.id!]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //success
                        //to get JSON return value
                        if let result = response.result.value as? NSArray{
                            if Constants.IS_DEBUG {
                                print(result)
                            }
                            let oldTribeMatches = Global.tribeMatches
                            //reset tribe data
                            Global.tribeMatches = []
                            //add tribe results to the queue
                            for tribeMember in result {
                                let tribeMember = TribeNTribeMember(fromDictionary: tribeMember as! [String : Any])
                                
                                if let matchesList = tribeMember.addedBy?.matches {
                                    for matchUser in  matchesList {
                                        self.getUserDetail(userID: matchUser.matcher)
                                    }
                                    
                                    //add people with more than one matches
                                    //checking for block list
                                    if tribeMember.addedBy.matches.count > 0 && !Global.blockList.contains(tribeMember.id) && !Global.deletedUserIds.contains(tribeMember.id) {
                                        Global.tribeMatches.append(tribeMember)
                                    }
                                    
                                    
//                                    for match in Global.tribeMatches{
//                                        for user in match.addedBy.matches{
//                                            if user.id == Global.myProfile.id!{
//                                                let index = match.addedBy.matches.index(of: user)
//                                                match.addedBy.matches.remove(at: index!)
//                                            }
//                                        }
//                                    }
                                }
                            }
                            if oldTribeMatches.count != Global.tribeMatches.count{
                                Global.newRingOfFireNotification = true
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newRingOfFire"), object: nil)
                            }
                            //#CACHE#
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.tribeMatches)
                            UserDefaults.standard.set(encodedData, forKey: "tribeMatches")
                            UserDefaults.standard.synchronize()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                    case 404: //no tribe data
                        if let result = response.result.value {
                            if Constants.IS_DEBUG, let jdict = result as? NSDictionary {
                                print(jdict)
                            }
                            Global.tribeMatches.removeAll()
                            UserDefaults.standard.removeObject(forKey: "tribeMatches")
                            UserDefaults.standard.synchronize()
                        }
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                        UtilManager.dismissGlobalHUD()
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPIGetMatchables", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                    //reload whaterver be the case!
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "matchablesUpdated"), object: nil)
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
    }
    
    func sendTribeJudgement(tribeUserId: String, matcherId: String, isLike: Int) {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.TribeJudgement.rawValue)"
        let headers = ["Content-Type": "application/json", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        let params:Parameters = ["userId": Global.myProfile.id!,
                                 "tribeUserId": tribeUserId,
                                 "matcherId": matcherId,
                                 "swapped": isLike]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200: //add success
                        //to get JSON return value
                        if let result = response.result.value {
                            if let jdict = result as? NSDictionary, Constants.IS_DEBUG {
                                print(jdict)
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
                            self.getTribeMatches()
                        }
                    case 406: //bad data
                        if let result = response.result.value {
                            if let jdict = result as? NSDictionary, Constants.IS_DEBUG {
                                print(jdict)
                            }
                        }
                    default:
                        UtilManager.dismissGlobalHUD()
                        if let result = response.result.value, let jdict = result as? NSDictionary {
                            if Constants.IS_DEBUG {
                                print(jdict)
                            }
                            if let message = jdict["err"] as? String {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: message)
                                }
                                
                            } else {
                                if Constants.SHOW_ERRORS{
                                    UtilManager.showAlertMessage(message: "Something went wrong!")
                                }
                                
                            }
                        } else {
                            if Constants.SHOW_ERRORS{
                                UtilManager.showAlertMessage(message: "Something went wrong!")
                            }
                            
                        }
                        
                        let err = NSError(domain: "TribeAPITribeSwipe", code: status, userInfo: response.result.value as? [AnyHashable : Any] as! [String : Any])
                        //                         Crashlytics.sharedInstance().recordError(err)
                    }
                } else {
                    UtilManager.dismissGlobalHUD()
                    if Constants.SHOW_ERRORS{
                        UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
                    }
                    
                }
        }
    }
    
    func deleteUser() {
        let url = "\(TribeAPI.BaseURL.rawValue)\(TribeAPI.Register.rawValue)" + Global.myProfile.id
        let headers = ["Content-Type": "application/x-www-form-urlencoded", "authtoken": Global.myProfile.authToken!, "userid": Global.myProfile.id!]
        chatRef.child(Global.myProfile.id!).removeValue()
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
//                //to get status code
//                if let status = response.response?.statusCode {
//
//                    switch(status){
//                    case 200: //login success
//                        //to get JSON return value
//                        if let result = response.result.value {
//                            let jdict = result as! NSDictionary
//                            if Constants.IS_DEBUG {
//                                print(jdict)
//                            }
//
//                            //serialize data into object, store to nsuserdefaults for future
//                            var user = TribeNUser(fromDictionary: jdict as! [String : Any])
//                            if user.id == Global.myProfile.id {
//                                Global.myProfile = user
//                                Global.myProfile.firebaseToken = Global.firebaseToken
//                                self.updateProfile(user: Global.myProfile)
//                                //#CACHE#
//                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.myProfile)
//                                UserDefaults.standard.set(encodedData, forKey: "myProfile")
//                                UserDefaults.standard.synchronize()
//                            } else {
//                                Global.profileCache[user.id] = user
//
//                                //#CACHE#
//                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.profileCache)
//                                UserDefaults.standard.set(encodedData, forKey: "profileCache")
//                                UserDefaults.standard.synchronize()
//
//                                if Global.messageRequestFromVC == "userprofile"
//                                {
//                                    //#Push Chat Controller#
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openChatVC"), object: nil)
//                                }
//                                else if Global.messageRequestFromVC == "fakescreen"
//                                {
//                                    //#Push Chat Controller#
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationChatVC"), object: nil)
//                                }
//                                else
//                                {
//                                    //#Push Chat Controller#
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushChatVC"), object: nil)
//                                }
//
//
//                            }
//                        }
//                    //self.getAllMessages()
//                    case 415: //bad data
//                        if let result = response.result.value, let jdict = result as? NSDictionary {
//                            if Constants.IS_DEBUG {
//                                print(jdict)
//                            }
//                            if let message = jdict["err"] as? String {
//                                UtilManager.showAlertMessage(message: message)
//                            }
//                        }
//
//                        UtilManager.dismissGlobalHUD()
//                    default:
//                        UtilManager.dismissGlobalHUD()
//                        if let result = response.result.value, let jdict = result as? NSDictionary {
//                            if Constants.IS_DEBUG {
//                                print(jdict)
//                            }
//                            if let message = jdict["err"] as? String {
//                                UtilManager.showAlertMessage(message: message)
//                            } else {
//                                //UtilManager.showAlertMessage(message: "Something went wrong!")
//                            }
//                        } else {
//                            //UtilManager.showAlertMessage(message: "Something went wrong!")
//                        }
//
//                        let err = NSError(domain: "TribeAPIUpdateUser", code: status, userInfo: response.result.value as? [AnyHashable : Any])
//                        //                         Crashlytics.sharedInstance().recordError(err)
//                    }
//                } else {
//                    UtilManager.dismissGlobalHUD()
//
//                    UtilManager.showAlertMessage(message: (response.error?.localizedDescription)!)
//                }
        }
    }
}

enum TribeAPI: String
{
    case BaseURL           = "https://app.tribe-app.com"
    
    case Login                = "/users/login"
    case Register             = "/users/"
    case CheckContacts        = "/users/getMatchUnmatchList"
    case UploadImage          = "/users/uploads"
    case AddToTribe           = "/users/addTribe"
    case GetTribe             = "/users/getTribe"
//    case RemoveTribe          = "/users/removeTribe"
    case AcceptTribe          = "/users/acceptTribe"
    case RejectTribe          = "/users/removeTribe"
    case GetMatchables        = "/users/getMatchables"
    case Judgement            = "/users/swap"
    case GetTribeMatches      = "/users/getTribeMatches"
    case TribeJudgement       = "/users/MatchLikeDislike"
    case BlockUser            = "/users/blockUnblockTribe"
}
