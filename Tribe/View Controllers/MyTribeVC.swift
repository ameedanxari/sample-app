//
//  MyTribeVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class MyTribeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    // MARK: - Outlets
    @IBOutlet weak var tblMyTribe: UITableView!
    @IBOutlet weak var vwNoTribe: UIView!
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling notification to reload TableView
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTables), name: NSNotification.Name(rawValue: "reloadTables"), object: nil)
        
        if Global.newTribeNotification == true{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMyTribe"), object: nil)
        }
        
        tblMyTribe.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        ServerManager.Instance.getTribe()
        
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
    
    // MARK: - TableView Delegates and DataSoruce
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 //Add more friends button
        {
            return tableView.dequeueReusableCell(withIdentifier: "first")!
        }
        else if indexPath.section == 1 //incoming requests
        {
            if Global.myTribe.requestedForTribe.count > 0
            {
                let myTribeRequestTCell = tableView.dequeueReusableCell(withIdentifier: "MyTribeRequestTCell") as! MyTribeRequestTCell
                myTribeRequestTCell.btnAccept.tag = indexPath.row
                myTribeRequestTCell.btnReject.tag = indexPath.row
                
                if Global.myTribe.requestedForTribe[indexPath.row].isUpdating == true {
                    myTribeRequestTCell.stkButtons.isHidden = true
                    myTribeRequestTCell.activityIndicator.isHidden = false
                    myTribeRequestTCell.activityIndicator.startAnimating()
                } else {
                    myTribeRequestTCell.stkButtons.isHidden = false
                    myTribeRequestTCell.activityIndicator.isHidden = true
                }
                
                myTribeRequestTCell.lblName.text = "\((Global.myTribe.requestedForTribe?[indexPath.row].addedBy?.firstName)!) \((Global.myTribe.requestedForTribe?[indexPath.row].addedBy?.lastName)!)"
                if let imgURL = Global.myTribe.requestedForTribe?[indexPath.row].addedBy?.picUrl?.first {
                    var imgURLFinal = imgURL
                    if (imgURL.starts(with: "public")) {
                        imgURLFinal = imgURL.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                    }
                    myTribeRequestTCell.imgUser.sd_setShowActivityIndicatorView(true)
                    myTribeRequestTCell.imgUser.sd_setIndicatorStyle(.gray)
                    myTribeRequestTCell.imgUser.sd_setImage(with: URL(string: imgURLFinal ), placeholderImage: UIImage(named: "graydient"))
                } else {
                    myTribeRequestTCell.imgUser.image = UIImage(named: "profile_normal_90")
                }
                
                return myTribeRequestTCell
            }
        }
        //existing tribe members
        let myTribeMatchesTCell = tableView.dequeueReusableCell(withIdentifier: "MyTribeMatchesTCell") as! MyTribeMatchesTCell
        myTribeMatchesTCell.btnViewProfile.tag = indexPath.row
        myTribeMatchesTCell.lblName.text = "\((Global.myTribe.mytribe?[indexPath.row].added?.firstName)!) \((Global.myTribe.mytribe?[indexPath.row].added?.lastName)!)"
        myTribeMatchesTCell.swRating.tag = indexPath.row
        if Global.myTribe.mytribe?[indexPath.row].active == false{
            myTribeMatchesTCell.swRating.isOn = false
        }
        else{
            myTribeMatchesTCell.swRating.isOn = true
        }
        
        
        if let imgURL = Global.myTribe.mytribe?[indexPath.row].added?.picUrl?.first {
            var imgURLFinal = imgURL
            if (imgURL.starts(with: "public")) {
                imgURLFinal = imgURL.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            myTribeMatchesTCell.imgUser.sd_setShowActivityIndicatorView(true)
            myTribeMatchesTCell.imgUser.sd_setIndicatorStyle(.gray)
            myTribeMatchesTCell.imgUser.sd_setImage(with: URL(string: imgURLFinal), placeholderImage: UIImage(named: "graydient"))
        } else {
            myTribeMatchesTCell.imgUser.image = UIImage(named: "profile_normal_90")
        }
        //hiding switch if dater profile is off
        if Global.myProfile?.settings?.dater == true {
            myTribeMatchesTCell.showRatingSwitch()
        } else {
            myTribeMatchesTCell.hideRatingSwitch()
        }
        
        return myTribeMatchesTCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if Global.myTribe.requestedForTribe.count == 0 && Global.myTribe.mytribe.count == 0
        {
            vwNoTribe.isHidden = false
            return 1
        }
        else if Global.myTribe.requestedForTribe.count > 0 && Global.myTribe.mytribe.count > 0
        {
            vwNoTribe.isHidden = true
            return 3
        }
        
        vwNoTribe.isHidden = true
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 //Add more friends button
        {
            return 1
        }
        else if section == 1 //incoming requests
        {
            if Global.myTribe.requestedForTribe.count > 0
            {
                if Global.myTribe.requestedForTribe.count < 3
                {
                    return Global.myTribe.requestedForTribe.count
                }
                else
                {
                    return 3
                }
            }
        }
        //existing tribe members
        return Global.myTribe.mytribe.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0
        {
            return ""
        }
        else if section == 1
        {
            if Global.myTribe.requestedForTribe.count > 0
            {
                return "Tribe Requests"
            }
        }
        return "My Tribe"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .white
        header.textLabel?.textColor = UIColor.tribe_purple
        header.textLabel?.font = UIFont.tribe_heading
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0
        {
            return false
        }
        else if indexPath.section == 1
        {
            if Global.myTribe.requestedForTribe.count > 0
            {
                return false
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //deleting the tribe user
            ServerManager.Instance.respondToTribeRequest(user_id: Global.myTribe.mytribe[indexPath.row].added.id, action: 0)
            Global.myTribe.mytribe.remove(at: indexPath.row)
            
            if Global.myTribe.mytribe.count == 0 {
                tblMyTribe.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                tblMyTribe.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
        }
    }
    
    // MARK: - Actions
    /**
     Opens the add contacts view controller.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnAddContactsAction(_ sender: UIButton) {
        //To add Mycontacts VC to Parent goto dashboard
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addMyContactsVC"), object: nil)
    }
    
    /**
     Accept the tribe request.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnAcceptRequestAction(_ sender: UIButton) {
        //add logic to move to other list and reload table
        Global.myTribe.requestedForTribe[sender.tag].isUpdating = true
        ServerManager.Instance.respondToTribeRequest(user_id: Global.myTribe.requestedForTribe[sender.tag].addedBy.id, action: 1)
        tblMyTribe.reloadData()
    }
    
    /**
     Reject the tribe request.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnRejectRequestAction(_ sender: UIButton) {
        ServerManager.Instance.respondToTribeRequest(user_id: Global.myTribe.requestedForTribe[sender.tag].addedBy.id, action: 0)
        Global.myTribe.requestedForTribe.remove(at: sender.tag)

        if Global.myTribe.requestedForTribe.count == 0 {
            tblMyTribe.deleteSections(IndexSet(integer: 1), with: .automatic)
        } else {
            tblMyTribe.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
        
        
    }
    
    /**
     Opens the profile of the selected tribe member.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnViewProfileAction(_ sender: UIButton) {
        UtilManager.showGlobalProgressHUDWithTitle("")
        
        var friendId  = Global.myTribe.mytribe?[sender.tag].added?.id
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        
        if let profile = Global.profileCache[friendId!] {
            profileVC.currentProfile = TribeNMatchable(fromDictionary: profile.toDictionary())
        } else {
            profileVC.currentProfile = TribeNMatchable(fromDictionary: (Global.myTribe.mytribe?[sender.tag].added?.toDictionary())!)
        }
        (self.parent as! DashboardVC).addChildView(controller: profileVC)
        
        UtilManager.dismissGlobalHUD()
    }
    
    /**
     Activates/Deactivates tribe rating permission. Triggered by toggle of rating switch.
     
     - Parameter sender:   UISwitch triggering the event.
     */
    @IBAction func swPermissionAction(_ sender: UISwitch) {
        if sender.isOn{
            Global.myTribe.mytribe?[sender.tag].active = true
        }
        else{
            Global.myTribe.mytribe?[sender.tag].active = false
        }
        ServerManager.Instance.blockTribe(friendId: (Global.myTribe.mytribe?[sender.tag].added.id)!, status: sender.isOn)
    }
    
    /**
     Reloads the TableView UI when new tribe data is recieved. Triggered via notifications.
     */
    @objc func reloadTables()
    {
        tblMyTribe.reloadData()
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
