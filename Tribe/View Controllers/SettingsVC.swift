 //
 //  SettingsVC.swift
 //  Tribe Technology Ventures
 //
 //  Created by macintosh
 //  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
 //

import UIKit
import RMDateSelectionViewController
class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

     // MARK: - Outlets
    @IBOutlet weak var tblSettings: UITableView!
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //check for crash safing when user de-activates profile or logs out
        if Global.myProfile != nil {
            ServerManager.Instance.updateProfile(user: Global.myProfile)
        }
        //resetting the matchables query as the user has potentially updated their preferences
        Global.matchables = []
        Global.currentMatchable = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegates and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let settingsDaterProfileTCell = tableView.dequeueReusableCell(withIdentifier: "SettingsDaterProfileTCell") as! SettingsDaterProfileTCell
            
            
            settingsDaterProfileTCell.swDater.isOn = Global.myProfile?.settings?.dater == true
            
            return settingsDaterProfileTCell
        } else if indexPath.row == 1 {
            let settingsInfoTCell = tableView.dequeueReusableCell(withIdentifier: "SettingsInfoTCell") as! SettingsInfoTCell
            
            settingsInfoTCell.swPublicProfile.isOn = Global.myProfile?.settings?.publicProfile == true
            if Global.myProfile?.settings?.dater == true {
                settingsInfoTCell.isUserInteractionEnabled = true
                settingsInfoTCell.vwOverLay.isHidden = true
            } else {
                settingsInfoTCell.isUserInteractionEnabled = false
                settingsInfoTCell.vwOverLay.isHidden = false
            }
            
            return settingsInfoTCell
        } else {
            let settingsPrivacyTCell = tableView.dequeueReusableCell(withIdentifier: "SettingsPrivacyTCell") as! SettingsPrivacyTCell
            return settingsPrivacyTCell
        }
    }
    
    // MARK: - Actions
    /**
     Activates/Deactivates dater profile section. Triggered by toggle of dater switch.
     
     - Parameter sender:   UISwitch triggering the event.
    */
    @IBAction func swDaterProfile(_ sender: UISwitch) {
        if sender.tag == 0{
            Global.myProfile?.settings?.dater = sender.isOn
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "daterTab"), object: nil)
            if Global.myProfile.age == nil{
                openDateSelectionViewController()
            }
            else{
                ServerManager.Instance.updateProfile(user: Global.myProfile)
                tblSettings.reloadData()
            }
            
        }
        else{
            Global.myProfile?.settings?.publicProfile = sender.isOn
            ServerManager.Instance.updateProfile(user: Global.myProfile)
            tblSettings.reloadData()
        }
    }
    
    /**
     Logs out the user.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func logoutUser(_ sender: Any) {
        //set all local storage to nil
        UtilManager.logoutUser()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /**
     Deletes user profile and logs out the user.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func deactivateAccount(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Deactivate Account?", message: "Are you sure you want to deactivate your account? This will delete all data related to your account and cannot be undone.", preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            ServerManager.Instance.deleteUser()
            
            UtilManager.logoutUser()
            
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    /**
     Presents date picker view if user activates dater profile but does not have date of birth in profile.
     */
    func openDateSelectionViewController() {
        let style = RMActionControllerStyle.sheetWhite
        //        if self.blackSwitch.isOn {
        //            style = RMActionControllerStyle.black
        //        }
        //
        let selectAction = RMAction<UIDatePicker>(title: "Select", style: RMActionStyle.done) { controller in
            print("Successfully selected date: ", controller.contentView.date);
            if let dt = controller.contentView.date as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                Global.myProfile.age = formatter.string(from: dt)
                Global.myProfile?.settings?.dater = true
                ServerManager.Instance.updateProfile(user: Global.myProfile)
                self.tblSettings.reloadData()
            }
            else{
                UtilManager.showAlertMessage(message: "Something went wrong")
            }
            
        }
        
        let cancelAction = RMAction<UIDatePicker>(title: "Cancel", style: RMActionStyle.cancel) { _ in
            Global.myProfile?.settings?.dater = false
            ServerManager.Instance.updateProfile(user: Global.myProfile)
            self.tblSettings.reloadData()
        }
        
        let actionController = RMDateSelectionViewController(style: style, title: "Please provide your date of birth", message: nil, select: selectAction, andCancel: nil)!;
        
        //You can access the actual UIDatePicker via the datePicker property
        actionController.datePicker.datePickerMode = .date;
        //actionController.datePicker.minuteInterval = 5;
        actionController.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        actionController.datePicker.date = Date(timeIntervalSinceReferenceDate: 0);
        
        //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
        //(Of course only if we are running on iOS 8 or later)
        if actionController.responds(to: Selector(("popoverPresentationController:"))) && UIDevice.current.userInterfaceIdiom == .pad {
            //First we set the modal presentation style to the popover style
            actionController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            //Then we tell the popover presentation controller, where the popover should appear
            if let popoverPresentationController = actionController.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = self.view.frame
            }
        }
        
        //Now just present the date selection controller using the standard iOS presentation method
        present(actionController, animated: true, completion: nil)
    }

}
