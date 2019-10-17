//
//  FacebookAlbumVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class FacebookAlbumVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblAlbum: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Calling notification to reload TableView
        NotificationCenter.default.addObserver(self, selector: #selector(realodtblAlbum), name: NSNotification.Name(rawValue: "realodtblAlbum"), object: nil)
        
        UtilManager.showGlobalProgressHUDWithTitle("Please wait...")
        ServerManager.Instance.getFacebookAlbum()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - TableView Delegates and DataSoruce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Global.facebookAlbum.albums == nil
        {
            return 0
        }
        else
        {
            return Global.facebookAlbum.albums.data.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let facebookAlbumTCell = tableView.dequeueReusableCell(withIdentifier: "FacebookAlbumTCell") as! FacebookAlbumTCell
        facebookAlbumTCell.lblName.text = Global.facebookAlbum.albums.data[indexPath.row].name
        facebookAlbumTCell.lblCount.text = "\(Global.facebookAlbum.albums.data[indexPath.row].photoCount!)"
        facebookAlbumTCell.imgAlbum.sd_setShowActivityIndicatorView(true)
        facebookAlbumTCell.imgAlbum.sd_setIndicatorStyle(.gray)
        facebookAlbumTCell.imgAlbum.sd_setImage(with: URL(string: Global.facebookAlbum.albums.data[indexPath.row].picture.data.url!), placeholderImage: UIImage(named: "graydient"))
        return facebookAlbumTCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UtilManager.showGlobalProgressHUDWithTitle("Please wait...")
        ServerManager.Instance.getAlbumPictures(albumId: Global.facebookAlbum.albums.data[indexPath.row].id!)
    
        //Adding AlbumPictureVC on containerview goto DashboardVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addingAlbumPictureVC"), object: nil)
        
    }
    
    /**
     Reloads the TableView UI when the albums are recieved. Triggered via notifications.
     */
    @objc func realodtblAlbum()
    {
        UtilManager.dismissGlobalHUD()
        tblAlbum.reloadData()
        if Global.facebookAlbum.albums == nil{
            UtilManager.showAlertMessage(message: "We were unable to access your Facebook pictures. Please change your Facebook privacy settings and try again.")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addingProfileVC"), object: nil)
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
