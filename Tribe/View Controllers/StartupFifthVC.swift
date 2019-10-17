//
//  StartupFifthVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit

class StartupFifthVC: UIViewController {

    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    /**
     Pushes the Dashboard view controller.
     
     - Parameter sender:   UIButton triggering the event.
     */
    @IBAction func btnGetStartedAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        navigationController?.pushViewController(vc, animated: true)
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
