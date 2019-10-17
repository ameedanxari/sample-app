//
//  LoginVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import EasyTipView
import FBSDKLoginKit
import Firebase
import RMDateSelectionViewController
class LoginVC: UIViewController, EasyTipViewDelegate /*, FBSDKLoginButtonDelegate*/ {
    // MARK: - Varibales
    var preferences = EasyTipView.Preferences()
    var tipView: EasyTipView!
    var menuOpen = false

    // MARK: - Outlets
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        btnInfo.imageView?.contentMode = .scaleAspectFit
        
        btnFacebook.layer.cornerRadius = btnFacebook.frame.height / 2
        btnFacebook.clipsToBounds = true
        //preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Helvetica", size: 12)!
        preferences.drawing.foregroundColor = UIColor.black
        preferences.drawing.backgroundColor = UIColor.lightGray
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        preferences.drawing.textAlignment = .center
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    /**
     Allow the user to login via phone number instead of Facebook. NOT implemented as yet.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnAnotherOptionAction(_ sender: UIButton) {
        //TODO: Implement login via phone number
//        let phoneNumberVC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberVC
//        self.navigationController?.pushViewController(phoneNumberVC, animated: true)
        UtilManager.showAlertMessage(message: "Coming Soon")
    }
    
    /**
     Log in the user via Facebook.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnFacbookLoginAction(_ sender: UIButton) {
        LoginManager().logOut()
        LoginManager().logIn(permissions: ["public_profile", "email", "user_birthday", "user_photos"], from: self) { (result, err) in
            if let errorMsg = err?.localizedDescription {
                UtilManager.showAlertMessage(message: errorMsg)
                return
            } else if (result?.isCancelled)! {
                return
            }
            
            self.fbLoginSuccess()
        }
    }
    
    /**
     Toggles the popup showing privacy info related to Facebook login.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnInfoAction(_ sender: UIButton) {
        if !menuOpen
        {
            menuOpen = true
            tipView = EasyTipView(text: "Why do I need to sign in with Facebook?\n\nWe use Facebook for accuracy and security. You don't want bots or spam and neither do we. Facebook authentication helps us to make sure you get the best experience possible.\n\nTap to dismiss!", preferences: preferences, delegate: self)

            tipView.show(animated: true, forView: sender, withinSuperview: self.view)
        }
        else
        {
            menuOpen = false
            tipView.dismiss()
            print("Dismiss")
        }
    }
    
    // MARK: - Facebook SDK Delegates
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil
//        {
//            print("Error: \(error)")
//            return
//        }
//        showEmailAddress()
//
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Logout")
//    }
    
    // MARK: - ToolTip Delegates
    /**
     Delegate method from EasyTipView. Called when the EasyTipView is dismissed.
     
     - Parameter tipView:   EasyTipView triggering the event.
     */
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
    }
    
    // MARK: - Functions
    /**
     Opens Terms of Service in Safari.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func showTermsOfService(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Constants.TERMS_URL)!)
    }
    
    /**
     Opens Privacy Policy in Safari.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Constants.PRIVACY_URL)!)
    }
    
    /**
     Logs in the user or creates account if first time user after success from FB login. Redirects to phone authentication screen.
     */
    func fbLoginSuccess() {
        
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else { return }

        Global.fbToken = accessTokenString
        Global.fbID = (accessToken?.userID)!
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
        })

        UtilManager.showGlobalProgressHUDWithTitle("Signing In...")
        
        GraphRequest(graphPath: "/me", parameters: ["fields": "id,picture.type(large), name,email,gender,interested_in,birthday"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
            let data = result as? NSDictionary
            Global.user.email = data!["email"] as? String
            Global.user.name = data!["name"] as? String
            let pictureData = data!["picture"] as? NSDictionary
            Global.user.gender = data!["gender"] as? String
            Global.user.age = data!["birthday"] as? String
            if let user_id = data!["id"] as? String {
                Global.user.picUrl = "https://graph.facebook.com/"+user_id+"/picture?width=720"
            } else if let pic = pictureData!["data"] as? NSDictionary {
                Global.user.picUrl = pic["url"] as? String
            }
            if Global.user.gender == nil{
                Global.user.gender = "Other"
            }
            
            if Global.user.email == nil{
                Global.user.email = ""
            }
            
            if Global.user.age == nil
            {
                Global.user.age = ""
            }
            
            UtilManager.dismissGlobalHUD()
            
            let phoneNumberVC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberVC
            self.navigationController?.pushViewController(phoneNumberVC, animated: true)
        }
    }
    // MARK: Actions
    

}
