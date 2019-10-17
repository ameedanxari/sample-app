//
//  ProfileVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tblProfile: UITableView!
    
    // MARK: - Variables
    var imgSocial:UIImage!
    var imagePickerTag: Int!
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - TableView Delegates and DataSoruce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileDataTCell = tableView.dequeueReusableCell(withIdentifier: "ProfileDataTCell") as! ProfileDataTCell
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: profileDataTCell.txtInput.frame.height))
        profileDataTCell.txtInput.leftView = paddingView
        profileDataTCell.txtInput.leftViewMode = .always
        
        if indexPath.row == 0
        {
            let profilePhotosTCell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotosTCell") as! ProfilePhotosTCell
            profilePhotosTCell.cvProfileImages.delegate = self
            profilePhotosTCell.cvProfileImages.dataSource = self
            profilePhotosTCell.cvProfileImages.tag = indexPath.row
            return profilePhotosTCell
        }
        else if indexPath.row == 1
        {
            
            profileDataTCell.vwGender.isHidden = true
            profileDataTCell.vwHeightSlider.isHidden = true
            profileDataTCell.lblTitle.text = "About Me"
            profileDataTCell.txtInput.isHidden = false
            
        }
        else if indexPath.row == 2
        {
            profileDataTCell.vwGender.isHidden = false
            profileDataTCell.vwHeightSlider.isHidden = true
            profileDataTCell.lblTitle.text = "Gender"
            profileDataTCell.txtInput.isHidden = true
            
            print((profileDataTCell.vwGender.subviews[0].subviews[0] as! UIButton).imageView?.frame)
        }
        else if indexPath.row == 3
        {
            profileDataTCell.vwGender.isHidden = true
            profileDataTCell.vwHeightSlider.isHidden = false
            profileDataTCell.lblTitle.text = "Height"
            profileDataTCell.txtInput.isHidden = true
        }
        else if indexPath.row == 4
        {
            
            profileDataTCell.vwGender.isHidden = true
            profileDataTCell.vwHeightSlider.isHidden = true
            profileDataTCell.lblTitle.text = "Ethnicity"
            profileDataTCell.txtInput.isHidden = false
        }
        else if indexPath.row == 5
        {
            
            profileDataTCell.vwGender.isHidden = true
            profileDataTCell.vwHeightSlider.isHidden = true
            profileDataTCell.lblTitle.text = "Location"
            profileDataTCell.txtInput.isHidden = false
        }
        else if indexPath.row == 6
        {
            
            profileDataTCell.vwGender.isHidden = true
            profileDataTCell.vwHeightSlider.isHidden = true
            profileDataTCell.lblTitle.text = "Religion"
            profileDataTCell.txtInput.isHidden = false
        }
        else if indexPath.row == 7
        {
            
            profileDataTCell.vwGender.isHidden = true
            profileDataTCell.vwHeightSlider.isHidden = true
            profileDataTCell.lblTitle.text = "Profession"
            profileDataTCell.txtInput.isHidden = false
        }
        else
        {
            
            profileDataTCell.vwGender.isHidden = true
            profileDataTCell.vwHeightSlider.isHidden = true
            profileDataTCell.lblTitle.text = "Education"
            profileDataTCell.txtInput.isHidden = false
        }
        return profileDataTCell
    }
   
    // MARK: - CollectionView Delegates and DataSoruce
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let profilePictureVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePictureVCell", for: indexPath) as! ProfilePictureVCell
        profilePictureVCell.btnAddPic.tag = indexPath.row
        profilePictureVCell.btnRemovePic.tag = indexPath.row
        profilePictureVCell.imgMain.tag = indexPath.row
        if Global.arrimg.count > indexPath.row
        {
            profilePictureVCell.imgMain.sd_setShowActivityIndicatorView(true)
            profilePictureVCell.imgMain.sd_setIndicatorStyle(.gray)
            profilePictureVCell.imgMain.sd_setImage(with: URL(string: Global.arrimg[indexPath.row]), placeholderImage: UIImage(named: "ic_camera_full"))
            profilePictureVCell.btnRemovePic.isHidden = false
            profilePictureVCell.btnAddPic.isHidden = true
        }
        else if Global.arrimg.count + Global.arrImgTemp.count > indexPath.row {
            profilePictureVCell.imgMain.image = Global.arrImgTemp[indexPath.row - Global.arrimg.count]
            profilePictureVCell.btnRemovePic.isHidden = false
            profilePictureVCell.btnAddPic.isHidden = true
        }
        else
        {
            profilePictureVCell.imgMain.image = UIImage(named: "ic_camera_full")
            profilePictureVCell.btnRemovePic.isHidden = true
            profilePictureVCell.btnAddPic.isHidden = false
        }
        
        return profilePictureVCell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row < (Global.arrimg.count) {
            return true
        }
        if imgSocial != nil && indexPath.row == (Global.arrimg.count) {
            //Global.utilManager.showAlertMessage(message: "Please wait to re-order while the picture is being uploaded.")
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.item == destinationIndexPath.item {
            //do nothing
            return
        }
        
        if Constants.IS_DEBUG {
            print("Starting Index: \(sourceIndexPath.item)")
            print("Ending Index: \(destinationIndexPath.item)")
            
            print("Before re-ordering")
            for picture in Global.arrimg {
               print("Index: " + String(describing: picture) + "ID:" + String(describing: picture))
           }
        }
        
        let movedProfilePic = Global.arrimg.remove(at: sourceIndexPath.item)
        if destinationIndexPath.item < (Global.arrimg.endIndex) {
           Global.arrimg.insert(movedProfilePic, at: destinationIndexPath.item)
        } else {
            if Constants.IS_DEBUG {
                print(Global.arrimg.endIndex)
            }
            Global.arrimg.insert(movedProfilePic, at: (Global.arrimg.endIndex))
        }
        
        if Constants.IS_DEBUG {
            print("After re-ordering")
            for picture in
                (Global.arrimg) {
                    print("Index: " + String(describing: picture) + "ID:" + String(describing: picture))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("CollectionView: \(collectionView.tag)")
        print ("Indexpath : \(indexPath.row)")
    }
    
    /**
     Opens the action sheet with options to select picture from.
     
     - Parameter sender:   UIButton triggering the action sheet.
     */
    @IBAction func btnAddPicAction(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Select Picture", message: "", preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Pick From Gallery", style: .default, handler: { (action: UIAlertAction!) in
            let picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false;
            picker.sourceType = .photoLibrary;
            self.imagePickerTag = sender.tag
            
            self.present(picker, animated: true, completion: {
            })
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { (action: UIAlertAction!) in
            let picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .camera
            self.imagePickerTag = sender.tag
            
            self.present(picker, animated: true, completion: {
            })
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { (action: UIAlertAction!) in
            
            //Adding FacebookAlbumVc to main goto DashBoard
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addingFacebookAlbumVC"), object: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
    }
    
    // MARK: - Image Picker Delegate Functions
    /**
     Delegate method from ImagePicker when image is selected. Used to save the selected image.
     
     - Parameter picker:   UIImagePickerController triggering the event.
     - Parameter info:   Dictionary containing the information about the selected image as well as the image itself.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        //upload the image to server; probably gray it out in the meanwhile; or show a loader
        //append the image URL to the list of user profile images
        picker.dismiss(animated: true) {
            Global.arrImgTemp.append(info["UIImagePickerControllerOriginalImage"] as! UIImage)
            self.tblProfile.reloadData()
            
            //            self.base64String = UIImagePNGRepresentation(self.imgProfile.image!)!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            ServerManager.Instance.uploadPicture(picture: info["UIImagePickerControllerOriginalImage"] as! UIImage, completion: { (status: String) in
                if status == "success"{
                    print("success")
                    UtilManager.dismissGlobalHUD()
                }
                else
                {
                    print("failure")
                    UtilManager.dismissGlobalHUD()
                }
               // self?.dismiss(animated: true, completion: nil)
            })
           // ServerManager.Instance.uploadPicture(picture: , completion: )
        }
    }
    
    /**
     Delegate method from ImagePicker when the picker is cancelled. Used to dismiss the view.
     
     - Parameter picker:   UIImagePickerController triggering the event.
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
