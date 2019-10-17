//
//  UserProfileVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import Alamofire

class UserProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    /**  SWIPE DIRECTIONS  **
     **  Left   - DISLIKE  **
     **  Right  - LIKE     **
     **  Up     - NEXT     **
     **  Down   - PREVIOUS **/
    fileprivate var arrOfCells: [String] = []
    var currentProfile:TribeNMatchable!
    var isChatHidden = false
    
    let borderLayer = CAShapeLayer()
    var tappedUserId: String!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var vwOverlayBg: UIView!
    
    @IBOutlet weak var svRefresh: UIScrollView!
    @IBOutlet weak var vwProfileDrag: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var vwCard:UIView!
    @IBOutlet weak var vwCardHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwOutOfSwipes: UIView!
    @IBOutlet weak var btnInviteNow: UIButton!
    @IBOutlet weak var lblOutOfSwipesDesc: UILabel!
    
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var tblProfile: UITableView!
    
    @IBOutlet weak var cvSliderCount: UICollectionView!
    
    var isProgramaticallySwiping = false
    
    var isHorizontalPan:Bool!
    var vwOverlay:OverlayView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = .tribe_purple
        
        return refreshControl
    }()
    
    /**
     Loads the view controllers and sets up gestures.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
        
        // Do any additional setup after loading the view.
        btnChat.isHidden = isChatHidden
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        img2.isUserInteractionEnabled = true
        img2.addGestureRecognizer(panGesture)
        
        vwOverlay = Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
        vwOverlay.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: vwOverlay, attribute: .top, relatedBy: .equal, toItem: img2, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: vwOverlay, attribute: .bottom, relatedBy: .equal, toItem: img2, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: vwOverlay, attribute: .leading, relatedBy: .equal, toItem: img2, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: vwOverlay, attribute: .trailing, relatedBy: .equal, toItem: img2, attribute: .trailing, multiplier: 1, constant: 0)
        //setting the opacities
        resetOpacity()
        
        img2.addSubview(vwOverlay)
        img2.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
        let swipeGestures = setupSwipeGestures()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(changeImage(_:)))
        img2.addGestureRecognizer(tapGesture2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleProfile(_:)))
        vwProfileDrag.addGestureRecognizer(tapGesture)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(showProfile))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideProfile))
        vwProfileDrag.addGestureRecognizer(swipeUp)
        vwProfileDrag.addGestureRecognizer(swipeDown)
        
        let panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(draggedProfile(_:)))
        vwProfileDrag.addGestureRecognizer(panGesture2)
        
        svRefresh.addSubview(self.refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushChatVC), name: NSNotification.Name(rawValue: "openChatVC"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViews), name:NSNotification.Name(rawValue: "matchablesUpdated"), object: nil)
        
        adjustViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global.locationManager.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Utility function to resets the opacities of views after swipe event ends.
     */
    func resetOpacity() {
        //reset opacity
        self.vwOverlay.circleRadius = 0.0
        self.vwOverlay.alpha = 0.0
        self.vwProfileDrag.alpha = 1
        self.cvSliderCount.alpha = 1
    }
    
    // MARK: - Navigation functions
    /**
     Sets the UI elements to default states on profile card.
     */
    @objc func adjustViews() {
        refreshControl.endRefreshing()
        vwCard.isHidden = false
        vwProfileDrag.isHidden = false
        vwOutOfSwipes.isHidden = true
        svRefresh.isHidden = true
        
        tblProfile.reloadData()
        
        var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
        if (imgURL?.starts(with: "public"))! {
            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
        }
        img2.sd_setShowActivityIndicatorView(true)
        img2.sd_setIndicatorStyle(.gray)
        img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
        
        UtilManager.dismissGlobalHUD()
    }
    
    /**
     Sets the UI elements to `out of swipe` states on profile card. Displays the OutOfSwipes error view and hides the profile cards.
     */
    func outOfSwipes() {
        vwOutOfSwipes.isHidden = false
        svRefresh.isHidden = false
        
        vwCard.isHidden = true
        vwProfileDrag.isHidden = true
        cvSliderCount.isHidden = true
        borderLayer.removeFromSuperlayer()

        Global.tribeSwipeList = []
        Global.currentTribeMatchable = 0
    }
    
    /**
     Triggered on Pull down to refresh and gets the updated list of matches.
     
     - Parameter refreshControl:   The UIRefreshControl triggering the event.
     */
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if let coordinates = Global.myProfile.geo, coordinates.count == 2 {
            ServerManager.Instance.getMatchables(latitude: coordinates[0], longitude: coordinates[1])
        }
    }
    
    // MARK: -  UITableViewDelegate Mehtod 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //calculate how many rows to show.. 1 at the min
        arrOfCells = []
        arrOfCells.append("user_info")
        
        if currentProfile.education != nil && currentProfile.education != "" {
            arrOfCells.append("education")
        }
        if currentProfile.aboutMe != nil && currentProfile.aboutMe != "" {
            arrOfCells.append("about_me")
        }
        if currentProfile.ethnicity != nil && currentProfile.ethnicity != "" {
            arrOfCells.append("ethnicity")
        }
        if currentProfile.height != nil && currentProfile.height != 0 {
            arrOfCells.append("height")
        }
        
        arrOfCells.append("block")
        
        return arrOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrOfCells[indexPath.row] == "user_info" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHeadTCell", for:  indexPath) as! MatchHeadTCell
            //getting first initial of last name
            var initials = ""
            var names = currentProfile.firstName.components(separatedBy: " ")
            if names.count > 1 {
                initials = names[0] + " " + String(names[1].first!)
            } else {
                initials = names[0]
            }
            
            if currentProfile.age == nil {
                cell.lblHeading.text = initials// + " - n/a"
            } else {
                cell.lblHeading.text = initials + " - " + Date.getAgeFromString(string: currentProfile.age)
            }
            
            if currentProfile.location == "" {
                cell.lblDesc.text = ""
            } else {
                cell.lblDesc.text = currentProfile.location
            }
            
            return cell
        } else if arrOfCells[indexPath.row] == "block" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBlockTCell", for:  indexPath) as! ProfileBlockTCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchDescTCell", for:  indexPath) as! MatchDescTCell
            
            if arrOfCells[indexPath.row] == "education" {
                cell.lblHeading.text = "Education"
                cell.lblDesc.text = currentProfile.education
            } else if arrOfCells[indexPath.row] == "about_me" {
                cell.lblHeading.text = "About Me"
                cell.lblDesc.text = currentProfile.aboutMe
            } else if arrOfCells[indexPath.row] == "ethnicity" {
                cell.lblHeading.text = "Ethnicity"
                cell.lblDesc.text = currentProfile.ethnicity
            } else if arrOfCells[indexPath.row] == "height" {
                cell.lblHeading.text = "Height"
                
                let feet = (currentProfile.height) / 12
                let inches = (currentProfile.height) % 12
                cell.lblDesc.text = "\(feet)'\(inches)\""
            }
            
            return cell
        }
    }
    
    // MARK: -  UicollectionViewDataSource Mehtod 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            //handling any crashes due to fast swiping or any other inconsistent state!
            //            maximum of 6 dots - badoo style
            let count = (currentProfile.picUrl?.count)! > 6 ? 6 : currentProfile.picUrl?.count
            //adjusting height to the number of dots
            return count!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCountVCell", for:  indexPath) as! SliderCountVCell
        
        if indexPath.row == Global.currentProfileImageIndex % 6 {
            cell.imgMain.backgroundColor = UIColor.white
            cell.imgMain.alpha = 1.0
        } else {
            cell.imgMain.backgroundColor = UIColor.black
            cell.imgMain.alpha = 0.4
        }
        return cell
    }
    
    // MARK: - Profile Display!
    /**
     Shows next or previous image based on tap gesture location. Tapping on top half shows the previous image and tapping on lower half shows next image
     
     - Parameter sender:   The UITapGestureRecognizer triggering the event.
     */
    @objc func changeImage(_ sender:UITapGestureRecognizer){
        var touchLocation = sender.location(in: img2)
        if touchLocation.y < img2.center.y {
            if Constants.IS_DEBUG {
                print("show previous image")
            }
            
            showPreviousPicture()
        } else {
            if Constants.IS_DEBUG {
                print("show next image")
            }
            
            showNextPicture()
        }
    }
    
    /**
     Toggles the display state of the profile detail view on tap.
     
     - Parameter sender:   The UITapGestureRecognizer triggering the event.
     */
    @objc func toggleProfile(_ sender:UITapGestureRecognizer) {
        if vwCardHeightConstraint.constant == 75 {
            showProfile()
        } else {
            
            hideProfile()
        }
    }
    
    /**
     Expands the profile view to display the complete profile.
     */
    @objc func showProfile() {
        vwCardHeightConstraint.constant = vwCard.frame.height - 20
        tblProfile.isScrollEnabled = true
        btnChat.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.vwCard.layoutIfNeeded()
        }
    }
    
    /**
     Shrinks the profile view to display the brief profile.
     */
    @objc func hideProfile() {
        vwCardHeightConstraint.constant = 70
        tblProfile.isScrollEnabled = false
        btnChat.isHidden = isChatHidden
        UIView.animate(withDuration: 0.2) {
            self.vwCard.layoutIfNeeded()
        }
    }
    //don't waste time in trying to simplify or merge above functions!
    
    /**
     Allows dragging of the profile view and decides whether to show or hide the profile view when the drag ends.
     
     - Parameter sender:   UIPanGestureRecognizer triggering the event.
     */
    @objc func draggedProfile(_ sender:UIPanGestureRecognizer){
        if(sender.state == .ended)
        {
            //All fingers are lifted.
            print("drag end")
            print(sender.velocity(in: self.vwCard))
            
            if sender.velocity(in: self.vwCard).y < -300 { //if user intent was downwards, hide profile
                showProfile()
            } else if sender.velocity(in: self.vwCard).y > 300 { //if user intent was upwards, show profile
                hideProfile()
            } else if (abs(vwProfileDrag.center.x - vwCard.center.x) / vwCard.center.x) < 0.7 { //if drag was less than half of screen
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.hideProfile()
                })
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.showProfile()
                })
            }
            return
        }
        
        let touchLocation = sender.location(in: self.vwCard)
        print(touchLocation)
        return
        var frame = vwProfileDrag.frame
        //profile view cannot be dragged out of screen bounds
        frame.origin.y = (touchLocation.y - 20) < 0 ? 0 : touchLocation.y - 20
        vwProfileDrag.frame = frame
    }
    
    // MARK: -  The Swipe Header! - Magic for Swiping! 
    /**
     Returns an array of allow Swipe Gestures allowed on the profile image view and the corresponding delegates to be called on each directional swipe.
     
     - Returns: Array of available swipe gestures.
     */
    private func setupSwipeGestures() -> [UISwipeGestureRecognizer] {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        swipeUp.direction = .up
        swipeDown.direction = .down
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        img2.addGestureRecognizer(swipeUp)
        img2.addGestureRecognizer(swipeDown)
        img2.addGestureRecognizer(swipeLeft)
        img2.addGestureRecognizer(swipeRight)
        
        return [swipeUp, swipeDown, swipeRight, swipeLeft]
    }
    
    /**
     Allows dragging of the profile image view and decides whether to show or hide the next image when the drag ends. This discards any horizontal swipes
     
     - Parameter sender:   UIPanGestureRecognizer triggering the event.
     */
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        if isHorizontalPan == nil {
            isHorizontalPan = sender.direction == .Left || sender.direction == .Right
        }
        
        if(sender.state == .ended)
        {
            //All fingers are lifted.
            print("drag end")
            print(sender.velocity(in: self.view))
            
            //for horizontal swipe
            if isHorizontalPan == true {
                // handle swipe vs reset state here
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                        self.img2.frame = self.img1.frame
                    }, completion: { finished in
                        self.resetOpacity()
                        self.isHorizontalPan = nil
                    })
            } else {
                // handle swipe vs reset state here
                if (abs(img2.center.y - img1.center.y) / img1.center.y) < 0.7 && abs(sender.velocity(in: self.view).y) < 500 {
                    var img1Center = vwCard.center
                    if (img2.center.y - vwCard.center.y) < 0.0 { //up
                        img1Center = CGPoint(x: img2.center.x, y: vwCard.center.y + img2.bounds.height)
                    } else if (img2.center.y - vwCard.center.y) > 0.0 { //down
                        img1Center = CGPoint(x: img2.center.x, y: vwCard.center.y - img2.bounds.height)
                    }
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                        self.img2.frame = self.vwCard.bounds
                        self.img1.center = img1Center
                    }, completion: { finished in
                        self.img1.frame = self.vwCard.bounds
                        self.isHorizontalPan = nil
                    })
                } else if (img2.center.y - vwCard.center.y) < -20.0 { //up
                    //if this is the last image, show profile
                    if Global.currentProfileImageIndex + 1 >= (currentProfile.picUrl?.count)! {
                        //reset frame location though
                        self.img2.frame = self.vwCard.bounds
                        
                        self.showProfile()
                        
                        return
                    }
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                        var frame = self.img2.frame
                        frame.origin.y = self.vwCard.bounds.origin.y - self.vwCard.bounds.height
                        frame.origin.x = self.vwCard.bounds.origin.x
                        self.img2.frame = frame
                        self.img1.frame = self.vwCard.bounds
                    }, completion: { finished in
                        //probably best to move all this to a seperate function
                        //update index, set the same image as vwCard and reset position
                        Global.currentProfileImageIndex += 1
                        
                        var imgURL = self.currentProfile.picUrl?[Global.currentProfileImageIndex]
                        if (imgURL?.starts(with: "public"))! {
                            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                        }
                        self.img2.sd_setShowActivityIndicatorView(true)
                        self.img2.sd_setIndicatorStyle(.gray)
                        self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
                        
                        //reset pan direction
                        self.isHorizontalPan = nil
                        
                        //reset opacity
                        self.resetOpacity()
                        self.cvSliderCount.reloadData()
                        
                        //reset frame location
                        self.img2.frame = self.vwCard.bounds
                    })
                } else if (img2.center.y - vwCard.center.y) > -20.0 { //down
                    //if this is the first image, do nothing
                    if Global.currentProfileImageIndex - 1 < 0 {
                        //reset frame location though
                        self.img2.frame = self.vwCard.bounds
                        return
                    }
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                        var frame = self.img2.frame
                        frame.origin.y = self.vwCard.bounds.origin.y + self.vwCard.bounds.height
                        frame.origin.x = self.vwCard.bounds.origin.x
                        self.img2.frame = frame
                        self.img1.frame = self.vwCard.bounds
                    }, completion: { finished in
                        //probably best to move all this to a seperate function
                        //update index, set the same image as vwCard and reset position
                        Global.currentProfileImageIndex -= 1
                        
                        var imgURL = self.currentProfile.picUrl?[Global.currentProfileImageIndex]
                        if (imgURL?.starts(with: "public"))! {
                            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                        }
                        self.img2.sd_setShowActivityIndicatorView(true)
                        self.img2.sd_setIndicatorStyle(.gray)
                        self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
                        
                        //reset pan direction
                        self.isHorizontalPan = nil
                        
                        //reset opacity
                        self.resetOpacity()
                        self.cvSliderCount.reloadData()
                        
                        //reset frame location
                        self.img2.frame = self.vwCard.bounds
                    })
                } else if sender.velocity(in: self.view).y < 0 { //if nothing of above, but still a swipe up!
                    self.showProfile()
                }
            }
            return
        }
        
        //        self.vwCard.bringSubview(toFront: img2)
        let translation = sender.translation(in: self.vwCard)
        
        if isHorizontalPan == true {
            return
        } else {
            if (img2.center.y - vwCard.center.y) < -20.0 { //up
                //if this is the last image, do nothing
                if Global.currentProfileImageIndex + 1 >= (currentProfile.picUrl?.count)! {
                    return
                }
                
                //set the next image
                var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex + 1]
                if (imgURL?.starts(with: "public"))! {
                    imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                }
                img1.sd_setShowActivityIndicatorView(true)
                img1.sd_setIndicatorStyle(.gray)
                img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
                cvSliderCount.reloadData()
            } else if (img2.center.y - vwCard.center.y) > -20.0 { //down
                //if this is the first image, do nothing
                if Global.currentProfileImageIndex - 1 < 0 {
                    return
                }
                
                //set the next image
                var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex - 1]
                if (imgURL?.starts(with: "public"))! {
                    imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                }
                img1.sd_setShowActivityIndicatorView(true)
                img1.sd_setIndicatorStyle(.gray)
                img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
                cvSliderCount.reloadData()
            } else {
                //if this is the last image, and trying to swipe up do nothing
                if Global.currentProfileImageIndex + 1 >= (currentProfile.picUrl?.count)! && translation.y < 0 {
                    return
                }
                //if this is the first image, do nothing
                if Global.currentProfileImageIndex - 1 < 0  && translation.y > 0 {
                    return
                }
                
            }
            
            img2.center = CGPoint(x: img2.center.x, y: img2.center.y + translation.y)
            if (img2.center.y - vwCard.center.y) < 0.0 { //up
                img1.center = CGPoint(x: img2.center.x, y: img2.center.y + img2.bounds.height) //-10 to hide the rounded corners
            } else if (img2.center.y - vwCard.center.y) > 0.0 { //down
                img1.center = CGPoint(x: img2.center.x, y: img2.center.y - img2.bounds.height)
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: self.vwCard)
    }
    
    /**
     Checks whether the next image is available and displays it.
     */
    func showNextPicture() {
        //if this is the last image, do nothing
        if Global.currentProfileImageIndex + 1 >= (currentProfile.picUrl?.count)! {
            //reset frame location though
            self.img2.frame = self.vwCard.bounds
            return
        }
        
        var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex+1]
        if (imgURL?.starts(with: "public"))! {
            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
        }
        self.img1.sd_setShowActivityIndicatorView(true)
        self.img1.sd_setIndicatorStyle(.gray)
        self.img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
        img1.center = CGPoint(x: img2.center.x, y: img2.center.y + img2.bounds.height) //-10 to hide the rounded corners
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.img2.frame
            frame.origin.y = self.vwCard.bounds.origin.y - self.vwCard.bounds.height
            frame.origin.x = self.vwCard.bounds.origin.x
            self.img2.frame = frame
            self.img1.frame = self.vwCard.bounds
        }, completion: { finished in
            //probably best to move all this to a seperate function
            //update index, set the same image as vwCard and reset position
            Global.currentProfileImageIndex += 1
            
            var imgURL = self.currentProfile.picUrl?[Global.currentProfileImageIndex]
            if (imgURL?.starts(with: "public"))! {
                imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            self.img2.sd_setShowActivityIndicatorView(true)
            self.img2.sd_setIndicatorStyle(.gray)
            self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            
            //reset pan direction
            self.isHorizontalPan = nil
            
            //reset opacity
            self.resetOpacity()
            self.cvSliderCount.reloadData()
            
            //reset frame location
            self.img2.frame = self.vwCard.bounds
        })
    }
    
    /**
     Checks whether the previous image is available and displays it.
     */
    func showPreviousPicture() {
        //if this is the first image, do nothing
        if Global.currentProfileImageIndex - 1 < 0 {
            //reset frame location though
            self.img2.frame = self.vwCard.bounds
            return
        }
        
        var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex-1]
        if (imgURL?.starts(with: "public"))! {
            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
        }
        self.img1.sd_setShowActivityIndicatorView(true)
        self.img1.sd_setIndicatorStyle(.gray)
        self.img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
        img1.center = CGPoint(x: img2.center.x, y: img2.center.y - img2.bounds.height)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.img2.frame
            frame.origin.y = self.vwCard.bounds.origin.y + self.vwCard.bounds.height
            frame.origin.x = self.vwCard.bounds.origin.x
            self.img2.frame = frame
            self.img1.frame = self.vwCard.bounds
        }, completion: { finished in
            //probably best to move all this to a seperate function
            //update index, set the same image as vwCard and reset position
            Global.currentProfileImageIndex -= 1
            
            var imgURL = self.currentProfile.picUrl?[Global.currentProfileImageIndex]
            if (imgURL?.starts(with: "public"))! {
                imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            self.img2.sd_setShowActivityIndicatorView(true)
            self.img2.sd_setIndicatorStyle(.gray)
            self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            
            //reset pan direction
            self.isHorizontalPan = nil
            
            //reset opacity
            self.resetOpacity()
            self.cvSliderCount.reloadData()
            
            //reset frame location
            self.img2.frame = self.vwCard.bounds
        })
    }
    
    /**
     Handles swipe to show the next or previous image, if available. This discards the horizontal swipes.
     
     - Parameter sender:   UISwipeGestureRecognizer triggering the event.
     */
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        
        var nextProfile:TribeNMatchable!
        if Global.currentTribeMatchable + 1 < Global.tribeSwipeList.count {
            nextProfile = Global.tribeSwipeList[(Global.currentTribeMatchable + 1)]
        }
        
        var frame = img2.frame
        var frameImg1 = img1.frame
        
        if sender.direction == .up {
            //if this is the last image, do nothing
            if Global.currentProfileImageIndex + 1 >= (currentProfile.picUrl?.count)! {
                return
            }
            //set the next image
            var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex + 1]
            if (imgURL?.starts(with: "public"))! {
                imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            img1.sd_setShowActivityIndicatorView(true)
            img1.sd_setIndicatorStyle(.gray)
            img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            
            frame.origin.x = vwCard.bounds.origin.x
            frame.origin.y = vwCard.bounds.origin.y - vwCard.bounds.height
            
            frameImg1.origin.x = vwCard.bounds.origin.x
            frameImg1.origin.y = vwCard.bounds.height //-10 to hide the corner radius
            img1.frame = frameImg1
            frameImg1.origin.y = vwCard.bounds.origin.y
        }
        else if sender.direction == .down {
            //if this is the first image, do nothing
            if Global.currentProfileImageIndex - 1 < 0 {
                return
            }
            //set the prev image
            var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex - 1]
            if (imgURL?.starts(with: "public"))! {
                imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            img1.sd_setShowActivityIndicatorView(true)
            img1.sd_setIndicatorStyle(.gray)
            img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            
            frame.origin.x = vwCard.bounds.origin.x
            frame.origin.y = vwCard.bounds.origin.y + vwCard.bounds.height
            
            frameImg1.origin.x = vwCard.bounds.origin.x
            frameImg1.origin.y = -vwCard.bounds.height
            img1.frame = frameImg1
            frameImg1.origin.y = vwCard.bounds.origin.y
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.img2.frame = frame
            self.img1.frame = frameImg1
        }, completion: { finished in
            print("swiped! now reset")
            //reset overlay opacity
            self.resetOpacity()
            
            if sender.direction == .up {
                print("swipe up")
                
                self.swipeUpComplete(self.currentProfile)
            }
            else if sender.direction == .down {
                print("swipe down")
                
                self.swipeDownComplete(self.currentProfile)
            }
            
            self.cvSliderCount.reloadData()
            self.img2.frame = self.vwCard.bounds
        })
    }
    
    //MARK: - Swipe Completion Functions
    /**
     Utility function to animate change of image when swiping up. Discards swipe if next image is not available.
     
     - Parameter currentProfile:   The profile currently being displayed.
     */
    func swipeUpComplete(_ currentProfile:TribeNMatchable!) {
        //if this is the last image, do nothing
        if Global.currentProfileImageIndex + 1 >= (currentProfile.picUrl?.count)! {
            return
        }
        
        //update index, set the same image as vwCard and reset position
        Global.currentProfileImageIndex += 1
        var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
        if (imgURL?.starts(with: "public"))! {
            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
        }
        self.img2.sd_setShowActivityIndicatorView(true)
        self.img2.sd_setIndicatorStyle(.gray)
        self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
    }
    
    /**
     Utility function to animate change of image when swiping down. Discards swipe if previous image is not available.
     
     - Parameter currentProfile:   The profile currently being displayed.
     */
    func swipeDownComplete(_ currentProfile:TribeNMatchable!) {
        //if this is the first image, do nothing
        if Global.currentProfileImageIndex - 1 < 0 {
            return
        }
        
        //update index, set the same image as vwCard and reset position
        Global.currentProfileImageIndex -= 1
        var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
        if (imgURL?.starts(with: "public"))! {
            imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
        }
        self.img2.sd_setShowActivityIndicatorView(true)
        self.img2.sd_setIndicatorStyle(.gray)
        self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
        
    }
    //MARK:- Actions
    /**
     Gets the user profile from server which in turn pushes the chat VC.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnChatAction(_ sender: UIButton) {
        UtilManager.showGlobalProgressHUDWithTitle("")
        tappedUserId = currentProfile.id
        Global.messageRequestFromVC = "userprofile"
        ServerManager.Instance.getUserDetail(userID: tappedUserId!)
    }
    
    //MARK:- Methods
    /**
     Opens chat with the user. Used when the open chat button was pressed and user profile was not fully available. This function is triggered based on server response of function triggered in `btnChatAction`
     */
    @objc func pushChatVC()
    {
        if tappedUserId == nil {
            return
        }
        
        let name = Global.profileCache[tappedUserId]?.firstName
        let phoneNumber = Global.profileCache[tappedUserId]?.phone
        let picUrl = Global.profileCache[tappedUserId]?.picUrl.first
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.messageToNum = tappedUserId
        chatVC.messageToName = name
        chatVC.picUrl = picUrl
        chatVC.messageToDeviceType = Global.profileCache[tappedUserId]?.deviceType
        chatVC.messageToToken = Global.profileCache[tappedUserId]?.firebaseToken
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    //MARK: - Block and Report
    /**
     Blocks the user and collects information about the block reason.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func blockAndReport(_ sender: Any) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Oh no!", message: "Please share more details so that we can address this", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            //getting the input values from user
            let incidentDetails = alertController.textFields?[0].text
            
            Global.blockList.append(self.currentProfile.id)
            ServerManager.Instance.deleteChat(messageTo: self.currentProfile.id, id: Global.myProfile.id)
            (self.parent as? DashboardVC)?.removeChildView()
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Incident details"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //display the alert
        self.present(alertController, animated:true, completion:nil);
    }
}

