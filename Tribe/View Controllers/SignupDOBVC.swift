//
//  SignupDOBVC.swift
//  Tribe
//
//  Created by Creatrixe on 03/08/2018.
//  Copyright © 2018 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import DatePickerDialog
class SignupDOBVC: UIViewController {

    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    var dobEntered = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDOB.layer.cornerRadius = 5
        btnContinue.layer.cornerRadius = btnContinue.frame.height/2
        // Do any additional setup after loading the view.
    }

    /**
     Displays picker for Date of Birth.
     
     - Parameter sender:   The button sending the event.
    */
    @IBAction func btnDOBAction(_ sender: UIButton) {
        let date = Date.getDateFromString(string: Global.myProfile?.age ?? "")
        DatePickerDialog().show("Select your date of birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: date, maximumDate: Calendar.current.date(byAdding: .year, value: -18, to: Date()), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                Global.myProfile.age = formatter.string(from: dt)
                //Post notification for showing DOB on button
                let dob = Date.getDisplayDateFromString(string: Global.myProfile?.age ?? "")
                self.btnDOB.setTitle(dob, for: .normal)
                self.dobEntered = true
            }
        }
    }
    
    /**
     Checks if date of birth is valid and takes user to StartUpMainVC.
     
     - Parameter sender:   The button sending the event.
    */
    @IBAction func btnContinueAction(_ sender: UIButton) {
        if dobEntered{
            ServerManager.Instance.updateProfile(user: Global.myProfile)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "StartUpMainVC") as! StartUpMainVC
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            UtilManager.showAlertMessage(message: "Please enter your date of birth to proceed")
        }
    }
    
}
