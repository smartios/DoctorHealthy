//
//  SupportView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 10/11/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class SupportView: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate {
    //admin_contact_no
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var callbuton: UIButton!
   
    var supportDictionary = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyOtpView.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        if UserDefaults.standard.object(forKey: "user_detail") != nil  {
            if (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0 &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "admin_contact_no")) != nil &&
                ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "admin_contact_no")) as! String != ""
            {
                callbuton.setTitle(((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "admin_contact_no")) as? String, for: .normal)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        supportDictionary.setObject("", forKey: "message" as NSCopying)
        supportDictionary.setObject("", forKey: "email" as NSCopying)
    }
    
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
        var rect = self.view.frame as CGRect
        rect.size.height -= keyboardFrame.height

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
            cell = tableView.dequeueReusableCell(withIdentifier: "cell0")

        }
        
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
        }
       else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell3")
            let textview = cell.viewWithTag(1999) as! UITextView
            textview.delegate = self
//            textViewDidChange(textview)
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            let submitButton = cell.viewWithTag(999) as! UIButton
            submitButton.layer.cornerRadius = 5.0
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 175
            
        }
        else if indexPath.row == 1
        {
            return 51
            
        }
        else if indexPath.row == 2
        {
            return 150
        }
        else
        {
            return 100
            
        }
    }
    
    @IBAction func contactUsBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if let x = supportDictionary.object(forKey: "email") as? String,x.characters.count != 0{
            
        }else{
            supportingfuction.showMessageHudWithMessage(message: "Please enter Email." as NSString, delay: 2.0)
            return
        }
        if (CommonValidations.isValidEmail(testStr: supportDictionary.object(forKey: "email") as! String ) ) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validEmail as NSString, delay: 2.0)
            return
        }
        if supportDictionary.object(forKey: "message") == nil ||
            (supportDictionary.object(forKey: "message") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter Message." as NSString, delay: 2.0)
            return
        }
        contact_us()
    }
    @IBAction func callButtonTapped(_ sender: UIButton) {
      //  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "admin_contact_no")) as! String
        
        
        var aString = ""
        if UserDefaults.standard.object(forKey: "user_detail") != nil  {
            if (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).count>0 &&  ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "admin_contact_no")) != nil &&
                ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "admin_contact_no")) as! String != ""
            {
             aString = ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "admin_contact_no")) as! String
            }
        }
        

        let newString = aString.replacingOccurrences(of: " ", with: "")
        
        
        let phone = newString
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    
        if (textView.text?.characters.count)!>0{
            supportDictionary.setObject(textView.text!.trimmingCharacters(in: .whitespaces), forKey: "message" as NSCopying)
            
        }else
        {
            supportDictionary.setObject("", forKey: "message" as NSCopying)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)!>0{
            supportDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "email" as NSCopying)

            }else
        {
            supportDictionary.setObject("", forKey: "email" as NSCopying)
        }
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        let msgLbl = cell?.viewWithTag(333) as! UILabel
        msgLbl.isHidden = false

        if textView.text.characters.count + (text.characters.count - range.length) > 0
        {
          msgLbl.isHidden = true
        }
        
        //self.tableView.beginUpdates()
        //self.tableView.endUpdates()
        return true
    }
    
    
    func contact_us()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        dict.setObject(supportDictionary.object(forKey: "email") as! String, forKey: "email_id" as NSCopying)
        dict.setObject(supportDictionary.object(forKey: "message") as! String, forKey: "message" as NSCopying)

        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        
        apiSniper.getDataFromWebAPI(WebAPI.contact_us,dict, {(operation, responseObject) in
            
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
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
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
    

    
    
    
    
    
}


