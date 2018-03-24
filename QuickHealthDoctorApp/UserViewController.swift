//
//  UserViewController.swift
//  QuickhealthDoctotApp
//
//  Created by SS043 on 09/02/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var indexCount = 0
    var dropBool = false
    var tappedIndex = -1
    
    @IBOutlet weak var titleLabel: UILabel!
    var inboxBadgeCount = String()
    var  dropDataArray1 = [" ","PROFILE","BASIC INFORMATION","BANK DETAILS","DOCUMENTS","HISTORY","SUPPORT","WAITING ROOM","TRACK","CHANGE PASSWORD",""]
    var dropDataArray = ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor" ? [" ","PROFILE","HISTORY","WAITING ROOM","CHANGE PASSWORD",""] : [" ","PROFILE","HISTORY","TRACK","CHANGE PASSWORD",""]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       UIApplication.shared.statusBarView?.backgroundColor = .clear
        self.userDetailWebService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.navigationController?.isNavigationBarHidden = true
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Arimo-Bold", size: 15)!], for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserViewController.forSelect(_:)), name: NSNotification.Name(rawValue: "forSelect"), object: nil)
    }
    
    func forSelect(_ notification: NSNotification)
    {
        
        // tabBarController?.tabBar.items?[1].isEnabled = false
        
        //self.tabBarController?.selectedIndex = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 216 + 50
        }else
        {
            if indexPath.row == 3{
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"{
                    return 50
                }
            }
            
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if indexPath.row == tappedIndex
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
        }
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
            let profile_image = cell.viewWithTag(1) as! UIImageView
            let name_label = cell.viewWithTag(2) as! UILabel
            let unique_number = cell.viewWithTag(220) as! UILabel
            
            profile_image.layer.cornerRadius = (profile_image.frame.height)/2
            profile_image.clipsToBounds = true
            
            
            // "unique_number" = VI77408SI
            
            
            
            if UserDefaults.standard.object(forKey: "user_detail") != nil  {
                if (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0 &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_image")) != nil &&
                    ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_image")) as! String != ""
                {
                    let image1 = ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_image")) as! String
                    let image_url = image1
                    
                    profile_image.setImageWith(NSURL(string: image_url) as! URL, placeholderImage: UIImage(named: "landing_image"))
                }else
                {
                    profile_image.image = UIImage(named: "landing_image")
                }
                
                
                if (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0  &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "unique_number")) != nil
                    && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "unique_number")) as! String != ""
                {
                    unique_number.text = (((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "unique_number")) as? String)
                }
                
                if (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0  &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) != nil
                    && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) as! String != ""
                    && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "last_name")) != nil
                    && ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "last_name")) as! String != ""
                {
                    name_label.text =  ((((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name")) as? String)! + " " + (((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "last_name")) as? String)!).uppercased()
                }
                
            }
            
        }else if indexPath.row == 5{
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell2")
            let name_label = cell.viewWithTag(2) as! UILabel
            name_label.text = "LOGOUT"
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell1")
            let name_label = cell.viewWithTag(2) as! UILabel
            let bgView = cell.viewWithTag(3) as UIView!
            name_label.text = dropDataArray[indexPath.row]
            let arrow = cell.viewWithTag(121) as! UIImageView
            arrow.isHidden = false
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedIndex = indexPath.row
        if indexPath.row == 1{
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryView") as! HistoryView
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.row == 3{
            if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() != "doctor"{
                let vc = PatientTrackListViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
//                let vc = VideoCallViewController(nibName: "VideoCallViewController", bundle: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.row == 4{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordView") as! ChangePasswordView
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 5{
            let alertView = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) -> Void in
                self.logoutWebService()
                return
            }))
            present(alertView, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
    func logoutUser()
    {
        UserDefaults.standard.set("", forKey: "user_detail")
        UserDefaults.standard.set("", forKey: "user_id")
        UserDefaults.standard.set("", forKey: "is_firstTime")
        SocketIOManager.sharedInstance.closeConnection()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        let navigationController = UINavigationController(rootViewController:initialViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        appDelegate.window?.rootViewController = navigationController
    }
    
    //Logout web service
    func logoutWebService(){
        if !appDelegate.hasConnectivity(){
            supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            return
        }
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        if UserDefaults.standard.object(forKey: "device_token") != nil{
            dict.setObject(UserDefaults.standard.object(forKey: "device_token")!, forKey: "device_token" as NSCopying)
        }else{
            dict.setObject("", forKey: "device_token" as NSCopying)
        }
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        apiSniper.getDataFromWebAPI(WebAPI.LOGOUT, dict, {(operation, responseObject) in
            print(responseObject)
            if let response = responseObject as? NSDictionary{
                supportingfuction.hideProgressHudInView(view: self)
                if (response.object(forKey: "error_code") != nil && "\(response.object(forKey: "error_code")!)" != "" && "\(response.object(forKey: "error_code")!)"  == "306")
                {
                    self.logoutUser()
                }else if response.object(forKey: "status") as! String == "success"{
                    self.logoutUser()
                }
            }
        },{(operation, error) in
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        })
    }
    
    func userDetailWebService(){
        if !appDelegate.hasConnectivity(){
            supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            return
        }
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        apiSniper.getDataFromWebAPI(WebAPI.userProfile, dict, {(operation, responseObject) in
            print(responseObject)
            if let response = responseObject as? NSDictionary{
                supportingfuction.hideProgressHudInView(view: self)
                 if (response.object(forKey: "error_code") != nil && "\(response.object(forKey: "error_code")!)" != "" && "\(response.object(forKey: "error_code")!)"  == "306")
                {
                    self.logoutUser()
                }else if response.object(forKey: "status") as! String == "success"{
                    if UserDefaults.standard.object(forKey: "user_detail") != nil && UserDefaults.standard.object(forKey: "user_detail") is NSDictionary{
                        let tempDict = (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
	                        tempDict.setObject((response.object(forKey: "data") as! NSDictionary).object(forKey: "user_image") as! String, forKey: "user_image" as NSCopying)
                        UserDefaults.standard.set(tempDict, forKey: "user_detail")
                    }
                    
                   self.tableView.reloadData()
                }
            }
        },{(operation, error) in
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        })
    }
    
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender )
    }
    
    
}


