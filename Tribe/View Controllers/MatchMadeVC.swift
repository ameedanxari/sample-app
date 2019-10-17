//
//  MatchMadeVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//
import UIKit

class MatchMadeVC: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnStartChat: UIButton!
    
    /**
     Sets up the UI elements for the view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var imgURL = Global.matchMade.picUrl?.first
        if (imgURL?.starts(with: "public"))! {
            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
        }
        imgUser.sd_setShowActivityIndicatorView(true)
        imgUser.sd_setIndicatorStyle(.gray)
        imgUser.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
        
        //gradient layer
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorTop = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0).cgColor
        let colorMiddle = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6).cgColor
        let colorBottom = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8).cgColor
        gradient.colors = [colorTop, colorMiddle, colorBottom]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.3)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = imgUser.bounds
        gradient.opacity = 1.0
        imgUser.layer.addSublayer(gradient)
        
        //start chat button layout
        btnStartChat.layer.borderWidth = 1
        btnStartChat.layer.borderColor = UIColor.tribe_purple.cgColor
        btnStartChat.layer.cornerRadius = btnStartChat.frame.height / 2
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Gets the user profile from server which in turn pushes the chat VC.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func openChatVC(_ sender: Any) {
        ServerManager.Instance.getUserDetail(userID: Global.myProfile.id!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addingMessagesVC"), object: nil)
        
        self.navigationController?.popViewController(animated: false)
    }
    
    /**
     Gets the user profile from server and then pops the view controller.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func dismissVC(_ sender: Any) {
        ServerManager.Instance.getUserDetail(userID: Global.myProfile.id!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: true)
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
    
}
