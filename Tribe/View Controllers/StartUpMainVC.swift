//
//  StartUpMainVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import CHIPageControl

class StartUpMainVC: UIViewController, UIScrollViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var pageControl: CHIPageControlFresno!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerManager.Instance.getUserData(phoneNumber: Global.user.phoneNumber)
        setupViewControllers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    /**
     Sets the view controllers for onboarding process.
     */
    func setupViewControllers()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Setup View Controllers
        let firstVC = storyboard.instantiateViewController(withIdentifier: "StartupFirstVC") as! StartupFirstVC;
        let secondVC = storyboard.instantiateViewController(withIdentifier: "StartupSecondVC") as! StartupSecondVC;
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "StartupThirdVC") as! StartupThirdVC;
        let fourthVC = storyboard.instantiateViewController(withIdentifier: "StartupFourthVC") as! StartupFourthVC;
        let fifthVC = storyboard.instantiateViewController(withIdentifier: "StartupFifthVC") as! StartupFifthVC;
        
        
        let viewControllers = [firstVC,secondVC,thirdVC,fourthVC,fifthVC]
        
        self.vwScroll.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        self.vwScroll.contentSize = CGSize(width:self.vwScroll.frame.width * 5, height:1.0)
        self.vwScroll.delegate = self
        
        var idx:Int = 0
        for viewController in viewControllers {
            
            addChild(viewController);
            let originX:CGFloat = CGFloat(idx) * self.vwScroll.frame.width;
            viewController.view.frame = CGRect(x: originX, y: 0, width: self.vwScroll.frame.width, height: self.vwScroll.frame.height);
            vwScroll!.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            idx += 1;
        }
        vwScroll.bounces = false
        self.automaticallyAdjustsScrollViewInsets = false
    }

    // MARK: - ScrollView Delegates
    /**
     Sets the view controllers progress in onboarding process and adjusts their position.
     
     - Parameter scrollView:   UIScrollView in which the event was triggered.
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0
        {
            pageControl.set(progress: 0, animated: true)
        }
        else if scrollView.contentOffset.x == self.view.frame.width
        {
            pageControl.set(progress: 1, animated: true)
        }
        else if scrollView.contentOffset.x == self.view.frame.width * 2
        {
            pageControl.set(progress: 2, animated: true)
        }
        else if scrollView.contentOffset.x == self.view.frame.width * 3
        {
            pageControl.set(progress: 3, animated: true)
        }
        else if scrollView.contentOffset.x == self.view.frame.width * 4
        {
            pageControl.set(progress: 4, animated: true)
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
