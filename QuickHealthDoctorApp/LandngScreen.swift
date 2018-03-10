//
//  ViewController.swift
//  QuickHealthdoctorApp
//
//  Created by SS043 on 06/02/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit

class LandngScreen: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var view1Image: UIImageView?
    @IBOutlet weak var view2Image: UIImageView?
    @IBOutlet weak var view3Image: UIImageView?
    var userInterface = UIDevice.current.userInterfaceIdiom
    let totalPages = 03
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        scrollView.isUserInteractionEnabled = false
      

        // Do any additional setup after loading the view, typically from a nib.
    }
   

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        scrollView.isPagingEnabled = true
        if(userInterface == .pad){
            //iPads
           // print("iPad")
            if UIDevice.current.orientation.isLandscape
            {
                view1Image?.image = UIImage(named: "landinglandsacpe")
                view2Image?.image = UIImage(named: "landinglandsacpe")
                view3Image?.image = UIImage(named: "landinglandsacpe")
            }else
            {
                view1Image?.image = UIImage(named: "landingportrait")
                view2Image?.image = UIImage(named: "landingportrait")
                view3Image?.image = UIImage(named: "landingportrait")
            }
            
        }else if(userInterface == .phone){
            //iPhone
           // print("iphone")
            view1Image?.image = UIImage(named: "02-landing.png")
            view2Image?.image = UIImage(named: "02-landing.png")
            view3Image?.image = UIImage(named: "02-landing.png")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the following flag values.
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        configurePageControl()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureScrollView()
    {
        scrollView.contentSize = CGSize(width: view.frame.size.height * CGFloat(totalPages), height: view.frame.size.width)
    }
    // MARK: Custom method implementation
    
    func configurePageControl() {
        // Set the total pages to the page control.
        pageControl.numberOfPages = totalPages
        // Set the initial page.
        pageControl.currentPage = 0
    }
    
    // MARK: UIScrollViewDelegate method implementation
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the new page index depending on the content offset.
        let currentPage = floor(scrollView.contentOffset.x / UIScreen.main.bounds.size.width);
        
        // Set the new page index to the page control.
        pageControl.currentPage = Int(currentPage)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollView.isPagingEnabled = true
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        scrollView.layoutIfNeeded()
        
        
        
        if (size.width / size.height > 1) {
           // print("landscape")
            view1Image?.image = UIImage(named: "landinglandsacpe")
            view2Image?.image = UIImage(named: "landinglandsacpe")
            view3Image?.image = UIImage(named: "landinglandsacpe")
            configureScrollView()
        } else {
           // print("portrait")
            view1Image?.image = UIImage(named: "landingportrait")
            view2Image?.image = UIImage(named: "landingportrait")
            view3Image?.image = UIImage(named: "landingportrait")

            configureScrollView()
        }
    }
    
    @IBAction func clickMeToSkip(sender: UIButton)
    {
        UserDefaults.standard.set("is_firstTime", forKey: "is_firstTime")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(pushVC, animated: true)
        
        let rootViewController = appDelegate.window?.rootViewController as! UINavigationController
        rootViewController.setViewControllers([pushVC], animated: true)
        appDelegate.window!.rootViewController!.removeFromParentViewController()
        appDelegate.window!.rootViewController!.view.removeFromSuperview()
        appDelegate.window!.rootViewController = nil
        appDelegate.window!.rootViewController = rootViewController
    }
    
    // MARK: IBAction method implementation
    @IBAction func changePage(sender: AnyObject) {
        // Calculate the frame that should scroll to based on the page control current page.
        var newFrame = scrollView.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(pageControl.currentPage)
        scrollView.scrollRectToVisible(newFrame, animated: true)
        
    }
    
}

