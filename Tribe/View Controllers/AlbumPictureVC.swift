//
//  AlbumPictureVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import TOCropViewController
import SDWebImage

class AlbumPictureVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,TOCropViewControllerDelegate {
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var collecPictures: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Calling notification to reload CollectionView
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollecPictures), name: NSNotification.Name(rawValue: "reloadCollecPictures"), object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if Global.albumPictures.photos == nil
        {
            return 0
        }
        else
        {
            return Global.albumPictures.photos.data.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let albumPictureCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumPictureCCell", for: indexPath) as! AlbumPictureCCell
        albumPictureCCell.imgMain.sd_setShowActivityIndicatorView(true)
        albumPictureCCell.imgMain.sd_setIndicatorStyle(.gray)
        albumPictureCCell.imgMain.sd_setImage(with: URL(string: Global.albumPictures.photos.data[indexPath.row].images[0].source), placeholderImage: UIImage(named: "graydient"))
        return albumPictureCCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 20), height: CGFloat((collectionView.frame.size.width / 3) - 20))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imgMain.sd_setShowActivityIndicatorView(true)
        imgMain.sd_setIndicatorStyle(.gray)
        imgMain.sd_setImage(with: URL(string:Global.albumPictures.photos.data[indexPath.row].images[0].source), placeholderImage: UIImage(named: "graydient"),options: SDWebImageOptions(rawValue: 0), completed: { (img, err, cacheType, imgURL) in
            self.presentCropViewController()
        })
    }

    /**
     Gets the user profile from server which in turn pushes the chat VC.
     */
    func presentCropViewController() {
        //Load an image
        let cropViewController = TOCropViewController(image: imgMain.image!)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    /**
     Delegate method called when the user has cropped and saved the image.
     
     - Parameter cropViewController:   TOCropViewController triggering the event.
     - Parameter image:   Cropped image data.
     - Parameter cropRect:   Bounds of the CGRect to which the image was cropped.
     - Parameter angle:   Angle of rotation to which the image was adjusted.
     */
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        ServerManager.Instance.uploadPicture(picture: image, completion: { (status: String) in
            if status == "success"{
                print("success")
                UtilManager.dismissGlobalHUD()
            }
            else
            {
                print("failure")
                UtilManager.dismissGlobalHUD()
            }
        })
        //ServerManager.Instance.uploadPicture(picture: image)
        
        for vc in (self.parent?.children)! {
            if vc.classForCoder == MyProfileVC.classForCoder() {
                (vc as! MyProfileVC).imgArrTemp.append(image)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
        //Adding profileVc to Main goto DashBoradVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addingProfileVC"), object: nil)
    }
    
    
    /**
     Reloads the CollectionView UI when the pictures are recieved. Triggered via notifications.
     */
    @objc func reloadCollecPictures()
    {
        UtilManager.dismissGlobalHUD()
        collecPictures.reloadData()
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
