//
//  DashboardVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import Contacts

class DashboardVC: UIViewController, UITabBarDelegate {

     // MARK: - Variables
     var itemDater: UITabBarItem = UITabBarItem()
    
     // MARK: - Outlets
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var itemMyTribe: UITabBarItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemRingOfFire: UITabBarItem!
    @IBOutlet weak var itemMessages: UITabBarItem!
   
     // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getContacts()
        
        //Calling notification for Adding MessagesVC
        NotificationCenter.default.addObserver(self, selector: #selector(addingMessagesVC), name: NSNotification.Name(rawValue: "addingMessagesVC"), object: nil)
        
        //Calling notification for Adding ProfileVC
        NotificationCenter.default.addObserver(self, selector: #selector(addingProfileVC), name: NSNotification.Name(rawValue: "addingProfileVC"), object: nil)
        
        //Calling notification for Adding AlbumPictureVC
        NotificationCenter.default.addObserver(self, selector: #selector(addingAlbumPictureVC), name: NSNotification.Name(rawValue: "addingAlbumPictureVC"), object: nil)
        
        //Calling notification for Adding FacebookAlbumVC
        NotificationCenter.default.addObserver(self, selector: #selector(addingFacebookAlbumVC), name: NSNotification.Name(rawValue: "addingFacebookAlbumVC"), object: nil)
        
        //Calling notification for Adding MyContacts VC
        NotificationCenter.default.addObserver(self, selector: #selector(addMyContactsVC), name: NSNotification.Name(rawValue: "addMyContactsVC"), object: nil)
        
        //Calling notification to add or remove dater tabbarItem
        NotificationCenter.default.addObserver(self, selector: #selector(daterTab), name: NSNotification.Name(rawValue: "daterTab"), object: nil)
        
        //Calling notification for Adding Swipe VC
        NotificationCenter.default.addObserver(self, selector: #selector(addingSwipeVC), name: NSNotification.Name(rawValue: "addingSwipeVC"), object: nil)
        
        //Calling notification for Adding Tribe Swipe VC
        NotificationCenter.default.addObserver(self, selector: #selector(addingTribeSwipeVC), name: NSNotification.Name(rawValue: "addingTribeSwipeVC"), object: nil)
        
        //Calling notification for match made!
        NotificationCenter.default.addObserver(self, selector: #selector(matchMade), name: NSNotification.Name(rawValue: "matchMade"), object: nil)
        
        //Calling notification to logout user if account deleted!
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: "logout"), object: nil)
        
        //Calling notification if new chat
        NotificationCenter.default.addObserver(self, selector: #selector(newChat), name: NSNotification.Name(rawValue: "newChat"), object: nil)
        
        //Calling notification if new ring of fire data
        NotificationCenter.default.addObserver(self, selector: #selector(newRingOfFire), name: NSNotification.Name(rawValue: "newRingOfFire"), object: nil)
        
        //Calling notification if new ring of fire data
        NotificationCenter.default.addObserver(self, selector: #selector(newMyTribe), name: NSNotification.Name(rawValue: "newMyTribe"), object: nil)
        
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Helvetica", size: 12)!]), for: .normal)
        tabBar.delegate = self
        tabBar.selectedItem = itemMyTribe

        if Global.myProfile?.settings?.dater == true {
            //adding tab bar item dater
            itemDater = UITabBarItem(title: "", image: UIImage(named: "icon_dater_normal"), selectedImage: nil)
            itemDater.tag = 3
            itemDater.titlePositionAdjustment.vertical = 0
            tabBar.items?.append(itemDater)
        }
        if self.children.last == nil
        {
            let myTribeVC = self.storyboard?.instantiateViewController(withIdentifier: "MyTribeVC") as! MyTribeVC
            addChildView(controller: myTribeVC)
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if !Reachability.isConnectedToNetwork()
        {
            UtilManager.showAlertMessage(message: "Pleae check your network connection")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Overriding touch event delegate to dismiss keyboard when tapped anywhere on the screen outside the textfield.
     
     - Parameter touches:   Set containing touch points.
     - Parameter event:   Event triggered by the touch.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
     // MARK: - TabBar delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        btnSettings.isSelected = false
        btnProfile.isSelected = false
        item.badgeValue = nil
        if item.tag == 0
        {
            itemMyTribe.title = "My Tribe"
            itemRingOfFire.title = nil
            itemMessages.title = nil
            Global.newTribeNotification = false
            itemMyTribe.badgeValue = nil
//            itemMyTribe.badgeValue = "•"
//            if #available(iOS 10.0, *) {
//                itemMyTribe.setBadgeTextAttributes([NSForegroundColorAttributeName: UIColor.tribe_bg_grey], for: .normal)
//                itemMyTribe.badgeColor = UIColor.clear
//            } else {
//                // Fallback on earlier versions
//            }
            
            if itemDater.tag == 3
            {
                itemDater.title = nil
            }
            
            UtilManager.updateData()
            //ServerManager.Instance.getUserDetail(userID: Global.myProfile.id)
            let myTribeVC = self.storyboard?.instantiateViewController(withIdentifier: "MyTribeVC") as! MyTribeVC
            
            addChildView(controller: myTribeVC)
            print("Tribe")
        }
        else if item.tag == 1
        {
            itemRingOfFire.title = "Ring of fire"
            itemMyTribe.title = nil
            itemMessages.title = nil
            itemRingOfFire.badgeValue = nil
            Global.newRingOfFireNotification = false
            if itemDater.tag == 3
            {
                itemDater.title = nil
            }
            
            UtilManager.updateData()
            let ringOfFireVC = self.storyboard?.instantiateViewController(withIdentifier: "RingOfFireVC") as! RingOfFireVC
            addChildView(controller: ringOfFireVC)
            print("Fire")
        }
        else if item.tag == 2
        {
            itemRingOfFire.title = nil
            itemMyTribe.title = nil
            if itemDater.tag == 3
            {
                itemDater.title = nil
            }
            
            itemMessages.title = "Chats"
            Global.newMatch = false
            
            UtilManager.updateData()
            let messagesVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
            addChildView(controller: messagesVC)
        }
        else if item.tag == 3
        {
            itemDater.title = "Dater"
            itemRingOfFire.title = nil
            itemMyTribe.title = nil
            itemMessages.title = nil
            Global.checkDater = true
            
            
            //ServerManager.Instance.getUserDetail(userID: Global.myProfile.id)
            let swipeVC = self.storyboard?.instantiateViewController(withIdentifier: "SwipeVC") as! SwipeVC
            addChildView(controller: swipeVC)
        }
    }
    
     // MARK: - Actions
    /**
     Opens the settings view controller.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnSettingsAction(_ sender: UIButton) {
        btnProfile.isSelected = false
        sender.isSelected = true
        
        tabBar.selectedItem = nil
        itemMyTribe.title = nil
        itemMessages.title = nil
        itemRingOfFire.title = nil
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        addChildView(controller: settingsVC)
    }
    
    /**
     Opens the user profile view controller.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnProfileAction(_ sender: UIButton) {
        btnSettings.isSelected = false
        sender.isSelected = true
        
        tabBar.selectedItem = nil
        itemMyTribe.title = nil
        itemMessages.title = nil
        itemRingOfFire.title = nil
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        addChildView(controller: profileVC)
    }
    
     // MARK: - Functions
    /**
     Adds a child view controller.
     
     - Parameter controller:   UIViewController to be added.
     */
    func addChildView(controller: UIViewController)
    {
        if children.last?.classForCoder == controller.classForCoder {
            return //dont push same VC twice
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.containerView?.layer.add(transition, forKey: nil)
        
        //load the view controller and add as child
        addChild(controller)
        
        //make sure that the child view controller's view is the right size
        controller.view.frame = containerView.bounds
        containerView.addSubview(controller.view)
        
        //you must call this at the end per Apple's documentation
        controller.didMove(toParent: self)
        
        children.forEach({
            if $0.classForCoder != controller.classForCoder {
                //if any of the other view controllers apart from the current one
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
        })
    }
    
    /**
     Removes the last child view controller.
     */
    func removeChildView() {
        if let lastVC = children.last {
            lastVC.willMove(toParent: nil)
            lastVC.view.removeFromSuperview()
            lastVC.removeFromParent()
        }
        
        if let lastVC = children.last {
            //you must call this at the end per Apple's documentation
            lastVC.didMove(toParent: self)
        } else {
            btnSettings.isSelected = false
            btnProfile.isSelected = false
            
            itemMyTribe.title = nil
            itemRingOfFire.title = "Ring of fire"
            itemMessages.title = nil
            
            if itemDater.tag == 3
            {
                itemDater.title = nil
            }
            
            UtilManager.dismissGlobalHUD()
            let ringOfFire = self.storyboard?.instantiateViewController(withIdentifier: "RingOfFireVC") as! RingOfFireVC

            addChildView(controller: ringOfFire)
            print("Fire")
        }
     }
    
    /**
     Adds or removes the dater tab from TabBar based on a Gloval variable value. Triggered from settings view controller.
     */
    @objc func daterTab()
    {
        if Global.myProfile?.settings?.dater == true {
            //adding tab bar item dater
            itemDater = UITabBarItem(title: "", image: UIImage(named: "icon_dater_normal"), selectedImage: nil)
            itemDater.tag = 3
            itemDater.titlePositionAdjustment.vertical = 0
            tabBar.items?.append(itemDater)
        }
        else
        {
            //removing tab bar item dater
            tabBar.items?.remove(at: 3)
            itemDater.tag = 5
        }
    }
    
    /**
     Adds the MyContacts view controller as a child view controller.
     */
    @objc func addMyContactsVC()
    {
        let myContactsVC = self.storyboard?.instantiateViewController(withIdentifier: "MyContactsVC") as! MyContactsVC
        addChildView(controller: myContactsVC)
    }
    
    /**
     Utility function to get all contacts from phone book and upload to server to get a list of friends already on Tribe.
     */
    func getContacts()
    {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> CoDate App to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactTypeKey] as? [CNKeyDescriptor] {
                let request = CNContactFetchRequest(keysToFetch: keysToFetch)
                
                do {
                    try store.enumerateContacts(with: request){
                        (contact, cursor) -> Void in
                        if !Global.localContactsArray.contains(contact){
                            Global.localContactsArray.append(contact)
                        }
//                        Global.contactsArray.removeAll()
                        for phone in contact.phoneNumbers {
                            Global.localContacts[phone.value.stringValue.replacingOccurrences(of: "[()+#\\s-]", with: "", options: .regularExpression, range: nil)] = contact
                            Global.contactsArray.append(phone.value.stringValue.replacingOccurrences(of: "[()+*#\\s-]", with: "", options: .regularExpression, range: nil))
                        }
                    }
                    self.sortContacts()
                } catch let error {
                    UtilManager.showAlertMessage(message: "Fetch contact error: \(error)")
                }
                //send to server for checking and stuff!
                ServerManager.Instance.checkContacts(contacts: Global.contactsArray)
            } else {
                UtilManager.showAlertMessage(message: "Couldn't cast Contacts Data")
            }
        })
    }
    
    /**
     Utility function to sort contacts returned from server alphabetically.
     */
    func sortContacts(){
        if Global.serverContacts == nil{
            return
        }
        
        for contact in Global.serverContacts.matched
        {
            for localContact in Global.localContactsArray{
                if localContact.phoneNumbers.contains(where: {($0.value.stringValue.replacingOccurrences(of: "[()+\\s-]", with: "", options: .regularExpression, range: nil) == contact.phone)})
                {
                    let index = Global.localContactsArray.index(of: localContact)
                    Global.localContactsArray.remove(at: index!)
                }
            }
        }
        
        Global.localContactsArray = Global.localContactsArray.sorted { (first: CNContact, second: CNContact) -> Bool in
            first.givenName < second.givenName
        }
    }
    
    /**
     Adds the TribeSwipe view controller as a child view controller.
     */
    @objc func addingTribeSwipeVC()
    {
        let swipeVC = self.storyboard?.instantiateViewController(withIdentifier: "TribeSwipeVC") as! TribeSwipeVC
        addChildView(controller: swipeVC)
    }
    
    /**
     Adds the Swipe view controller as a child view controller.
     */
    @objc func addingSwipeVC()
    {
        let swipeVC = self.storyboard?.instantiateViewController(withIdentifier: "SwipeVC") as! SwipeVC
        addChildView(controller: swipeVC)
    }
    
    /**
     Adds the FacebookAlbum view controller as a child view controller.
     */
    @objc func addingFacebookAlbumVC()
    {
        let facebookAlbumVC = self.storyboard?.instantiateViewController(withIdentifier: "FacebookAlbumVC") as! FacebookAlbumVC
        addChildView(controller: facebookAlbumVC)
    }
    
    /**
     Adds the AlbumPicture view controller as a child view controller.
     */
    @objc func addingAlbumPictureVC()
    {
        let albumPictureVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumPictureVC") as! AlbumPictureVC
        addChildView(controller: albumPictureVC)
    }
    
    /**
     Adds the MyProfile view controller as a child view controller.
     */
    @objc func addingProfileVC()
    {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        addChildView(controller: profileVC)
    }
    
    /**
     Pushes the MatchMade view controller when a match notification is recieved.
     */
    @objc func matchMade()
    {
        let matchVC = self.storyboard?.instantiateViewController(withIdentifier: "MatchMadeVC") as! MatchMadeVC
        self.navigationController?.pushViewController(matchVC, animated: true)
    }
    
    /**
     Logs out the user.
     */
    @objc func logout(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /**
     Adds the Messages view controller as a child view controller.
     */
    @objc func addingMessagesVC() {
        btnSettings.isSelected = false
        btnProfile.isSelected = false
        
        itemRingOfFire.title = nil
        itemMyTribe.title = nil
        if itemDater.tag == 3
        {
            itemDater.title = nil
        }
        itemMessages.title = "Chats"
        
        tabBar.selectedItem = itemMessages
        
        let messagesVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
        addChildView(controller: messagesVC)
    }
    
    /**
     Adds a notification `dot` on the Chats tab in TabBar when a new chat notification is recieved.
     */
    @objc func newChat(){
        //Global.newChat = true
        if itemMessages.badgeValue == nil{
            itemMessages.badgeValue = "•"
            if #available(iOS 10.0, *) {
                itemMessages.setBadgeTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.tribe_purple]), for: .normal)
                itemMessages.badgeColor = UIColor.clear
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /**
     Adds a notification `dot` on the Chats tab in TabBar when a new ring of fire notification is recieved.
     */
    @objc func newRingOfFire(){
        if itemRingOfFire.badgeValue == nil{
            itemRingOfFire.badgeValue = "•"
            if #available(iOS 10.0, *) {
                itemRingOfFire.setBadgeTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.tribe_purple]), for: .normal)
                itemRingOfFire.badgeColor = UIColor.clear
            } else {
                // Fallback on earlier versions
            }
        }
    }

    /**
     Adds a notification `dot` on the Chats tab in TabBar when a new tribe notification is recieved.
     */
    @objc func newMyTribe(){
        if itemMyTribe.badgeValue == nil{
            itemMyTribe.badgeValue = "•"
            if #available(iOS 10.0, *) {
                itemMyTribe.setBadgeTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.tribe_purple]), for: .normal)
                itemMyTribe.badgeColor = UIColor.clear
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
