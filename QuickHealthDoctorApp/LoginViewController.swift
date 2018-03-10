//
//  ForgotPasswordView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 19/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView?
    var userInterface = UIDevice.current.userInterfaceIdiom

    @IBOutlet weak var textView: UITextView?
    
    @IBOutlet weak var loginScreenImage: UIImageView!
    var signUpDictionary = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if(userInterface == .pad){
        if UIDevice.current.orientation.isLandscape
        {
            loginScreenImage?.image = UIImage(named: "loginlandscape")
        }else
        {
            loginScreenImage?.image = UIImage(named: "loginportrait")
        }
         }
    else if(userInterface == .phone){
    // print("iphone")
    loginScreenImage?.image = UIImage(named: "06-login")
    
    }

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

        if textField.tag == 1
        {
            let txtf = cell?.viewWithTag(2)
            txtf?.becomeFirstResponder()
        }
        else if textField.tag == 2
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
        let textFieldEmail = cell.viewWithTag(1) as! UITextField
        let textFieldPasswodr = cell.viewWithTag(2) as! UITextField
         let textView = cell.viewWithTag(2000) as! UITextView
        
        let loginButton = cell.viewWithTag(999) as! UIButton

        loginButton.layer.cornerRadius = 5.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.navigateToSignup))
        textView.addGestureRecognizer(tap)
        //iPhone
        print("iphone")
        let atrStr = NSMutableAttributedString(string: "Don't have an account? Contact Us.")
        atrStr.addAttribute(NSLinkAttributeName, value: "www.google.com", range: NSRange(location: 23, length: ("Contact Us.").utf16.count))
        atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 23, length: ("Contact Us.").utf16.count))
        atrStr.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 23, length: ("Contact Us.").utf16.count))
        
        atrStr.addAttribute(NSFontAttributeName, value:UIFont(name: "Arimo-Regular", size: 15.0)! , range: NSRange(location: 23, length: ("Contact Us.").utf16.count))
        
        
        textView.attributedText = atrStr
        
        if signUpDictionary.object(forKey: "email") != nil && signUpDictionary.object(forKey: "email") as! String != ""
        {
            textFieldEmail.text = signUpDictionary.object(forKey: "email") as? String
        }else
        {
            textFieldEmail.text = ""
        }
        
        if signUpDictionary.object(forKey: "password") != nil && signUpDictionary.object(forKey: "password") as! String != ""
        {
            textFieldPasswodr.text = signUpDictionary.object(forKey: "password") as? String
        }else
        {
            textFieldPasswodr.text = ""
        }
        cell.backgroundColor = UIColor.clear

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
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

    
    func navigateToSignup()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupView") as! SignupView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func ResetPasswordBtnTapped(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordView") as! ForgotPasswordView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnTApped(sender: UIButton)
    {
        
        self.view.endEditing(true)
        
        if let x = signUpDictionary.object(forKey: "email") as? String,x.characters.count != 0{
            
        }else{
            supportingfuction.showMessageHudWithMessage(message: "Please enter email." as NSString, delay: 2.0)
            return
        }
        
        if (CommonValidations.isValidEmail(testStr: signUpDictionary.object(forKey: "email") as! String ) ) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validEmail as NSString, delay: 2.0)
            return
        }
        
        
        if let x = signUpDictionary.object(forKey: "password") as? String,x.characters.count != 0{
            
        }else{
            supportingfuction.showMessageHudWithMessage(message: "Please enter password." as NSString, delay: 2.0)
            return
        }
        
        loginWebService()
        
        
    }
    
    
    
    @IBAction func backBtnTapped(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordView") as! ForgotPasswordView
        self.navigationController?.pushViewController(vc, animated: true)
       // _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1
        {
            
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "email" as NSCopying)
                
            }else
            {
                signUpDictionary.setObject("", forKey: "email" as NSCopying)
            }
            
        }else if textField.tag == 2
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "password" as NSCopying)
                
            }else
            {
                signUpDictionary.setObject("", forKey: "password" as NSCopying)
            }
            
        }
        
    }
    
    
    
    func loginWebService()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(signUpDictionary.object(forKey: "email") as! String, forKey: "email" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "password") as! String, forKey: "password" as NSCopying)
      
        dict.setObject("doctor", forKey: "user_type" as NSCopying)
        print(dict)
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.login_webmethod,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpView") as! VerifyOtpView
                        vc.user_id = (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "id_user") as! String
                        self.navigationController?.pushViewController(vc, animated: true)
                       
                        
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
