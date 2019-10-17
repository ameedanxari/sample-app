//
//  ChatVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import IQKeyboardManager
import JSQMessagesViewController
class ChatVC: JSQMessagesViewController, messageReceivedDelegate {
    
    
    @IBOutlet weak var lblNoUser: UILabel!
    //MARK: - Variables
    private var messages = [JSQMessage]();
    var messageToNum: String!
    var messageToName: String!
    var picUrl: String!
    var messageToDeviceType: String!
    var messageToToken: String!
    var chatType: String!
    var tapGestureRecognizer : UITapGestureRecognizer!
    var userFound = true
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        self.navigationItem.title = messageToName
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.tribe_purple
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.tribe_purple, NSAttributedString.Key.font.rawValue: UIFont.tribe_heading!])
        self.navigationController?.isNavigationBarHidden = false
        collectionView.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        self.senderId = messageToNum
        self.senderDisplayName = messageToName
        
        ServerManager.Instance.delegate = self
        ServerManager.Instance.observeMessages(messageTo: messageToNum, id: Global.myProfile.id)
        
        if userFound == false{
            UtilManager.showAlertMessage(message: "This user account has been deleted.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userFound == false{
            self.inputToolbar.isTranslucent = false
            self.inputToolbar.isUserInteractionEnabled = false
            self.inputToolbar.contentView.textView.placeHolder = "You cannot reply to this conversation"
        }
        else{
            tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.openProfile(_:)))
            let tapableView = UIView(frame: CGRect(x: 80, y: 0, width: view.frame.width - 80, height: 50))
            tapableView.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.addSubview(tapableView)
            tapableView.addGestureRecognizer(tapGestureRecognizer)
            tapableView.tag = 484 //cuz awein!
            
            self.navigationController?.navigationBar.isHidden = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        UtilManager.dismissGlobalHUD()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       ServerManager.Instance.messageRead(messageTo: messageToNum!)
        
        for view in (self.navigationController?.navigationBar.subviews)! {
            if view.tag == 484 {
                view.removeFromSuperview()
            }
        }
    }
    
    /**
     Opens the action sheet with options to view user profile and block the user.
     
     - Parameter theObject:   UIButton triggering the action sheet.
     */
    @objc func openProfile(_ theObject: AnyObject){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View Profile", style: .default , handler:{ (UIAlertAction)in
            if let profile = Global.profileCache[self.messageToNum] {
                let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
                profileVC.currentProfile = TribeNMatchable(fromDictionary: profile.toDictionary())
                profileVC.isChatHidden = true
                self.navigationController?.pushViewController(profileVC, animated: true)
            } else {
                //#BYPASSED
                //do something for users whose object is not available
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Block", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Block button")
            
            Global.blockList.append(self.messageToNum)
            ServerManager.Instance.deleteChat(messageTo: self.messageToNum, id: Global.myProfile.id)
            self.navigationController?.popViewController(animated: false)
            UtilManager.showBlockMessageDialog()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    //MARK: - JSQMessagesViewController Delegates
    /**
     Delegate method from JSQMessagesViewController. Sends the chat message.
     
     - Parameter sender:   UIButton triggering the event.
     */
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        if Reachability.isConnectedToNetwork()
        {
            ServerManager.Instance.sendMessage(messageTo: messageToNum, messageTime: Double(Date().timeIntervalSince1970), message: text, messageName: messageToName, picUrl: picUrl, type: chatType)
            ServerManager.Instance.sendPushNotification(name: Global.myProfile.firstName!, token: self.messageToToken ?? "", deviceType: self.messageToDeviceType, message: text, extraInfo: Global.myProfile.id!)
            finishSendingMessage()
        }
        else
        {
            UtilManager.showAlertMessage(message: "Message failed to send because of network issue. Please try again.")
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        if message.senderId == self.senderId
        {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.tribe_purple)
        }
        else
        {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.tribe_bg_grey)
            
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let i = indexPath.item
        let message = self.messages[i]
        let prevMessage: JSQMessage? = (i - 1 > 0) ? self.messages[i - 1] : nil
        
        guard let previousMessage = prevMessage else { return kJSQMessagesCollectionViewCellLabelHeightDefault }
        
        // Set a condition for stacking messages here
        if previousMessage.date != message.date
            && message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let date = self.messages[indexPath.item].date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date!)
        let convertedDate = formatter.date(from: dateString)
        let convertedDateString = String.timeAgoSinceDate(date: convertedDate! as NSDate, numericDates: false)
        return NSAttributedString(string: convertedDateString)
    }
    
    //MARK: - Custom Delegates
    /**
     Delegate method from Firebase. Recieves confirmation of message being sent.
     
     - Parameter messageTo:   User ID of the person sending the message.
     - Parameter messageTime:   Time of message in seconds since 1970.
     - Parameter Message:   Text of the message.
     */
    func messageReceived(messageTo: String, messageTime: Double, Message: String) {
        let date = Date(timeIntervalSince1970: messageTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        //print(dateString)
        messages.append(JSQMessage(senderId: messageTo, senderDisplayName: senderDisplayName ?? "", date: formatter.date(from: dateString), text: Message))
        
        //messages.append(JSQMessage(senderId: messageTo, displayName: senderDisplayName ?? "", text: Message))
        collectionView.reloadData()
        
        let item = self.collectionView(collectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
    }
  
    /**
     Overriding touch event delegate to dismiss keyboard when tapped anywhere on the screen outside the text view for send message.
     
     - Parameter touches:   Set containing touch points.
     - Parameter event:   Event triggered by the touch.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
