//
//  FamilyHistoryController.swift
//  QuickHealthDoctorApp
//
//  Created by SS21 on 24/01/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class FamilyHistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, toWhomList {
    
    var selectedIndex = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var switchBtn: UISwitch!
    var historyDict = NSMutableArray()
    var family_history_array = NSArray()
    var historyData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        familyHistory()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //   MARK:- table view methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDict.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
       
        
        if(indexPath.row == historyDict.count)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
        }else
        {
                if ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String).lowercased() == "other"{
                    if ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as! String).lowercased() == ""{
                        cell = tableView.dequeueReusableCell(withIdentifier: "otherHeaderCell")
                        let titleLabel = cell.viewWithTag(1) as! UILabel
                        let switchBtn = cell.viewWithTag(2) as! UIButton
                        titleLabel.text = ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String)
                        switchBtn.isSelected = false
                    }else{
                        cell = tableView.dequeueReusableCell(withIdentifier: "othersCell")
                        let titleLabel = cell.viewWithTag(1) as! UILabel
                        let switchBtn = cell.viewWithTag(2) as! UIButton
                        let descriptionField = cell.viewWithTag(5) as! UITextField
                        descriptionField.isUserInteractionEnabled = true
                        let toWhome = cell.viewWithTag(3) as!  UITextField
                        toWhome.isUserInteractionEnabled = false
                        titleLabel.text = ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String)
                        
                        toWhome.text = (historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as? String
                        
                        descriptionField.placeholder = "Description"
                        
                        descriptionField.text = ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "other_description") as! String)
                        
                        if let x = (historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as? String{
                            if x == ""
                            {
                                switchBtn.isSelected = false
                                
                            }else
                            {
                                switchBtn.isSelected = true
                            }
                        }
                    }
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell")
                    let titleLabel = cell.viewWithTag(1) as! UILabel
                    let switchBtn = cell.viewWithTag(2) as! UIButton
                    let toWhome = cell.viewWithTag(3) as!  UITextField
                    toWhome.isUserInteractionEnabled = false
                    titleLabel.text = ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String)
                    
                    toWhome.text = (historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as? String
                    
                    
                    if let x = (historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as? String{
                        if x == ""{
                            switchBtn.isSelected = false
                        }else{
                            switchBtn.isSelected = true
                        }
                    }
                }
        
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == historyDict.count)
        {
            return 130
        } else
        {
            if  ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String) == ""{
                return 0
            }
            if  historyDict.count > 0 && ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as? String) == ""
            {
                return 40
            }else if ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String).lowercased() == "other"{
                return 170
            }else{
                return 125
            }
        }
    }
    
    
    
    // MARK:- Buttons Methods
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toWhomBtn(_ sender: UIButton) {
        let hitPoint: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        toWhomeListService()
        selectedIndex = (indexPath![1])
        
    }
    
    @IBAction func switchBtn(_ sender: UIButton) {
        let hitPoint: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        selectedIndex = (indexPath![1])
        if sender.isSelected == false{
            let tempDic:NSMutableDictionary = ((self.historyDict.object(at: selectedIndex) as! NSDictionary) ).mutableCopy() as! NSMutableDictionary
            tempDic.setValue("To", forKey: "to_whom")
            self.historyDict.replaceObject(at: selectedIndex, with: tempDic)
            sender.isSelected = true
        }else{
            let tempDic:NSMutableDictionary = ((self.historyDict.object(at: selectedIndex) as! NSDictionary) ).mutableCopy() as! NSMutableDictionary
            tempDic.setValue("", forKey: "to_whom")
            self.historyDict.replaceObject(at: selectedIndex, with: tempDic)
            sender.isSelected = false
        }
        tableView?.reloadData()
    }
    
    
    func getToWhom(toWhom: String) {
        let tempDic:NSMutableDictionary = ((self.historyDict.object(at: selectedIndex) as! NSDictionary) ).mutableCopy() as! NSMutableDictionary
        
        tempDic.setValue(toWhom, forKey: "to_whom")
        
        self.historyDict.replaceObject(at: selectedIndex, with: tempDic)
        
        tableView?.reloadData()
        
    }
    
    //MARK:- Textfield Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let hitPoint: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        if ((historyDict.object(at: (indexPath?.row)!) as! NSDictionary).object(forKey: "title") as! String).lowercased() == "other"{
            let dict = (historyDict.object(at: (indexPath?.row)!) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let text = textField.text!
            dict.setObject(text.trimmingCharacters(in: .whitespaces), forKey: "other_description" as NSCopying)
            historyDict.replaceObject(at: (indexPath?.row)!, with: dict)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        self.setData()
        
    }
    
    // MARK:- Web Services
    
    func familyHistory()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        print(historyData)
        
        //        var id_appoitment = historyData.object(forKey: "appointment_id")
        //        dict.setObject(id_appoitment, forKey: "id_appointment" as NSCopying)
        //        var  id_nurse = historyData.object(forKey: "id_nurse")
        //        var  id_patient = historyData.object(forKey: "id_patient")
        //
        dict.setObject(historyData.object(forKey: "appointment_id") as! String, forKey: "id_appointment" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.family_history, dict, { (operation, responseObject) in
            
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    self.historyDict = ((dataFromServer).object(forKey: "data") as! NSArray).mutableCopy() as! NSArray as! NSMutableArray;
                    
                    self.tableView?.reloadData()
                    
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
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
    
    func setData(){
        let tempArray = NSMutableArray()
        for item in self.historyDict{
            if ((item as! NSDictionary).object(forKey: "to_whom") as! String).lowercased() == "to"{
                supportingfuction.showMessageHudWithMessage(message: "Please select to whome for \((item as! NSDictionary).object(forKey: "title") as! String)." as NSString, delay: 2.0)
                return
            }else if (item as! NSDictionary).object(forKey: "to_whom") as! String != "to"{
                if ((item as! NSDictionary).object(forKey: "title") as! String).lowercased() == "other" && (item as! NSDictionary).object(forKey: "to_whom") as! String != "" && ((item as! NSDictionary).object(forKey: "other_description") as! String).lowercased() == ""{
                    supportingfuction.showMessageHudWithMessage(message: "Please enter description for other field." as NSString, delay: 2.0)
                    return

                }
                tempArray.add(item)
            }
        }
        self.historyDict.removeAllObjects()
        self.historyDict = tempArray
        self.familyHistoryEdit()
    }
    
    
    func familyHistoryEdit()
    {
        
        
        let dict = NSMutableDictionary()
        

                dict.setObject(historyData.object(forKey: "appointment_id") as! String, forKey: "id_appointment" as NSCopying)

        
                dict.setObject(historyData.object(forKey: "nurse_id") as! String, forKey: "id_nurse" as NSCopying)
                dict.setObject(historyData.object(forKey: "user_id") as! String, forKey: "id_patient" as NSCopying)
        
                var tempJson2 : NSString = ""
//        let x = (historyDict.object(at: selectedIndex) as! NSDictionary).object(forKey: "to_whom") as? String
//        if x == "to"
//        {
//            supportingfuction.showMessageHudWithMessage(message: "Please enter to whom value.", delay: 2.0)
//            return
//
//        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: self.historyDict as NSArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            
            tempJson2 = string! as NSString
            print(tempJson2)
        }catch let error as NSError{
            print(error.description)
        }
        
        dict.setObject(tempJson2, forKey:"family_history_array" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.family_history_edit, dict, { (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary{
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    self.historyDict = ((dataFromServer).object(forKey: "data") as! NSArray).mutableCopy() as! NSArray as! NSMutableArray;
                    
                    self.navigationController?.popViewController(animated: true)
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
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
    func toWhomeListService()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToWhomeListingController") as! ToWhomeListingController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
