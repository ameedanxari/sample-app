//
//  MyContactsVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import MessageUI
import Contacts

class MyContactsVC: UIViewController, UITabBarDelegate, UITableViewDataSource, UITextFieldDelegate, MFMessageComposeViewControllerDelegate,UITableViewDelegate {
    
    // MARK: - Variables
    var filteredContacts:TribeNContacts!
    var tblContactDetailsActive = false
    var contactDetail = [CNLabeledValue<CNPhoneNumber>]()
    var contactName = ""
    var selectedContactIdentifier = ""
    var filteredLocalContacts = [CNContact]()
    // MARK: - Outlets
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblMyContacts: UITableView!
    @IBOutlet weak var vwOverlay: UIView!
    @IBOutlet weak var tblContactDetails: UITableView!
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSearch.layer.borderWidth = 1
        txtSearch.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        txtSearch.layer.cornerRadius = txtSearch.frame.height / 2
        txtSearch.setLeftPaddingPoints(55)
        txtSearch.setRightPaddingPoints(0)
        txtSearch.delegate = self
        
        
        //adding touch gesture to dismiss table on vwOverlay
        vwOverlay.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissTable(gesture:)))
        vwOverlay.addGestureRecognizer(tapGesture)
        
        tblContactDetails.layer.cornerRadius = 10
        tblContactDetails.isHidden = true
        
        
        tblContactDetails.dataSource = self
        tblContactDetails.delegate = self
        vwOverlay.isHidden = true
    }
    
    
    /**
     Filters and remoevs contacts already in MyTribe. Sorts contacts by name.
     
     - Parameter animated:   Decides whether the view loading should be animated or not.
     */
    override func viewWillAppear(_ animated: Bool) {
        if Global.serverContacts != nil{
            for data in Global.myTribe.mytribe
            {
                if Global.serverContacts.matched.contains(where: {$0.id == data.added.id}) {
                    let index = Global.serverContacts.matched.index(where: { $0.id == data.added.id})
                    Global.serverContacts.matched.remove(at: index!)
                }
                else if Global.serverContacts.matched.contains(where: {$0.id == data.addedBy.id}) {
                    let index = Global.serverContacts.matched.index(where: { $0.id == data.addedBy.id})
                    Global.serverContacts.matched.remove(at: index!)
                }
            }
        }
        
        
        let myNumber = Global.myProfile?.phone
        if Global.serverContacts != nil{
            if Global.serverContacts.matched.contains(where: {$0.phone == myNumber}){
                let index = Global.serverContacts.matched.index(where: { $0.phone == myNumber})
                Global.serverContacts.matched.remove(at: index!)
            }
        }
        
        Global.localContactsArray = Global.localContactsArray.sorted { (first: CNContact, second: CNContact) -> Bool in
            first.givenName < second.givenName
        }
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        //#CACHE#
        //        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.invitedContacts)
        //        UserDefaults.standard.set(encodedData, forKey: "invitedContacts")
        //        UserDefaults.standard.synchronize()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0{
            return 40
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 0{
            if section == 0
            {
                return "Friends on CoDate"
            }
            return "Invite Friends"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactHeaderTCell") as! ContactHeaderTCell
            cell.lblName.text = contactName
            let firstLetter = contactName.first
            if firstLetter != nil{
                cell.btnUser.setTitle("\(firstLetter!)", for: .normal)
            }
            else{
                cell.btnUser.setTitle("", for: .normal)
            }
            
            return cell.contentView
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        if tableView.tag == 0{
            view.tintColor = UIColor.clear
            let header = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = .white
            header.textLabel?.textColor = UIColor.tribe_purple
            header.textLabel?.font = UIFont.tribe_heading
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            if section == 0 { //tribe users
                //return 1 at minimum with empty text
                if txtSearch.text != "" {
                    if filteredContacts?.matched != nil && filteredContacts.matched.count > 0 {
                        return filteredContacts.matched.count
                    }
                } else {
                    if Global.serverContacts?.matched != nil && Global.serverContacts.matched.count > 0 {
                        return Global.serverContacts.matched.count
                    }
                }
            } else if section == 1 { //phone contacts
                //return 1 at minimum with empty text
                if txtSearch.text != "" {
                    if filteredLocalContacts.count > 0 {
                        return filteredLocalContacts.count
                    }
                } else {
                    if Global.localContactsArray.count > 0 {
                        return Global.localContactsArray.count
                    }
                }
            }
            
            return 1
        }
        else{
            return contactDetail.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            let myContactsTCell = tableView.dequeueReusableCell(withIdentifier: "MyContactsTCell") as! MyContactsTCell
            
            myContactsTCell.btnAdd.tag = indexPath.row
            myContactsTCell.btnInvite.tag = indexPath.row
            myContactsTCell.imgTick.isHidden = true
            
            myContactsTCell.imgUser.image = UIImage(named: "tribe_holder")
            
            var contactCount = 0
            if indexPath.section == 0 && txtSearch.text != "" {
                contactCount = filteredContacts != nil ? filteredContacts.matched.count : 0
            } else if indexPath.section == 0 {
                contactCount = Global.serverContacts?.matched?.count ?? 0
            } else if indexPath.section == 1 && txtSearch.text != "" {
                contactCount = filteredLocalContacts.count
            } else if indexPath.section == 1 {
                contactCount = Global.localContacts.count
            }
            
            if contactCount == 0 {
                myContactsTCell.lblName.text = "No Contacts Available"
                myContactsTCell.btnAdd.isHidden = true
                myContactsTCell.btnInvite.isHidden = true
            } else {
                if indexPath.section == 0 && txtSearch.text != "" {
                    myContactsTCell.lblName.text = filteredContacts.matched[indexPath.row].firstName + " " + filteredContacts.matched[indexPath.row].lastName
                    myContactsTCell.btnAdd.isHidden = false
                    myContactsTCell.btnInvite.isHidden = true
                    
                    if filteredContacts.matched[indexPath.row].isInvited == true {
                        myContactsTCell.btnAdd.isEnabled = false
                        myContactsTCell.btnAdd.setTitle("Request Sent", for: .normal)
                    } else {
                        myContactsTCell.btnAdd.isEnabled = true
                        myContactsTCell.btnAdd.setTitle("Add", for: .normal)
                    }
                    
                    if filteredContacts.matched[indexPath.row].picUrl != nil && filteredContacts.matched[indexPath.row].picUrl.count > 0 {
                        var imgURL = filteredContacts.matched[indexPath.row].picUrl.first
                        if (imgURL?.starts(with: "public"))! {
                            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                        }
                        myContactsTCell.imgUser.sd_setShowActivityIndicatorView(true)
                        myContactsTCell.imgUser.sd_setIndicatorStyle(.gray)
                        myContactsTCell.imgUser.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
                    }
                } else if indexPath.section == 0 {
                    myContactsTCell.lblName.text = Global.serverContacts.matched[indexPath.row].firstName + " " + Global.serverContacts.matched[indexPath.row].lastName
                    myContactsTCell.btnAdd.isHidden = false
                    myContactsTCell.btnInvite.isHidden = true
                    
                    if Global.serverContacts.matched[indexPath.row].isInvited == true {
                        myContactsTCell.btnAdd.isEnabled = false
                        myContactsTCell.btnAdd.setTitle("Request Sent", for: .normal)
                    } else {
                        myContactsTCell.btnAdd.isEnabled = true
                        myContactsTCell.btnAdd.setTitle("Add", for: .normal)
                    }
                    
                    if Global.serverContacts.matched[indexPath.row].picUrl != nil && Global.serverContacts.matched[indexPath.row].picUrl.count > 0 {
                        var imgURL = Global.serverContacts.matched[indexPath.row].picUrl[0]
                        if (imgURL.starts(with: "public")) {
                            imgURL = imgURL.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                        }
                        myContactsTCell.imgUser.sd_setShowActivityIndicatorView(true)
                        myContactsTCell.imgUser.sd_setIndicatorStyle(.gray)
                        myContactsTCell.imgUser.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "graydient"))
                    }
                }
                else if indexPath.section == 1 && txtSearch.text != "" {
                    myContactsTCell.lblName.text = filteredLocalContacts[indexPath.row].givenName + " " + filteredLocalContacts[indexPath.row].familyName + " " + filteredLocalContacts[indexPath.row].organizationName
                    myContactsTCell.imgTick.isHidden = true
                    myContactsTCell.btnAdd.isHidden = true
                    myContactsTCell.btnInvite.isHidden = false
                    
                    //                if filteredContacts.unmatched[indexPath.row].isInvited == true {
                    //                    myContactsTCell.btnInvite.isHidden = true
                    //                    myContactsTCell.imgTick.isHidden = false
                    //                } else {
                    //                    myContactsTCell.btnInvite.isHidden = false
                    //                }
                    //
                    //                if let imgData = filteredContacts.unmatched[indexPath.row].picture {
                    //                    myContactsTCell.imgUser.image = UIImage(data: imgData)
                    //                }
                } else if indexPath.section == 1 {
                    
                    myContactsTCell.lblName.text = Global.localContactsArray[indexPath.row].givenName + " " + Global.localContactsArray[indexPath.row].familyName + " " + Global.localContactsArray[indexPath.row].organizationName
                    myContactsTCell.imgTick.isHidden = true
                    myContactsTCell.btnAdd.isHidden = true
                    myContactsTCell.btnInvite.isHidden = false
                    
                }
            }
            
            return myContactsTCell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsTCell") as! ContactDetailsTCell
            cell.lblNumber.text = contactDetail[indexPath.row].value.stringValue
            cell.lblType.text = contactDetail[indexPath.row].label?.replacingOccurrences(of: "[!$<>_]", with: "", options: .regularExpression, range: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            let phone = contactDetail[indexPath.row].value.stringValue
            openMessageViewController(phone: phone)
        }
    }
    
    
    // MARK: - TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtSearchAction(textField)
    }
    
    /**
     Filters contacts and reloads UI based on the text in search box.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func txtSearchAction(_ sender: Any) {
        if Global.serverContacts != nil{
            filteredContacts = TribeNContacts(fromDictionary: Global.serverContacts.toDictionary())
            filteredContacts.matched = Global.serverContacts.matched.filter({ (contact) -> Bool in
                let name: String = contact.firstName + " " + contact.lastName
                return name.range(of: txtSearch.text!, options: .caseInsensitive) != nil
            })
        }
        
        filteredLocalContacts = Global.localContactsArray.filter({ (contact) -> Bool in
            let name: String = contact.givenName
            return name.range(of: txtSearch.text!, options: .caseInsensitive) != nil
        })
        let filterSet = NSSet(array: filteredLocalContacts as NSArray as! [NSObject])
        let filterArray = filterSet.allObjects as NSArray
        filteredLocalContacts = filterArray as! [CNContact]
        tblMyContacts.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /**
     Sends a tribe invite to the selected user.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnAddTribeAction(_ sender: UIButton) {
        var user_id = ""
        if txtSearch.text == "" {
            user_id = Global.serverContacts.matched[sender.tag].id
            Global.serverContacts.matched[sender.tag].isInvited = true
        } else {
            user_id = filteredContacts.matched[sender.tag].id
            filteredContacts.matched[sender.tag].isInvited = true
        }
        
        ServerManager.Instance.addToTribe(user_id: user_id)
        tblMyContacts.reloadData()
    }
    
    /**
     Opens SMS view for inviting selected user to Tribe App. If user has multiple phone numbers, it opens a view to choose between phone numbers.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnInviteToTribeAction(_ sender: UIButton) {
        var phone = ""
        if txtSearch.text == "" {
            
            if Global.localContactsArray[sender.tag].phoneNumbers.count > 1{
                contactDetail = Global.localContactsArray[sender.tag].phoneNumbers
                contactName = Global.localContactsArray[sender.tag].givenName
                selectedContactIdentifier = Global.localContactsArray[sender.tag].identifier
                showContactDetailsTable()
                //print(Global.localContactsArray[sender.tag].phoneNumbers)
            }
            else{
                if let phone = Global.localContactsArray[sender.tag].phoneNumbers.first?.value.stringValue {
                    openMessageViewController(phone: phone)
                }
                else{
                    UtilManager.showAlertMessage(message: "No contact number found")
                }
                
            }
            
            //Global.serverContacts.unmatched[sender.tag].isInvited = true
        } else {
            if filteredLocalContacts[sender.tag].phoneNumbers.count > 1{
                contactDetail = filteredLocalContacts[sender.tag].phoneNumbers
                contactName = filteredLocalContacts[sender.tag].givenName
                selectedContactIdentifier = filteredLocalContacts[sender.tag].identifier
                showContactDetailsTable()
                //print(Global.localContactsArray[sender.tag].phoneNumbers)
            }
            else{
                if let phone = filteredLocalContacts[sender.tag].phoneNumbers.first?.value.stringValue {
                    openMessageViewController(phone: phone)
                }
                else{
                    UtilManager.showAlertMessage(message: "No contact number found")
                }
            }
        }
        
        //
        
    }
    
    /**
     Delegate method called when the SMS view controller is being dismissed.
     
     - Parameter controller:   view controller being dismissed.
     - Parameter result:   action causing the controller to dismiss.
     */
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    /**
     Hides the view containting mutiple phone numbers of a selected user when tapped outside the view.
     
     - Parameter gesture:   UITapGestureRecognizer triggering the event.
     */
    @objc func dismissTable(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.tblContactDetails.alpha = 0.0
            self.vwOverlay.alpha = 0.0
        }, completion: { (finished: Bool) -> Void in
            self.tblContactDetails.isHidden = true
            self.vwOverlay.isHidden = true
        })
    }
    
    /**
     Shows the view containting mutiple phone numbers of a selected user.
     */
    func showContactDetailsTable(){
        
        self.tblContactDetails.isHidden = false
        self.vwOverlay.isHidden = false
        
        //tblDataSource = sender.tag
        
        tblContactDetails.reloadData()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.tblContactDetails.alpha = 1.0
            self.vwOverlay.alpha = 0.6
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    /**
     Presents the view controller for sending SMS to the selected user.
    
     - Parameter phone:   Phone number of the selected user.
     */
    func openMessageViewController(phone: String){
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = [phone]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = "Hey! Please join me on the CoDate app. Where people help their single-friends find love. Download: https://www.creatrixe.co"
            self.present(messageController, animated: true, completion: nil)
            
            tblMyContacts.reloadData()
        } else {
            //handle text messaging not available
            UtilManager.showAlertMessage(message: "The device does not have SMS support")
        }
    }
    
}

