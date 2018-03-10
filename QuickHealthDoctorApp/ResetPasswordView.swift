//
//  ResetPasswordView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 19/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class ResetPasswordView: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var userInterface = UIDevice.current.userInterfaceIdiom

    @IBOutlet weak var resetImage: UIImageView!
    @IBOutlet weak var tableView: UITableView?
    var user_id = String()
    var signUpDictionary = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(userInterface == .pad){
            if UIDevice.current.orientation.isLandscape
            {
                resetImage?.image = UIImage(named: "validatelandscape")
            }else
            {
                resetImage?.image = UIImage(named: "validateOTPportrait")
            }
        }
        else if(userInterface == .phone){
            // print("iphone")
            resetImage?.image = UIImage(named: "09 Validate OTP")
            
        }
        
    }

    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    /**
     *  function to be called on keyboard get invisible
     *
     *  @param notification reference of NSNotification
     */
    
    
    func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let hit = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hit)
        let cell = tableView?.cellForRow(at: indexPath!)
        
        if textField.tag == 2
        {
            let txtf = cell?.viewWithTag(22)
            txtf?.becomeFirstResponder()
        }
        else if textField.tag == 22
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
          cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
        let signupButton = cell.viewWithTag(999) as! UIButton
        signupButton.layer.cornerRadius = 5.0
        cell.backgroundColor = UIColor.clear
//        let textfield1 = cell.viewWithTag(2) as! UITextField
//        let textfield2 = cell.viewWithTag(22) as! UITextField
//
//        textfield1.returnKeyType = .next
//        textfield2.returnKeyType = .done

        return cell
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
       return self.view.frame.height - 100
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        let cell = tableView?.cellForRow(at: cellIndexPath!)
        let passwordT = cell?.viewWithTag(2) as! UITextField
        let newpasswordT = cell?.viewWithTag(22) as! UITextField

        print(cellIndexPath!)
        
        
            if passwordT.text != ""
            {
                signUpDictionary.setObject(passwordT.text!.trimmingCharacters(in: .whitespaces), forKey: "password" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "password" as NSCopying)
                
            }
            
            if newpasswordT.text != ""
            {
                signUpDictionary.setObject(newpasswordT.text!.trimmingCharacters(in: .whitespaces), forKey: "match_password" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "match_password" as NSCopying)
            }
    

    }
    
    
    
    @IBAction func resetOtpTapped(_ sender: UIButton) {
          self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func submitBtnClicked(sender: UIButton){
        self.view.endEditing(true)
         if signUpDictionary.object(forKey: "password") == nil ||
            signUpDictionary.object(forKey: "password") as! String == ""
        
        {
            supportingfuction.showMessageHudWithMessage(message: enterPassword as NSString, delay: 2.0)
            return
            
         }else  if validationForPassword() == false
         {
            supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
            return

         }
            else if signUpDictionary.object(forKey: "match_password") == nil ||
            signUpDictionary.object(forKey: "match_password") as! String == ""
         {
            supportingfuction.showMessageHudWithMessage(message: enterConfirmPass as NSString, delay: 2.0)
            return
        }
         else  if validationForPassword() == false
         {
            supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
            return
            
         }
         else if signUpDictionary.object(forKey: "password") as! String != signUpDictionary.object(forKey: "match_password") as! String
        {
            supportingfuction.showMessageHudWithMessage(message: passwordMatch as NSString, delay: 2.0)
            return
        }
        reset_password()

    }

    func validationForPassword() -> Bool
    {
        if signUpDictionary.object(forKey: "password") as? String != nil && signUpDictionary.object(forKey: "password") as! String != ""
        {
            let passwordTrimmedString = (signUpDictionary.object(forKey: "password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
            
            if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
            {
                supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                
                return false
            }else  if signUpDictionary.object(forKey: "match_password") as? String != nil && signUpDictionary.object(forKey: "match_password") as! String != ""
            {
                let passwordTrimmedString = (signUpDictionary.object(forKey: "match_password") as! String).trimmingCharacters(in: CharacterSet.whitespaces)
                
                if(!CommonValidations.isValidPassword(testStr: passwordTrimmedString))
                {
                    supportingfuction.showMessageHudWithMessage(message: validPassword as NSString, delay: 2.0)
                    
                    return false
                }
                
            }

            
        }
        
        return true
    }
    
    func reset_password()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(user_id, forKey: "user_id" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "password") as! String, forKey: "new_password" as NSCopying)
      
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.reset_password,dict, {(operation, responseObject) in
            
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

    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
