//
//  RingOfFireVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class RingOfFireVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
     // MARK: - Outlets
    @IBOutlet weak var tblRingOfFire: UITableView!
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if Global.newRingOfFireNotification == true{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newRingOfFire"), object: nil)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global.likesDisLikesIndex = 0
        
        ServerManager.Instance.getTribeMatches()
        
        self.navigationController?.navigationBar.isHidden = true
        //Calling notification to reload TableView
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTables), name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
    }
    
    /**
     Overriding touch event delegate to dismiss keyboard when tapped anywhere on the screen outside the textfield.
     
     - Parameter touches:   Set containing touch points.
     - Parameter event:   Event triggered by the touch.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - TableVIew Delegates and DataSource
    /**
     Reloads the TableView UI when new matches are recieved. Triggered via notifications.
     */
    @objc func reloadTables()
    {
        for user in Global.tribeMatches{
            for match in user.addedBy.matches{
                if Global.deletedUserIds.contains(match.matcher){
                    let index = user.addedBy.matches.index(of: match)
                    user.addedBy.matches.remove(at: index!)
                }
            }
        }
        
        tblRingOfFire.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.tribeMatches.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let ringOfFireTextTCell = tableView.dequeueReusableCell(withIdentifier: "RingOfFireTextTCell") as! RingOfFireTextTCell
            return ringOfFireTextTCell
        }
        else
        {
            let ringOfFireFriendsTCell = tableView.dequeueReusableCell(withIdentifier: "RingOfFireFriendsTCell") as! RingOfFireFriendsTCell
           
            ringOfFireFriendsTCell.lblName.text = (Global.tribeMatches[indexPath.row - 1].addedBy.firstName)!
            
            var imgURL = Global.tribeMatches[indexPath.row - 1].addedBy.picUrl.first
            if (imgURL?.starts(with: "public"))! {
                imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            ringOfFireFriendsTCell.imgProfile.sd_setShowActivityIndicatorView(true)
            ringOfFireFriendsTCell.imgProfile.sd_setIndicatorStyle(.gray)
            ringOfFireFriendsTCell.imgProfile.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            
            ringOfFireFriendsTCell.collecFriends.delegate = self
            ringOfFireFriendsTCell.collecFriends.dataSource = self
            ringOfFireFriendsTCell.collecFriends.tag = indexPath.row - 1
            ringOfFireFriendsTCell.btnProfile.tag = indexPath.row - 1
            
            ringOfFireFriendsTCell.collecFriends.reloadData()
            
            return ringOfFireFriendsTCell
        }
    }

     // MARK: - CollectionView Delegates and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        return Global.tribeMatches[index].addedBy.matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ringOfFireFriendsCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RingOfFireFriendsCCell", for: indexPath) as! RingOfFireFriendsCCell
        
        let index = collectionView.tag
        let tribeMatch = Global.tribeMatches[index]
        
        let minutesAgo = Date.getMinutesAgoFromString(string: (tribeMatch.addedBy.matches[indexPath.row].matchedDate)!)
        
        //checking for time validity
        if minutesAgo == -1 || minutesAgo > Constants.RING_OF_FIRE_TIMER { //minutes in a day = 24 * 60 = 1440
            ringOfFireFriendsCCell.alpha = 0.6
            ringOfFireFriendsCCell.isUserInteractionEnabled = false
        } else {
            ringOfFireFriendsCCell.alpha = 1.0
            ringOfFireFriendsCCell.isUserInteractionEnabled = true
        }
        //handling/displaying my feedback
        if tribeMatch.addedBy.matches[indexPath.row].iLiked == nil {
            ringOfFireFriendsCCell.btnLikeDislike.isHidden = true
        } else if tribeMatch.addedBy.matches[indexPath.row].iLiked == true {
            ringOfFireFriendsCCell.alpha = 0.6
            ringOfFireFriendsCCell.btnLikeDislike.isHidden = false
            ringOfFireFriendsCCell.btnLikeDislike.setImage(UIImage(named: "thumbs_up"), for: .normal)
        } else if tribeMatch.addedBy.matches[indexPath.row].iLiked == false {
            ringOfFireFriendsCCell.alpha = 0.6
            ringOfFireFriendsCCell.btnLikeDislike.isHidden = false
            ringOfFireFriendsCCell.btnLikeDislike.setImage(UIImage(named: "thumbs_down"), for: .normal)
        }
        //loading the picture of match
        if let matcherProfile = Global.profileCache[(tribeMatch.addedBy.matches[indexPath.row].matcher)!] {
            var imgURL = matcherProfile.picUrl.first
            if (imgURL?.starts(with: "public"))! {
                imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            ringOfFireFriendsCCell.imgFriend.sd_setShowActivityIndicatorView(true)
            ringOfFireFriendsCCell.imgFriend.sd_setIndicatorStyle(.gray)
            ringOfFireFriendsCCell.imgFriend.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
        } else {
            ringOfFireFriendsCCell.imgFriend.image = UIImage(named: "profile_normal_90")
            ringOfFireFriendsCCell.isUserInteractionEnabled = false
        }
        
        //#BYPASSED
//        ringOfFireFriendsCCell.isUserInteractionEnabled = true
        return ringOfFireFriendsCCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //#BYPASSED
        //setup the next VC for tribe pictures
        let index = collectionView.tag
        Global.currentTribeMatch = Global.tribeMatches[index]
        if Global.currentTribeMatch.addedBy.matches[indexPath.row].iLiked != nil {
            UtilManager.showAlertMessage(message: "You have already rated this match, upgrade to premium to change past ratings")
        }
        else{
            let currentTribeMatch = TribeNMatchable(fromDictionary: (Global.profileCache[(Global.currentTribeMatch.addedBy.matches[indexPath.row].matcher)!]?.toDictionary())!)
            
            Global.tribeSwipeList = [currentTribeMatch]
            Global.currentTribeMatchable = 0
            
            //To add Swipe VC in dashboard goto DahsboardVC
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addingTribeSwipeVC"), object: nil)
            
            print (collectionView.tag)
            print (indexPath.row)
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
    
    /**
     Opens the profile of the selected friend.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func openFriendProfile(_ sender: UIButton) {
        UtilManager.showGlobalProgressHUDWithTitle("")
        
        var friendId  = Global.tribeMatches[sender.tag].addedBy.id
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        
        if let profile = Global.profileCache[friendId!] {
            profileVC.currentProfile = TribeNMatchable(fromDictionary: profile.toDictionary())
        } else {
            profileVC.currentProfile = TribeNMatchable(fromDictionary: Global.tribeMatches[sender.tag].addedBy.toDictionary())
        }
        (self.parent as! DashboardVC).addChildView(controller: profileVC)
        
        UtilManager.dismissGlobalHUD()
    }
    
}
