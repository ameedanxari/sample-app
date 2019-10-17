//
//  SwipeVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class SwipeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    /**  SWIPE DIRECTIONS  **
     **  Left   - DISLIKE  **
     **  Right  - LIKE     **
     **  Up     - NEXT     **
     **  Down   - PREVIOUS **/
    fileprivate var arrOfCells: [String] = []
    let borderLayer = CAShapeLayer()
    
    @IBOutlet weak var vwOverlayBg: UIView!

    @IBOutlet weak var svRefresh: UIScrollView!
    @IBOutlet weak var vwProfileDrag: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var vwCard:UIView!
    @IBOutlet weak var vwButtons: UIView!
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

        Global.currentProfileImageIndex = 0
        // Do any additional setup after loading the view.
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
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(likeProfile), name:NSNotification.Name(rawValue: "likeProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dislikeProfile), name:NSNotification.Name(rawValue: "dislikeProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViews), name:NSNotification.Name(rawValue: "matchablesUpdated"), object: nil)

        adjustViews()
        
        getLocationAccess()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "likeProfile"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dislikeProfile"), object: nil)
        
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
        
        hideProfile()
    }
    
    // MARK: - Navigation functions
    /**
     Sets the UI elements to default states on profile card.
     */
    @objc func adjustViews() {
        refreshControl.endRefreshing()

        //if out of matchables
        if Global.matchables.count <= Global.currentMatchable {
            outOfSwipes()

            UtilManager.dismissGlobalHUD()

            return
        } else {
            vwCard.isHidden = false
            vwButtons.isHidden = false
            vwProfileDrag.isHidden = false
            cvSliderCount.isHidden = false

            vwOutOfSwipes.isHidden = true
            svRefresh.isHidden = true
        }
        
        let currentProfile = Global.matchables[Global.currentMatchable]
        
        tblProfile.reloadData()
        if currentProfile.picUrl.count > 0{
            var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
            if (imgURL?.starts(with: "public"))! {
                imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
            }
            img2.sd_setShowActivityIndicatorView(true)
            img2.sd_setIndicatorStyle(.gray)
            img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
        }
        else{
            img2.image = UIImage(named: "placeholder")
        }
        

        UtilManager.dismissGlobalHUD()
    }

    /**
     Sets the UI elements to `out of swipe` states on profile card. Displays the OutOfSwipes error view and hides the profile cards.
     */
    func outOfSwipes() {
        vwOutOfSwipes.isHidden = false
        svRefresh.isHidden = false

        vwCard.isHidden = true
        vwButtons.isHidden = true
        vwProfileDrag.isHidden = true
        cvSliderCount.isHidden = true
        borderLayer.removeFromSuperlayer()

        Global.matchables = []
        Global.currentMatchable = 0
    }

    /**
     Triggered on Pull down to refresh and gets the updated location which in turn gets the updated list of matches.
     
     - Parameter refreshControl:   The UIRefreshControl triggering the event.
     */
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getLocationAccess()
    }
    
    // MARK: -  UITableViewDelegate Mehtod 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Global.matchables.count == 0 {
            //do something if no profiles in the venue
            return 0
        }

        var currentProfile:TribeNMatchable!
        if Global.currentMatchable >= Global.matchables.count {
            currentProfile = Global.matchables.last
        } else {
            currentProfile = Global.matchables[Global.currentMatchable]
        }
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
        var currentProfile:TribeNMatchable!
        if Global.currentMatchable >= Global.matchables.count {
            currentProfile = Global.matchables.last
        } else {
            currentProfile = Global.matchables[Global.currentMatchable]
        }
        
        if arrOfCells[indexPath.row] == "user_info" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHeadTCell", for:  indexPath) as! MatchHeadTCell
            //getting first initial of last name
            var initials = ""
            var names = [String]()
            if currentProfile != nil{
                if currentProfile.firstName != nil{
                    names = currentProfile.firstName.components(separatedBy: " ")
                }
                else{
                    names.append("")
                }
                
            }
            else{
                names.append("")
            }

            if names.count > 1 {
                initials = names[0] + " " + String(names[1].first!)
            } else {
                initials = names[0]
            }
            
            if currentProfile?.age == nil {
                cell.lblHeading.text = initials// + " - n/a"
            } else {
                cell.lblHeading.text = initials + " - " + Date.getAgeFromString(string: currentProfile.age)
            }
            
            if currentProfile?.location == "" {
                cell.lblDesc.text = ""
            } else {
                cell.lblDesc.text = currentProfile?.location
            }
            
            return cell
        } else if arrOfCells[indexPath.row] == "block" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBlockTCell", for:  indexPath) as! ProfileBlockTCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchDescTCell", for:  indexPath) as! MatchDescTCell
            if currentProfile != nil{
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
            }
            
            
            return cell
        }
    }

    // MARK: -  UicollectionViewDataSource Mehtod 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            //handling any crashes due to fast swiping or any other inconsistent state!
            if Global.currentMatchable >= Global.matchables.count {
                return 0
            }
            //            maximum of 6 dots - badoo style
            let count = (Global.matchables[Global.currentMatchable].picUrl?.count)! > 6 ? 6 : Global.matchables[Global.currentMatchable].picUrl?.count
          
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
     Allows dragging of the profile image view. On vertical drag it decides whether to show or hide the next image when the drag ends. On horizontal drag it decides whether to like or dislike the profile when the drag ends.
     
     - Parameter sender:   UIPanGestureRecognizer triggering the event.
     */
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        if isHorizontalPan == nil {
            isHorizontalPan = sender.direction == .Left || sender.direction == .Right
        }

        if Global.matchables.count == 0 {
            return
        }

        var currentProfile = Global.matchables[Global.currentMatchable]
        var nextProfile:TribeNMatchable!
        if Global.currentMatchable + 1 < Global.matchables.count {
            nextProfile = Global.matchables[(Global.currentMatchable + 1)]
        }

        if(sender.state == .ended)
        {
            //All fingers are lifted.
            print("drag end")
            print(sender.velocity(in: self.view))

            //for horizontal swipe
            if isHorizontalPan == true {
                // handle swipe vs reset state here
                if (abs(img2.center.x - img1.center.x) / img1.center.x) < 0.7  && abs(sender.velocity(in: self.view).x) < 500 {
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                        self.img2.frame = self.img1.frame
                    }, completion: { finished in
                        self.resetOpacity()
                        self.isHorizontalPan = nil
                    })
                } else if (img2.center.x - img1.center.x) < 0.0 { //right - DISLIKE
                    self.dislikeProfile()
                    return
                } else if (img2.center.x - img1.center.x) > 0.0 { //left - LIKE
                    self.likeProfile()
                    return
                }
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
                        
                        var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
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

                        var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
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

        let translation = sender.translation(in: self.vwCard)

        if isHorizontalPan == true {
            //set the next profile image
            if nextProfile == nil { //if this is the last image, do something
                img1.image = nil
            } else {
                if nextProfile.picUrl.count > 0{
                    var imgURL = nextProfile.picUrl?[0]
                    if (imgURL?.starts(with: "public"))! {
                        imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                    }
                    img1.sd_setShowActivityIndicatorView(true)
                    img1.sd_setIndicatorStyle(.gray)
                    img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
                }
                else{
                    img1.image = UIImage(named: "placeholder")
                }
                
            }
            
            let scale = (abs(img2.center.x - img1.center.x) / img1.center.x) * 1.5 < 1 ? (abs(img2.center.x - img1.center.x) / img1.center.x) * 1.5 : 1
            vwOverlay.overlayState = (img2.center.x - img1.center.x) < 0 ? .Left : .Right

            img2.center = CGPoint(x: img2.center.x + translation.x, y: img2.center.y)

            self.vwOverlay.alpha = scale
            self.vwOverlay.circleRadius = vwCard.center.x / 2//(abs(img2.center.x - img1.center.x) / img1.center.x) * 1.5

            self.vwProfileDrag.alpha = 1 - scale
            self.cvSliderCount.alpha = 1 - scale
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
        var currentProfile = Global.matchables[Global.currentMatchable]

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

            var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
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
        var currentProfile = Global.matchables[Global.currentMatchable]

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

            var imgURL = currentProfile.picUrl?[Global.currentProfileImageIndex]
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
     Performs the like profile action and checks if next profile is available. If next profile is available, it displays that, otherwise calls `outOfSwipe`.
     */
    @objc func likeProfile() {
        //failsafing because somehow it always gets step ahead!
        if Global.currentMatchable >= Global.matchables.count {
            return
        }

        var currentProfile = Global.matchables[Global.currentMatchable]
        var nextProfile:TribeNMatchable!
        if Global.currentMatchable + 1 < Global.matchables.count {
            nextProfile = Global.matchables[(Global.currentMatchable + 1)]
        }

        //set the next profile image
        if nextProfile == nil { //if this is the last image, do something
            img1.image = nil
        } else {
            if nextProfile.picUrl.count > 0{
                var imgURL = nextProfile.picUrl?[0]
                if (imgURL?.starts(with: "public"))! {
                    imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                }
                img1.sd_setShowActivityIndicatorView(true)
                img1.sd_setIndicatorStyle(.gray)
                img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            }
            else{
                img1.image = UIImage(named: "placeholder")
            }
            
        }

        var frame = img2.frame
        frame.origin.x = img1.frame.origin.x + img1.frame.width
        frame.origin.y = img1.frame.origin.y

        vwOverlay.overlayState = .Right
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.img2.frame = frame
            self.vwOverlay.alpha = 1.0
            self.vwOverlay.circleRadius = 2.0
            self.vwProfileDrag.alpha = 0
            self.cvSliderCount.alpha = 0
        }, completion: { finished in
            print("swiped! now reset")
            //reset overlay opacity
            self.resetOpacity()

            self.swipeLeftComplete(currentProfile, nextProfile)

            self.cvSliderCount.reloadData()
            self.img2.frame = self.img1.frame

            self.vwOverlay.overlayState = nil
        })
    }

    /**
     Performs the dislike profile action and checks if next profile is available. If next profile is available, it displays that, otherwise calls `outOfSwipe`.
     */
    @objc func dislikeProfile() {
        //failsafing because somehow it always gets step ahead!
        if Global.currentMatchable >= Global.matchables.count {
            return
        }

        print("disliked programatically")
        var currentProfile = Global.matchables[Global.currentMatchable]
        var nextProfile:TribeNMatchable!
        if Global.currentMatchable + 1 < Global.matchables.count {
            nextProfile = Global.matchables[(Global.currentMatchable + 1)]
        }

        vwOverlay.overlayState = .Left
        
        //set the next profile image
        if nextProfile == nil { //if this is the last image, do something
            img1.image = UIImage(named: "placeholder")
        } else {
            if nextProfile.picUrl.count > 0{
                var imgURL = nextProfile.picUrl?[0]
                if (imgURL?.starts(with: "public"))! {
                    imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                }
                img1.sd_setShowActivityIndicatorView(true)
                img1.sd_setIndicatorStyle(.gray)
                img1.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            }
            else{
                img1.image = UIImage(named: "placeholder")
            }
            
        }

        var frame = img2.frame
        frame.origin.x = img1.frame.origin.x - img1.frame.width
        frame.origin.y = img1.frame.origin.y

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.img2.frame = frame
            self.vwOverlay.alpha = 1.0
            self.vwOverlay.circleRadius = 2.0
            self.vwProfileDrag.alpha = 0
            self.cvSliderCount.alpha = 0
        }, completion: { finished in
            print("swiped! now reset")
            //reset overlay opacity
            self.resetOpacity()

            self.swipeRightComplete(currentProfile, nextProfile)

            self.cvSliderCount.reloadData()
            self.img2.frame = self.img1.frame

            self.vwOverlay.overlayState = nil
        })
    }

    /**
     Handles swipe action. On vertical swipe it shows the next or previous image, if available. On horizontal swipe it performs the like or dislike option.
     
     - Parameter sender:   UISwipeGestureRecognizer triggering the event.
     */
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        var currentProfile = Global.matchables[Global.currentMatchable]
        var nextProfile:TribeNMatchable!
        if Global.currentMatchable + 1 < Global.matchables.count {
            nextProfile = Global.matchables[(Global.currentMatchable + 1)]
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
        else if sender.direction == .left {
            dislikeProfile()
            return
        }
        else if sender.direction == .right {
            likeProfile()
            return
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

                self.swipeUpComplete(currentProfile)
            }
            else if sender.direction == .down {
                print("swipe down")

                self.swipeDownComplete(currentProfile)
            }
           
            self.cvSliderCount.reloadData()
            self.img2.frame = self.vwCard.bounds
        })
    }
    
    /**
     Dislikes the profile based on button press.
     
     - Parameter sender:   UIButton calling the event.
     */
    @IBAction func dislikeProgramatically(_ sender: Any) {
        dislikeProfile()
    }
    
    /**
     Likes the profile based on button press.
     
     - Parameter sender:   UIButton calling the event.
     */
    @IBAction func likeProgramatically(_ sender: Any) {
        likeProfile()
    }
    
    /**
     Shows the last profile again after like/dislike, allowing the user to change their decision.
     
     - Parameter sender:   UIButton calling the event.
     */
    @IBAction func revertLastAction(_ sender: Any) {
        if Global.currentMatchable == 0 {
            UtilManager.showAlertMessage(message: "No actions to revert")
            return
        }
        
        Global.currentProfileImageIndex = 0
        Global.currentMatchable -= 1
        
        adjustViews()
    }
    
    //MARK: - Swipe Completion Functions
    /**
     Utility function to animate change of next profile when swiping right. Also calls the webservice to post the decision to server.
     
     - Parameter currentProfile:   The profile currently being displayed.
     - Parameter nextProfile:   The next profile to be displayed, nil if not available.
     */
    func swipeRightComplete(_ currentProfile:TribeNMatchable!, _ nextProfile:TribeNMatchable!) {
        //pass the judgement to server
        ServerManager.Instance.sendJudgement(matchableId: currentProfile.id!, isLike: 0)
        
        //update indexes, set the same image as img1 and reset position
        Global.currentProfileImageIndex = 0
        Global.currentMatchable += 1
        //        Global.currentMatchable = Global.currentMatchable
        UtilManager.prefetchImages()

        if nextProfile == nil {
            self.img2.image = UIImage(named: "placeholder")

            outOfSwipes()
        } else {
            if nextProfile.picUrl.count > 0{
                var imgURL = nextProfile.picUrl?[0]
                if (imgURL?.starts(with: "public"))! {
                    imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                }
                self.img2.sd_setShowActivityIndicatorView(true)
                self.img2.sd_setIndicatorStyle(.gray)
                self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
                
            }
            else{
                img2.image = UIImage(named: "placeholder")
            }
            
            tblProfile.reloadData()
            
            self.vwCard.layoutIfNeeded()
        }
    }

    /**
     Utility function to animate change of next profile when swiping left. Also calls the webservice to post the decision to server.
     
     - Parameter currentProfile:   The profile currently being displayed.
     - Parameter nextProfile:   The next profile to be displayed, nil if not available.
     */
    func swipeLeftComplete(_ currentProfile:TribeNMatchable!, _ nextProfile:TribeNMatchable!) {
        //pass the judgement to server
        ServerManager.Instance.sendJudgement(matchableId: currentProfile.id!, isLike: 1)

        //update indexes, set the same image as img1 and reset position
        Global.currentProfileImageIndex = 0
        Global.currentMatchable += 1
        
        UtilManager.prefetchImages()

        if nextProfile == nil {
            self.img2.image = UIImage(named: "placeholder")
            
            outOfSwipes()
        } else {
            if nextProfile.picUrl.count > 0{
                var imgURL = nextProfile.picUrl?[0]
                if (imgURL?.starts(with: "public"))! {
                    imgURL = imgURL?.replacingOccurrences(of: "public", with: TribeAPI.BaseURL.rawValue)
                }
                self.img2.sd_setShowActivityIndicatorView(true)
                self.img2.sd_setIndicatorStyle(.gray)
                self.img2.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "graydient"))
            }
            else{
                img2.image = UIImage(named: "placeholder")
            }
            
            
            tblProfile.reloadData()
            
            self.vwCard.layoutIfNeeded()
        }
    }

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
    
    //MARK: - Location Functions
    /**
     Gets the current location of the user and then stops updates of location to conserve battery
     */
    func getLocationAccess() {
        //get location access
        //get authorization for user location
        Global.locationManager.delegate = self
        Global.locationManager.pausesLocationUpdatesAutomatically = false
        //        if #available(iOS 9.0, *) {
        //            Global.locationManager.allowsBackgroundLocationUpdates = true
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
        Global.locationManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            Global.locationManager.stopMonitoringSignificantLocationChanges()
            Global.locationManager.startUpdatingLocation()
            Global.locationManager.distanceFilter = 50
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            Global.locationManager.stopMonitoringSignificantLocationChanges()
            Global.locationManager.startUpdatingLocation()
            Global.locationManager.distanceFilter = 50
        }
        else
        {
            Global.locationManager.requestWhenInUseAuthorization()
            
            if Constants.IS_DEBUG {
                print("Location Settings not enabled")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestLocation()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            // Do your thing here
            manager.requestLocation()
            manager.startUpdatingLocation()
            break
        default:
            // Permission denied, do something else
            break
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Global.locationManager.requestWhenInUseAuthorization()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let userLocation = locations.first {
            Global.myProfile.geo = [userLocation.coordinate.latitude, userLocation.coordinate.longitude]
            
            ServerManager.Instance.updateProfile(user: Global.myProfile)
            
            ServerManager.Instance.getMatchables(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            manager.stopUpdatingLocation()
        }
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
        
            if Global.currentMatchable < Global.matchables.count {
                var currentProfile = Global.matchables[Global.currentMatchable]
                Global.blockList.append(currentProfile.id)
                ServerManager.Instance.deleteChat(messageTo: currentProfile.id, id: Global.myProfile.id)
            }
            
            self.dislikeProfile()
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
