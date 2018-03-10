//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    var page = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - slideMenuItemSelectedAtIndex
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 1:
            print("OurmissionViewController\n", terminator: "")
            
                       page = "about-us"
            self.openViewControllerBasedOnIdentifier("StaticPageViewController")
            
            break
        case 2:
            print("HowitWorksViewController\n", terminator: "")
            
             page = "terms-and-conditions"
            self.openViewControllerBasedOnIdentifier("StaticPageViewController")
           

            break
        case 3:
            print("OurFeesViewController\n", terminator: "")
             page = "privacy-policy"
            self.openViewControllerBasedOnIdentifier("StaticPageViewController")

            break
        case 4:
            print("FAQViewController\n", terminator: "")
            page = ""
            self.openViewControllerBasedOnIdentifier("SupportView")
            
            break
            
        case 5:
            print("FAQViewController\n", terminator: "")
            page = ""

            self.openViewControllerBasedOnIdentifier("FAQViewController")
            
            break
            

       
        default:
            print("default\n", terminator: "")
        }
    }
    
    // MARK: - openViewControllerBasedOnIdentifier
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        // added this due to identify storyboard bcz called it from both stroyboard
        let destViewController : UIViewController =  UIStoryboard(name: "TabbarStoryboard", bundle: nil).instantiateViewController(withIdentifier: strIdentifier)
        // added this when call only from single storyboard.
        //  let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            
            if page != ""
            {
            appDelegate.staticpage = page
            }
            else
            {
                appDelegate.staticpage = ""
            }
            
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    // MARK: - onSlideMenuButtonPressed
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
}
