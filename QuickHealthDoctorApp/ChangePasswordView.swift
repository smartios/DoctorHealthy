//
//  ChangePasswordView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 24/11/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class ChangePasswordView: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var tableView: UITableView?
    var profileDictionary = NSMutableDictionary()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        UIApplication.shared.statusBarView?.backgroundColor = .white
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        //////////for current location////////////////
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
        let submit = cell.viewWithTag(21) as! UIButton
        submit.layer.cornerRadius =  5
        return cell
        
    }
    
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        let cell = tableView?.cellForRow(at: cellIndexPath!)
        let passwordT = cell?.viewWithTag(2) as! UITextField
        let newpasswordT = cell?.viewWithTag(22) as! UITextField
         let oldpasswordT = cell?.viewWithTag(44) as! UITextField
        
        print(cellIndexPath!)
        
        if oldpasswordT.text != ""
        {
            profileDictionary.setObject(oldpasswordT.text!.trimmingCharacters(in: .whitespaces), forKey: "oldpassword" as NSCopying)
        }else
        {
            profileDictionary.setObject("", forKey: "oldpassword" as NSCopying)
            
        }
        
        if passwordT.text != ""
        {
            profileDictionary.setObject(passwordT.text!.trimmingCharacters(in: .whitespaces), forKey: "password" as NSCopying)
        }else
        {
            profileDictionary.setObject("", forKey: "password" as NSCopying)
            
        }
        
        if newpasswordT.text != ""
        {
            profileDictionary.setObject(newpasswordT.text!.trimmingCharacters(in: .whitespaces), forKey: "match_password" as NSCopying)
        }else
        {
            profileDictionary.setObject("", forKey: "match_password" as NSCopying)
        }
        
        
    }

    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnClicked(sender: UIButton){
        self.view.endEditing(true)
        
        
        if profileDictionary.object(forKey: "oldpassword") == nil ||
            profileDictionary.object(forKey: "oldpassword") as! String == ""
            
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter current password.", delay: 2.0)
            return
        }
        if profileDictionary.object(forKey: "password") == nil ||
            profileDictionary.object(forKey: "password") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterPassword as NSString, delay: 2.0)
            return
            
        }else  if validationForPassword() == false
        {
            supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
            return
        }
        else if profileDictionary.object(forKey: "match_password") == nil ||
            profileDictionary.object(forKey: "match_password") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: reenterConfirmPass as NSString, delay: 2.0)
            return
        }
        else  if validationForPassword() == false
        {
            supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
            return
            
        }
        else if profileDictionary.object(forKey: "password") as! String != profileDictionary.object(forKey: "match_password") as! String
        {
            supportingfuction.showMessageHudWithMessage(message: passwordMatch as NSString, delay: 2.0)
            return
        }
        changePassword()
        
    }

    func validationForPassword() -> Bool
    {
        if profileDictionary.object(forKey: "password") as? String != nil && profileDictionary.object(forKey: "password") as! String != ""
        {
            let passwordTrimmedString = (profileDictionary.object(forKey: "password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
            
            if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
            {
                supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                
                return false
            }else  if profileDictionary.object(forKey: "match_password") as? String != nil && profileDictionary.object(forKey: "match_password") as! String != ""
            {
                let passwordTrimmedString = (profileDictionary.object(forKey: "match_password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
                
                if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
                {
                    supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    
    func changePassword()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "user_id" as NSCopying)
        dict.setObject(profileDictionary.object(forKey: "oldpassword") as! String, forKey: "old_password" as NSCopying)
        dict.setObject(profileDictionary.object(forKey: "password") as! String, forKey: "new_password" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.change_password,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    
                    supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else
                {
                    supportingfuction.hideProgressHudInView(view: self)
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    }
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    
}
