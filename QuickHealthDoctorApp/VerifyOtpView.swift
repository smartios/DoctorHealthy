//
//  VerifyOtpView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 18/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class VerifyOtpView: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var vreifyOtpImage: UIImageView!
    @IBOutlet weak var tableView: UITableView?
    var otpDictionary = NSMutableDictionary()
    var user_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - keyboard handling
    func keyboardWillShow(notification: NSNotification){
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(userInterface == .pad){
            if UIDevice.current.orientation.isLandscape
            {
                vreifyOtpImage?.image = UIImage(named: "validatelandscape")
            }else
            {
                vreifyOtpImage?.image = UIImage(named: "validateOTPportrait")
            }
        }
        else if(userInterface == .phone){
            // print("iphone")
            vreifyOtpImage?.image = UIImage(named: "09 Validate OTP")
        }
        
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
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let forgotTitle = cell.viewWithTag(1112) as! UILabel
            let attributedString = NSMutableAttributedString(string: "VALIDATE OTP")
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(2.0), range: NSRange(location: 0, length: attributedString.length))
            forgotTitle.attributedText = attributedString
            cell.backgroundColor = UIColor.clear
            return cell
        }
                else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let textField = cell.viewWithTag(17) as! UITextField
            let textField2 = cell.viewWithTag(18) as! UITextField
            let textField3 = cell.viewWithTag(19) as! UITextField
            let textField4 = cell.viewWithTag(20) as! UITextField
            textField.delegate = self
            textField2.delegate = self
            textField3.delegate = self
            textField4.delegate = self
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let paddingViewleft1 = UIView(frame:  CGRect(x: 0, y: 0, width: 8, height: 30))
            textField.leftView = paddingViewleft1
            textField.leftViewMode = UITextFieldViewMode.always
            textField.isSecureTextEntry = false
            textField.keyboardType = UIKeyboardType.numberPad
            textField2.keyboardType = UIKeyboardType.numberPad
            textField3.keyboardType = UIKeyboardType.numberPad
            textField4.keyboardType = UIKeyboardType.numberPad
            textField.isUserInteractionEnabled = true
            let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/17))
            let paddingViewleft2 = UIView(frame:  CGRect(x: 0, y: 0, width: 8, height: 30))
            textField.leftView = paddingViewleft2
            textField.leftViewMode = UITextFieldViewMode.always
            //Setting the style for the toolbar
            keyboardDoneButtonShow.barStyle = UIBarStyle .default
            //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.hideKeyboard))
            //Calculating the flexible Space.
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            //Setting the color of the button.
            doneButton.tintColor = UIColor.black
            //Making an object using the button and space for the toolbar
            let toolbarButton = [flexSpace,doneButton]
            //Adding the object for toolbar to the toolbar itself
            keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
            //Now adding the complete thing against the desired textfield
            textField.inputAccessoryView = keyboardDoneButtonShow
            textField2.inputAccessoryView = keyboardDoneButtonShow
           textField3.inputAccessoryView = keyboardDoneButtonShow
            textField4.inputAccessoryView = keyboardDoneButtonShow
            cell.backgroundColor = UIColor.clear

            return cell
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell3")
            let signupButton = cell.viewWithTag(999) as! UIButton
            signupButton.layer.cornerRadius = 5.0
            cell.backgroundColor = UIColor.clear

            return cell
        }
        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return self.view.frame.height/2 + 140
            
        }else if indexPath.row == 2
        {
            return 150
        
        }else
        {
            return 60
        }
    }
    
    
    @IBAction func backBtnTapped(sender: UIButton)
    {
    self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBtnTapped(sender: UIButton)
    {
       
        self.view.endEditing(true)
        
        if otpDictionary.object(forKey: "text1") == nil || (otpDictionary.object(forKey: "text2") == nil) || (otpDictionary.object(forKey: "text3") == nil) || (otpDictionary.object(forKey: "text4") == nil) || otpDictionary.object(forKey: "text1") as! String == "" || otpDictionary.object(forKey: "text2") as! String == "" || otpDictionary.object(forKey: "text3") as! String == "" || otpDictionary.object(forKey: "text4") as! String == ""
        
        {
           supportingfuction.showMessageHudWithMessage(message: "Please enter valid OTP.", delay: 2.0)
            return
            
        }else
        {
          otpWebService()
        }
        
     
    }
    
    @IBAction func resendOtpTapped(_ sender: UIButton) {
        // _ = navigationController?.popViewController(animated: true)
        
        resendOtpWebService()

    }
    
    
    // MARK: - textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: (aSet))
        
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if string != numberFiltered {
            return false
        }
        let hit = textField.convert(CGPoint.zero, to: tableView)
        let hitIndex3 = tableView?.indexPathForRow(at: hit)
        let cell = self.tableView!.cellForRow(at: hitIndex3!)
        let textFiled1 = cell?.viewWithTag(17) as! UITextField
        let textFiled2 = cell?.viewWithTag(18) as! UITextField
        let textFiled3 = cell?.viewWithTag(19) as! UITextField
        let textFiled4 = cell?.viewWithTag(20) as! UITextField

        if(string.characters.count == 1) {
            
            if textField == textFiled1 {
                textFiled2.becomeFirstResponder()
                textFiled1.text = string
                otpDictionary.setObject(string, forKey: "text1" as NSCopying)
                textFiled2.text = ""
                return false;
            } else if textField == textFiled2 {
                textFiled3.becomeFirstResponder()
                textFiled2.text = string
                otpDictionary.setObject(string, forKey: "text2" as NSCopying)
                textFiled3.text = ""
                return false;
            } else if textField == textFiled3 {
                textFiled4.becomeFirstResponder()
                textFiled3.text = string
                otpDictionary.setObject(string, forKey: "text3" as NSCopying)
                textFiled4.text = ""
                return false;
            }  else if textField == textFiled4 {
                textFiled4.text = string
                otpDictionary.setObject(string, forKey: "text4" as NSCopying)
                return false;
            }
        }else
        {
            
            print("Backspace has been pressed")
            if  (textFiled4.isFirstResponder) {
                textFiled3.becomeFirstResponder()
                textFiled4.text = ""
                return false;
                
            }
            else if (textFiled3.isFirstResponder) {
                textFiled2.becomeFirstResponder()
                textFiled3.text = ""
                return false;
                
            } else if (textFiled2.isFirstResponder) {
                textFiled1.becomeFirstResponder()
                textFiled2.text = ""
                return false;
                
            } else if (textFiled1.isFirstResponder) {
                textFiled1.text = ""
                return false;
            }
        }
        
        return true
    }
    
    func otpWebService()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        dict.setObject((otpDictionary.object(forKey: "text1") as! String) + (otpDictionary.object(forKey: "text2") as! String) + (otpDictionary.object(forKey: "text3") as! String) + (otpDictionary.object(forKey: "text4") as! String), forKey: "otp" as NSCopying)
        dict.setObject(user_id, forKey: "user_id" as NSCopying)
        if UserDefaults.standard.object(forKey: "device_token") != nil{
            dict.setObject(UserDefaults.standard.object(forKey: "device_token")!, forKey: "device_token" as NSCopying)
        }else{
            dict.setObject("", forKey: "device_token" as NSCopying)
        }
        dict.setObject(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id" as NSCopying)
        dict.setObject("ios", forKey: "device_type" as NSCopying)
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.otp_webmethod,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary{
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                    if dataFromServer.object(forKey: "message") != nil{
                        UserDefaults.standard.set(((dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "id_user") as! String), forKey: "user_id")
                        UserDefaults.standard.set(dataFromServer.object(forKey: "data"), forKey: "user_detail")
                        
                        UserDefaults.standard.synchronize()
                        
                        
                        if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() != "doctor"{
                            SocketIOManager.sharedInstance.isApplicationInBackground = false
                            if UserDefaults.standard.object(forKey: "user_detail") != nil && UserDefaults.standard.object(forKey: "user_detail") is NSDictionary{
                                SocketIOManager.sharedInstance.establishConnection()
                            }
                            
                            appDelegate.locationManager.startUpdatingLocation()
                        }else{
                            appDelegate.locationManager.stopUpdatingLocation()
                        }
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
                        let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
                        rootViewController.setViewControllers([pushVC], animated: true)
                        appDelegate.window!.rootViewController!.removeFromParentViewController()
                        appDelegate.window!.rootViewController!.view.removeFromSuperview()
                        appDelegate.window!.rootViewController = nil
                        appDelegate.window!.rootViewController = rootViewController
                        pushVC.selectedIndex = 3
                    }
                }else
                {
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
    
    
    
    func resendOtpWebService()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        
        
        dict.setObject(user_id, forKey: "user_id" as NSCopying)
        
        
        let apiSniper = APISniper()
       
        
        apiSniper.getDataFromWebAPI(WebAPI.resendotp_webmethod,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        // supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        if dataFromServer.object(forKey: "message") != nil
                        {
                            supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                        }
                        
                    }
                }else
                {
                    if dataFromServer.object(forKey: "message") != nil && dataFromServer.object(forKey: "message") is NSNull == false
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

    
    
        //

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
