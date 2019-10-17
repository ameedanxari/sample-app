//
//  VerifyPhoneNumberVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import FirebaseAuth

class VerifyPhoneNumberVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var txtThird: UITextField!
    @IBOutlet weak var txtFourth: UITextField!
    @IBOutlet weak var txtFifth: UITextField!
    @IBOutlet weak var txtSixth: UITextField!
    
    // MARK: - Load
    override func viewDidLoad() {
        //Notification Listeners
        NotificationCenter.default.addObserver(self, selector: #selector(loginUserSuccess), name: NSNotification.Name(rawValue: "loginUserSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createUserSuccess), name: NSNotification.Name(rawValue: "createUserSuccess"), object: nil)
        
        super.viewDidLoad()

        //Make border plus round the txtfield with theme color
        txtFirst.layer.borderWidth = 1
        txtFirst.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        txtFirst.layer.cornerRadius = 10
        
        txtSecond.layer.borderWidth = 1
        txtSecond.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        txtSecond.layer.cornerRadius = 10
        
        txtThird.layer.borderWidth = 1
        txtThird.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        txtThird.layer.cornerRadius = 10
        
        txtFourth.layer.borderWidth = 1
        txtFourth.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        txtFourth.layer.cornerRadius = 10
        
        txtFifth.layer.borderWidth = 1
        txtFifth.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        txtFifth.layer.cornerRadius = 10
        
        txtSixth.layer.borderWidth = 1
        txtSixth.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        txtSixth.layer.cornerRadius = 10
        
        txtFirst.delegate = self
        txtSecond.delegate = self
        txtThird.delegate = self
        txtFourth.delegate = self
        txtFifth.delegate = self
        txtSixth.delegate = self
        
        txtFirst.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSecond.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtThird.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtFourth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtFifth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSixth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        //txtFirst.becomeFirstResponder()
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
    
    // MARK: - Actions
    /**
     Resend the verification code.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnSendAgainAction(_ sender: UIButton) {
        UtilManager.showGlobalProgressHUDWithTitle("Please Wait...");
        PhoneAuthProvider.provider().verifyPhoneNumber(Global.user.phoneNumber!) {(verificationID,error) in
            
            if error != nil
            {
                UtilManager.dismissGlobalHUD()
                UtilManager.showAlertMessage(message: "Phone number is incorrect")
                print ("Error: \(String(describing: error?.localizedDescription))")
            }
            else
            {
                UtilManager.dismissGlobalHUD()
                let defaults = UserDefaults.standard
                defaults.setValue(verificationID, forKey: "authID")
                UtilManager.showAlertMessage(message: "Verification code sent successfully")
            }
            
        }
    }
    
    // MARK: - Fucntions
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if text!.utf16.count >= 1{
            switch textField{
            case txtFirst:
                txtSecond.becomeFirstResponder()
            case txtSecond:
                txtThird.becomeFirstResponder()
            case txtThird:
                txtFourth.becomeFirstResponder()
            case txtFourth:
                txtFifth.becomeFirstResponder()
            case txtFifth:
                txtSixth.becomeFirstResponder()
            case txtSixth:
                txtSixth.resignFirstResponder()
                UtilManager.showGlobalProgressHUDWithTitle("Please Wait...")
                let code = "\(txtFirst.text!)\(txtSecond.text!)\(txtThird.text!)\(txtFourth.text!)\(txtFifth.text!)\(txtSixth.text!)"
                let defaults = UserDefaults.standard
                let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authID")!, verificationCode: code)
                Auth.auth().signIn(with: credential){(user,error)in
                    if error != nil
                    {
                        UtilManager.dismissGlobalHUD()
                        UtilManager.showAlertMessage(message: "Code is incorrect")
                        print ("Error: \(String(describing: error?.localizedDescription))")
                    }
                    else
                    {
                        ServerManager.Instance.checkUser(phone: Global.user.phoneNumber, fb_id: Global.fbID, fb_token: Global.fbToken)
                        
                        print("Phone number: \(String(describing: user?.phoneNumber))")
                        let userInfo = user?.providerData[0]
                        print ("Provider ID: \(String(describing: userInfo?.providerID))")

                        //ServerManager.Instance.registerUser(phoneNumber: Global.user.phoneNumber, name: Global.user.name, email: Global.user.email ?? "", age: Global.user.age, gender: Global.user.gender, picUrl: Global.user.picUrl)
                    }
                }
            default:
                break
            }
        }else{
            
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
     Verification code success method which takes the user to dashboard screen. Called when user was already registerd.
     */
    @objc func loginUserSuccess() {
        UtilManager.dismissGlobalHUD()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     Verification code success method which takes the user to dater setting selection screen. Called for new users.
     */
    @objc func createUserSuccess() {
        UtilManager.dismissGlobalHUD()
        
        let activateDatingProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ActivateDatingProfileVC") as! ActivateDatingProfileVC
        self.navigationController?.pushViewController(activateDatingProfileVC, animated: true)
    }
}

extension VerifyPhoneNumberVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
