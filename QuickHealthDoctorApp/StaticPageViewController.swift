//
//  StaticPageViewController.swift
//  QuickHealthdoctorApp
//
//  Created by SS043 on 09/02/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit


class StaticPageViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var pageTitle = UILabel()
    @IBOutlet weak var webView = UIWebView()
    
   // var baseURL = ""
    //var urlAddress = ""
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       webView?.scalesPageToFit = true
        
        let reach: Reachability
        do{
            reach = try Reachability.forInternetConnection()
            if reach.isReachable(){
                
                
                if appDelegate.staticpage ==  "about-us"
                {
                  pageTitle?.text = "ABOUT US"
                }else if appDelegate.staticpage ==  "terms-and-conditions"
                {
                    pageTitle?.text = "TERMS & CONDITIONS"
  
                }else
                {
                   pageTitle?.text = "PRIVACY POLICY"
                }
                
                getUserData()
            }else
            {
                supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            }
        }
        catch{
            
        }
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func backbtnTapped(sender: UIButton){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disagreebtnClicked"), object: nil)
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func agreeTapped(sender: UIButton){
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "agreebtnClicked"), object: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }

    
    func getUserData()
        
    {
                   //  let url = URL (string: ("http://115.249.91.204/quickhealth/mobile/mobile_static_page/static_page?page_name=\(appDelegate.staticpage)" ))
        
       let url = URL (string: ("http://103.15.232.35/singsys-stg3/quickhealth/mobile/mobile_static_page/static_page?page_name=\(appDelegate.staticpage)" ))
                    let requestObj = URLRequest(url: url!)
                    self.webView?.loadRequest(requestObj)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        supportingfuction.hideProgressHudInView(view: self)
    }

}
