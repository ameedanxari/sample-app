//
//  ActivateDatingProfileVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import DatePickerDialog
import RMDateSelectionViewController
class ActivateDatingProfileVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()

        btnYes.layer.cornerRadius = btnYes.frame.height / 2
        btnYes.titleLabel?.numberOfLines = 0
        btnNo.layer.borderWidth = 1
        btnNo.layer.cornerRadius = btnNo.frame.height / 2
        btnNo.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    /**
     Sets the dater flag to yes in user settings and loads the main screen.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnYesActivateProfileAction(_ sender: UIButton) {
        if Global.myProfile.age == nil{
          openDateSelectionViewController()
        }
        else{
            Global.myProfile?.settings?.dater = true
            ServerManager.Instance.updateProfile(user: Global.myProfile)
            let vc = storyboard?.instantiateViewController(withIdentifier: "StartUpMainVC") as! StartUpMainVC
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    /**
     Sets the dater flag to no in user settings and loads the main screen.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnNoScreenDatesAction(_ sender: UIButton) {
        Global.myProfile?.settings?.dater = false
        ServerManager.Instance.updateProfile(user: Global.myProfile)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "StartUpMainVC") as! StartUpMainVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     Opens action sheet to get date from user if not pulled from Facebook automatically.
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
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartUpMainVC") as! StartUpMainVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                UtilManager.showAlertMessage(message: "Something went wrong")
            }
            
        }
        
        let cancelAction = RMAction<UIDatePicker>(title: "Cancel", style: RMActionStyle.cancel) { _ in
            print("Date selection was canceled")
        }
        
        let actionController = RMDateSelectionViewController(style: style, title: "Please provide your date of birth", message: nil, select: selectAction, andCancel: cancelAction)!;
        
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
