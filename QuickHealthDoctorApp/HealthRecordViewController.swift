//
//  HealthRecordViewController.swift
//  QuickHealthdoctorApp
//
//  Created by SS21 on 04/04/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit


class HealthRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,countryList {
   // SelectedValueDelegate
    
    //variable for storing indexpath of table
    var tempIndexPath = IndexPath()
    //variables for number of rows returns in each sections
    var medicalRowVar = 0
    var allergiesRowVar = 0
    var surgeriesRowVar = 0
    var conditionRowVar = 0
    // Mutable Array and Dictionary Using for recieving and sending data to Webservice
    var medicalConditionArray = NSMutableArray()
    var surgaryArray = NSMutableArray()
    var medicationDict = NSMutableDictionary()
    var allergyDict = NSMutableDictionary()
    var is_medication = "no"
    var is_surgeries_medical_procedure = "no"
    var is_medical_condition = "no"
    //String Type Variable
    var medicationName = ""
    var strength = ""
    var reason1 = ""
    var usages1 = ""
    var usagesId = ""
   
    var dict = NSMutableDictionary()
    var medicationDuration = "For how long?"
    var medicationcode = ""
    var ncode =  ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewheader = UIView()
    var id_appointment = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let customInfoWindow = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?[0]
//        tableView?.tableHeaderView = customInfoWindow as! UIView?
        //Web service give data from database
        self.tableView.rowHeight = 150
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        if(!appDelegate.hasConnectivity())
        {
            //.showMessageHudWithMessage(message: NoInternetConnection as NSString, delay: 2.0)
        }
        else
        {
            getUserData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(HealthRecordViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HealthRecordViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:- TableViewDelegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return medicalRowVar + 1 //one extra row for heading in section
        }
        else if section == 1
        {
            return allergiesRowVar + 1 //one extra row for heading in section
        }
        else if section == 2
        {
            return surgeriesRowVar + 1 //one extra row for heading in section
        }
        else
        {
            return conditionRowVar + 2 //two extra row for heading in section
        }
    }
    //MARK:- TABLEVIEW DELEGATE AND DATASOURCE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        //let paddingViewleft1 = UIView(frame:  CGRect(x: 0, y: 0, width: 8, height: 30))
        if indexPath.row == 0 { //For all sections first row this will executes
            if indexPath.section == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "HeadingCell")
                let yesButton = cell.viewWithTag(2) as! UIButton
                let label = cell.viewWithTag(3) as! UILabel
                let headlabel = cell.viewWithTag(5) as! UILabel
                headlabel.text = "MEDICAL HISTORY"
                label.text = "Are you currently taking any medication?"
                if medicalRowVar > 0{
                    yesButton.isSelected = true
                }else{
                    yesButton.isSelected = false
                }
            }else{
              cell = tableView.dequeueReusableCell(withIdentifier: "HeadingCellNew")
                let yesButton = cell.viewWithTag(2) as! UIButton
                let label = cell.viewWithTag(3) as! UILabel
                if indexPath.section == 1{
                    label.text = "Do you have any allergies or drug sensitivities?"
                    if allergiesRowVar > 0{
                        yesButton.isSelected = true
                    }else{
                        yesButton.isSelected = false
                    }
                }else if indexPath.section == 2
                {
                    label.text = "Have you ever had any surgeries or medical procedures?"
                    if surgeriesRowVar > 0{
                        yesButton.isSelected = true
                    }else{
                        yesButton.isSelected = false
                    }
                }else{
                    label.text = "Have you ever had any medical conditions?"
                    
                    if conditionRowVar > 0{
                        yesButton.isSelected = true
                    }else{
                        yesButton.isSelected = false
                    }
                }
            }
        }else if indexPath.section == 0 //for first section
        {
            if indexPath.row > 0 && indexPath.row < medicalRowVar//for all rows grater then 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "medicationRecordCell")
                let textField = cell.viewWithTag(1) as! UITextField
                let addMoreButton = cell.viewWithTag(3) as! UIButton
                let usages = cell.viewWithTag(23) as! UIButton
                usages.setTitle(usages1, for: .normal)

               // textField.leftView = paddingViewleft1
                //textField.leftViewMode = UITextFieldViewMode.always
                textField.placeholder = " MEDICINE"
                //textField.text = medicationName
                //whenButton.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0)
                let strenth = cell.viewWithTag(21) as! UITextField
                let reason = cell.viewWithTag(11) as! UITextField
                strenth.placeholder = "STRENGTH"
                reason.placeholder = "REASON FOR TAKING"
                 //strenth.text = strength
                //reason.text = reason1
                if (medicationDict.object(forKey: "current_medication")) != nil && ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count >= indexPath.row
                {
                    if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "medicine") != nil{
                        
                        textField.text = (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "medicine") as? String
                    }
                    if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "strength") != nil{
                        
                        strenth.text = (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "strength") as? String
                    }

                    if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "reason_for_taking") != nil{
                        
                        reason.text = (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "reason_for_taking") as? String
                    }
                    
                    if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "usage") != nil{
                        
                        usages.setTitle((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "usage") as? String, for: .normal)
                    }

                    
                }
                
                addMoreButton.setTitle("- Remove", for: .normal)

            }
            else if medicalRowVar > 0 && indexPath.row == medicalRowVar
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "addCell")
                let add = cell.viewWithTag(1) as! UIButton
                
            }
        }
        else if indexPath.section == 1 //for Second section
        {
            if indexPath.row > 0 //for all rows grater then 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "allergyDiscriptionCell")
                let textView = cell.viewWithTag(2) as! UITextView
                textView.delegate = self
                if allergyDict.object(forKey: "drug_sensitivity_description") != nil && (allergyDict.object(forKey: "drug_sensitivity_description") is NSNull == false)
                {
                    textView.text = self.allergyDict.object(forKey: "drug_sensitivity_description") as! String
                }else
                {
                    textView.text = " Description"
                }
                
               // textView.layer.borderWidth = 1.0
               
            }
        }
        else if indexPath.section == 2 //for third section
        {
            if indexPath.row == 1 ////for Second row
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingCell")
                let label = cell.viewWithTag(1) as! UILabel
                label.text = ""
            }
            else if indexPath.row > 1 //for row grater than 2
            {
                if (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active" && ((surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as! String).lowercased() == "other"
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "othersCell")
                    let  labeltext = cell.viewWithTag(2) as! UILabel
                    let imageView = cell.viewWithTag(3) as! UIImageView
                    let view = cell.viewWithTag(1)! as UIView
                    let buttonWhen = cell.viewWithTag(4) as! UIButton
                    let textView = cell.viewWithTag(5) as! UITextView
                    textView.delegate = self
                    labeltext.text = "Other"
                    if ((surgaryArray.object(at: indexPath.row - 2)) as! NSDictionary).object(forKey: "other_description") != nil
                    {
                        textView.text = (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "other_description") as? String
                    }
                    
                    
                    if ((surgaryArray.object(at: indexPath.row - 2)) as! NSDictionary).object(forKey: "when") != nil
                    {
                        buttonWhen.setTitle((surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "when") as? String, for: .normal)
                    }else
                    {
                        buttonWhen.setTitle("Few days ago", for: .normal)
                    }
                    
                   // labeltext.text = (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "surgeries_or_medical_procedures") as? String
                    
                  
                    imageView.image = UIImage(named: "selectmark")
                    
                    buttonWhen.isHidden = false
                   
                }
                else if (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active"
                {
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell")
                    let  labeltext = cell.viewWithTag(2) as! UILabel
                    let imageView = cell.viewWithTag(3) as! UIImageView
                    let view = cell.viewWithTag(1)! as UIView
                    let buttonWhen = cell.viewWithTag(4) as! UIButton
                    
                    if ((surgaryArray.object(at: indexPath.row - 2)) as! NSDictionary).object(forKey: "when") != nil
                    {
                        buttonWhen.setTitle((surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "when") as? String, for: .normal)
                    }else
                    {
                        buttonWhen.setTitle("", for: .normal)
                    }
                    //buttonWhen.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0)
                    labeltext.text = (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as? String
                  
                    imageView.image = UIImage(named: "selectmark")
                                      buttonWhen.isHidden = false
                   
                }
                else
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell1")
                    let  labeltext = cell.viewWithTag(2) as! UILabel
                    let imageView = cell.viewWithTag(3) as! UIImageView
                    let view = cell.viewWithTag(1)! as UIView
                    labeltext.text = (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as? String
                    imageView.image = UIImage(named: "unselectmark")
                }
            }
        }else if indexPath.section == 3 //for fourth section
        {
            if indexPath.row == conditionRowVar + 1 //for last row
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
                let arrowBtn = cell.viewWithTag(111) as! UIButton
                arrowBtn.layer.cornerRadius = 3.0
            }
            else if indexPath.row == 1 //for second row
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingCell")
                let label = cell.viewWithTag(1) as! UILabel
                label.text = ""
            }
            else if indexPath.row > 1 //for row greater then 2 and less then last row
            {
                if (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active" && ((medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as! String).lowercased() == "other"
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "othersCell")
                    let  labeltext = cell.viewWithTag(2) as! UILabel
                    let imageView = cell.viewWithTag(3) as! UIImageView
                    let view = cell.viewWithTag(1)! as UIView
                    let buttonWhen = cell.viewWithTag(4) as! UIButton
                    let textView = cell.viewWithTag(5) as! UITextView
                    textView.delegate = self
                    textView.text = ""
                    
                    if((medicalConditionArray.object(at: indexPath.row - 2)) as! NSDictionary).object(forKey: "other_description") != nil
                    {
                        textView.text = (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "other_description") as? String
                    }else{
                        textView.text = ""
                    }
                    
                    
                    if ((medicalConditionArray.object(at: indexPath.row - 2)) as! NSDictionary).object(forKey: "when") != nil
                    {
                        buttonWhen.setTitle((medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "when") as? String, for: .normal)
                    }else
                    {
                        buttonWhen.setTitle("Few days ago", for: .normal)
                    }
                    labeltext.text = (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as? String
       
                    imageView.image = UIImage(named: "selectmark")
                                     buttonWhen.isHidden = false
                 
                }
                else if (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active"
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell")
                    let  labeltext = cell.viewWithTag(2) as! UILabel
                    let imageView = cell.viewWithTag(3) as! UIImageView
                    let view = cell.viewWithTag(1)! as UIView
                    let buttonWhen = cell.viewWithTag(4) as! UIButton
                    
                    if ((medicalConditionArray.object(at: indexPath.row - 2)) as! NSDictionary).object(forKey: "when") != nil
                    {
                        buttonWhen.setTitle((medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "when") as? String, for: .normal)
                    }else
                    {
                        buttonWhen.setTitle("Few days ago", for: .normal)
                    }
                    labeltext.text = (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as? String
                    imageView.image = UIImage(named: "selectmark")
                    buttonWhen.isHidden = false
                   
                }
                else
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell1")
                    let  labeltext = cell.viewWithTag(2) as! UILabel
                    let imageView = cell.viewWithTag(3) as! UIImageView
                    let view = cell.viewWithTag(1)! as UIView
                    labeltext.text = (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as? String
                        imageView.image = UIImage(named: "unselectmark")
                }
            }
            
                    }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            if indexPath.row > 0 && indexPath.row < medicalRowVar
            {
                return 230
            }
            else if indexPath.row == 0
            {
                return UITableViewAutomaticDimension
            }
            else
            {
                return 50
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row > 0
            {
                return UITableViewAutomaticDimension // text view cell
            }
            else
            {
                return UITableViewAutomaticDimension // yes no cell
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                return UITableViewAutomaticDimension
            }
            else if indexPath.row == 1
            {
                return 20 // check all thats apply cell
            }
            else
            {
                if (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active" && (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as? String == "Other"
                {
                    return 170
                }
                else if (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active"
                {
                    return 100
                }
                else
                {
                    return 50
                }
            }
        }
            
        else if indexPath.section == 3
        {
            if indexPath.row == 0
            {
                return UITableViewAutomaticDimension
            }
            else if indexPath.row == conditionRowVar + 1
            {
                return 100
            }
            else if indexPath.row == 1
            {
                return 20 // check all thats apply cell
            }
            else{
                if (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active" && (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "title") as? String == "Other"
                {
                    return 170
                }
                else if (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active"
                {
                    return 100
                }
                else
                {
                    return 50
                }
            }
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //tableView.reloadData()
        
    }
    
    //MARK:- Delegate function
    
    @IBAction func expandOrCollapse(_ sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let indexPath = (self.tableView?.indexPathForRow(at: pointInTable))!
        self.view.endEditing(true)
        var dict = NSMutableDictionary()
        if indexPath.section == 2
        {
            if indexPath.row == 0 || indexPath.row == 1
            {
                //
            }else if (surgaryArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active"
            {
                //Changes the value in main array
                dict = (surgaryArray.object(at: indexPath.row - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue("", forKey: "status")
                dict.setValue("", forKey: "duration_message")
                dict.setValue("0", forKey: "duration")
                surgaryArray.replaceObject(at: indexPath.row - 2, with: dict)
            }
            else
            {
                //Changes the value in main array
                dict = (surgaryArray.object(at: indexPath.row - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue("active", forKey: "status")
                dict.setValue("Few days ago", forKey: "duration_message")
                dict.setValue("0", forKey: "duration")
                surgaryArray.replaceObject(at: indexPath.row - 2, with: dict)
            }
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
        else if indexPath.section == 3
        {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == conditionRowVar + 1
            {
                //
            }else if (medicalConditionArray.object(at: indexPath.row - 2) as AnyObject).object(forKey: "status") as? String == "active"
            {
                dict = (medicalConditionArray.object(at: indexPath.row - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue("", forKey: "status")
                dict.setValue("Few days ago", forKey: "duration_message")
                dict.setValue("0", forKey: "duration")
                medicalConditionArray.replaceObject(at: indexPath.row - 2, with: dict)
            }
            else
            {
                dict = (medicalConditionArray.object(at: indexPath.row - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue("active", forKey: "status")
                dict.setValue("Few days ago", forKey: "duration_message")
                dict.setValue("0", forKey: "duration")
                medicalConditionArray.replaceObject(at: indexPath.row - 2, with: dict)
            }
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
    }
    
    
    //MARK:- Action Functions
    @IBAction func yesButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        if sender.isSelected == false
        {
        
        if cellIndexPath?.section == 0
        {
            if medicalRowVar <= 0
            {
                if (medicationDict.object(forKey: "current_medication")) != nil && ((medicationDict.object(forKey: "current_medication")) as! NSArray).count > 0
                {
                    
                    medicalRowVar = medicalRowVar + ((medicationDict.object(forKey: "current_medication")) as! NSArray).count
                }
                else
                {
                    let tempArray = NSMutableArray()
                    let tempDict = NSMutableDictionary()
                    tempDict.setObject("", forKey: "added_on" as NSCopying)
                    tempDict.setObject("", forKey: "id_current_medication" as NSCopying)
                    tempDict.setObject("", forKey: "id_medication" as NSCopying)
                    tempDict.setObject("", forKey: "medicine" as NSCopying)
                    tempDict.setObject("", forKey: "reason_for_taking" as NSCopying)
                    tempDict.setObject("", forKey: "strength" as NSCopying)
                    tempDict.setObject("", forKey: "updated_on" as NSCopying)
                    tempDict.setObject("", forKey: "usage" as NSCopying)
                    tempArray.add(tempDict)
                    self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                    medicalRowVar = medicalRowVar + 2
                }
                self.is_medication = "yes"
                medicationDict.setValue("yes", forKey: "is_medication")
                tableView.reloadData()
            }
        }
        else if cellIndexPath?.section == 1
        {
            if allergiesRowVar <= 0
            {
                allergiesRowVar = allergiesRowVar + 1
                allergyDict.setValue("yes", forKey: "is_drug_sensitivity")
                tableView.reloadData()
            }
        }
        else if cellIndexPath?.section == 2
        {
            if surgeriesRowVar <= 0
            {
                self.is_surgeries_medical_procedure = "yes"
                surgeriesRowVar = self.surgaryArray.count + 1
                tableView.reloadData()
            }
        }
        else if cellIndexPath?.section == 3
        {
            if conditionRowVar <= 0
            {
                self.is_medical_condition = "yes"
                conditionRowVar = self.medicalConditionArray.count + 1
                tableView.reloadData()
            }
        }
        }
        else
        {
            if cellIndexPath?.section == 0
            {
                if medicalRowVar > 0
                {
                    medicalRowVar = 0
                    let array = NSMutableArray()
                    self.medicationDict.setValue(array, forKey: "current_medication")
                    medicationDict.setValue("No", forKey: "is_medication")
                    tableView.reloadData()
                }
                self.is_medication = "no"
            }
            else if cellIndexPath?.section == 1
            {
                if allergiesRowVar > 0
                {
                    allergiesRowVar = 0
                    allergyDict.setValue("No", forKey: "is_drug_sensitivity")
                    allergyDict.setValue("", forKey: "allergies_description")
                    tableView.reloadData()
                }
            }
            else if cellIndexPath?.section == 2
            {
                if surgeriesRowVar > 0
                {
                    surgeriesRowVar = 0
                    tableView.reloadData()
                }
                self.is_surgeries_medical_procedure = "no"
            }
            else if cellIndexPath?.section == 3
            {
                if conditionRowVar > 0
                {
                    conditionRowVar = 0
                    tableView.reloadData()
                }
                self.is_medical_condition = "no"
            }
        }
    }
    
    @IBAction func noButtonAction(_ sender: AnyObject) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        if cellIndexPath?.section == 0
        {
            if medicalRowVar > 0
            {
                medicalRowVar = 0
                let array = NSMutableArray()
                self.medicationDict.setValue(array, forKey: "current_medication")
                medicationDict.setValue("No", forKey: "is_medication")
                tableView.reloadData()
            }
        }
        else if cellIndexPath?.section == 1
        {
            if allergiesRowVar > 0
            {
                allergiesRowVar = 0
                allergyDict.setValue("No", forKey: "is_drug_sensitivity")
                allergyDict.setValue("", forKey: "allergies_description")
                tableView.reloadData()
            }
        }
        else if cellIndexPath?.section == 2
        {
            if surgeriesRowVar > 0
            {
                surgeriesRowVar = 0
                tableView.reloadData()
            }
        }
        else if cellIndexPath?.section == 3
        {
            if conditionRowVar > 0
            {
                conditionRowVar = 0
                tableView.reloadData()
            }
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
    
    @IBAction func addMoreAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        
        if (sender.title(for: .normal)!) == "- Remove"
        {
            
        }else
        {
            
            if (medicationDict.object(forKey: "current_medication")) != nil && (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count) >= 5
            {
                supportingfuction.showMessageHudWithMessage(message: "Max limit exceeded.", delay: 2.0)
                return
            }
        }
        if cellIndexPath?.row == medicalRowVar
        {
            if (medicationDict.object(forKey: "current_medication")) != nil && ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count < medicalRowVar
            {
                
                if (cellIndexPath?.row)! > 0 && (cellIndexPath?.row)! == medicalRowVar//for all rows grater then 0
                {
                    if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "medicine") != nil && (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "medicine") as! String == ""{
                        supportingfuction.showMessageHudWithMessage(message: "Please enter medicine.", delay: 2.0)
                        return
                    }
                    else if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "strength") != nil && (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "strength") as! String == ""{
                        supportingfuction.showMessageHudWithMessage(message: "Please enter strength.", delay: 2.0)
                        return
                    }else if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "usage") != nil && (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "usage") as! String == ""{
                        supportingfuction.showMessageHudWithMessage(message: "Please select usage.", delay: 2.0)
                        return
                    }
                    else if (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "reason_for_taking") != nil && (((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (cellIndexPath?.row)! - 2) as! NSDictionary).object(forKey: "reason_for_taking") as! String == ""{
                        supportingfuction.showMessageHudWithMessage(message: "Please enter reason for taking.", delay: 2.0)
                        return
                    }
                    else{
                        
                        let tempDict = NSMutableDictionary()
                        tempDict.setObject("", forKey: "added_on" as NSCopying)
                        tempDict.setObject("", forKey: "id_current_medication" as NSCopying)
                        tempDict.setObject("", forKey: "id_medication" as NSCopying)
                        tempDict.setObject("", forKey: "medicine" as NSCopying)
                        tempDict.setObject("", forKey: "reason_for_taking" as NSCopying)
                        tempDict.setObject("", forKey: "strength" as NSCopying)
                        tempDict.setObject("", forKey: "updated_on" as NSCopying)
                        tempDict.setObject("", forKey: "usage" as NSCopying)
                        let tempArray = NSMutableArray()
                        tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                        tempArray.add(tempDict)
                        self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                    }
                }else{
                
                    let tempDict = NSMutableDictionary()
                    tempDict.setObject("", forKey: "added_on" as NSCopying)
                    tempDict.setObject("", forKey: "id_current_medication" as NSCopying)
                    tempDict.setObject("", forKey: "id_medication" as NSCopying)
                    tempDict.setObject("", forKey: "medicine" as NSCopying)
                    tempDict.setObject("", forKey: "reason_for_taking" as NSCopying)
                    tempDict.setObject("", forKey: "strength" as NSCopying)
                    tempDict.setObject("", forKey: "updated_on" as NSCopying)
                    tempDict.setObject("", forKey: "usage" as NSCopying)
                    let tempArray = NSMutableArray()
                    tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                    tempArray.add(tempDict)
                    self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                }
                medicalRowVar = medicalRowVar + 1
 
                medicationDuration = "For how long?"
                medicationName = ""
                medicationcode = ""
            }
            else
            {
                let tempDict = NSMutableDictionary()
                tempDict.setObject("", forKey: "added_on" as NSCopying)
                tempDict.setObject("", forKey: "id_current_medication" as NSCopying)
                tempDict.setObject("", forKey: "id_medication" as NSCopying)
                tempDict.setObject("", forKey: "medicine" as NSCopying)
                tempDict.setObject("", forKey: "reason_for_taking" as NSCopying)
                tempDict.setObject("", forKey: "strength" as NSCopying)
                tempDict.setObject("", forKey: "updated_on" as NSCopying)
                tempDict.setObject("", forKey: "usage" as NSCopying)
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.add(tempDict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                medicalRowVar = medicalRowVar + 1
            }
            tableView.reloadData()
        }else{
            
            if (medicationDict.object(forKey: "current_medication")) != nil && ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count >= (cellIndexPath?.row)!
            {
                medicalRowVar = medicalRowVar - 1
                var array = NSMutableArray()
                
                array = ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).mutableCopy() as! NSMutableArray
                array.removeObject(at: (cellIndexPath?.row)! - 1)
                self.medicationDict.setValue(array, forKey: "current_medication")
            }
            else{
                medicalRowVar = medicalRowVar - 1
            }
            if (self.medicationDict.object(forKey: "current_medication") as! NSArray).count == 0{
                self.medicationDict.setObject("no", forKey: "is_medication" as NSCopying)
                medicalRowVar = 0
            }
            tableView.reloadData()
        }
    }
    @IBAction func whenDropAction(_ sender: AnyObject) {
        
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        tempIndexPath = (self.tableView?.indexPathForRow(at: pointInTable))!
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
        pushVC.delegate = self
        pushVC.comminfromIndex = "duration"
        pushVC.from = "duration"
        ncode = "duration"
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    
    @IBAction func whenDropActionWhithoutAgo(_ sender: AnyObject) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        tempIndexPath = (self.tableView?.indexPathForRow(at: pointInTable))!
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyHistoryOptionsViewController") as! FamilyHistoryOptionsViewController
//        vc.delegate = self
//        vc.commingFor = "whenDropActionWhithoutAgo"
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextAction(_ sender: AnyObject) {
    }
    @IBAction func backbtnTapped(sender: UIButton){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        //        self.view.endEditing(true)
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    
    
    
    func validateEntries(){
        
        if (self.medicationDict.object(forKey: "current_medication") as! NSArray).count > 0{
            let dict = ((self.medicationDict.object(forKey: "current_medication") as! NSArray).lastObject) as! NSDictionary
            var bool = false
            if dict.object(forKey: "medicine") as! String != "" && (dict.object(forKey: "reason_for_taking") as! String == "" || dict.object(forKey: "strength") as! String == "" || dict.object(forKey: "usage") as! String == ""){
                bool = true
            }else if dict.object(forKey: "reason_for_taking") as! String != "" && (dict.object(forKey: "medicine") as! String == "" || dict.object(forKey: "strength") as! String == "" || dict.object(forKey: "usage") as! String == ""){
                bool = true
            }else if dict.object(forKey: "strength") as! String != "" && (dict.object(forKey: "medicine") as! String == "" || dict.object(forKey: "reason_for_taking") as! String == "" || dict.object(forKey: "usage") as! String == ""){
                bool = true
            }else if dict.object(forKey: "usage") as! String != "" && (dict.object(forKey: "medicine") as! String == "" || dict.object(forKey: "reason_for_taking") as! String == "" || dict.object(forKey: "strength") as! String == ""){
                bool = true
            }
            if bool{
                supportingfuction.showMessageHudWithMessage(message: "Please enter the complete details of your current medication.", delay: 2.0)
                return
            }
        }
        
        //validation for alergy
        if self.allergyDict.object(forKey: "is_drug_sensitivity") as! String != "" &&  (self.allergyDict.object(forKey: "is_drug_sensitivity") as! String).lowercased() == "yes" &&  (self.allergyDict.object(forKey: "drug_sensitivity_description") as! String).lowercased() == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter discription for alergy or drug senstivity.", delay: 2.0)
            return
        }
        
        //validation for surgery procedures
        if self.is_surgeries_medical_procedure == "yes"{
            let searchPredicate1 = NSPredicate(format: "status = %@","active")
            let tempArr : NSArray = self.surgaryArray.filtered(using: searchPredicate1) as NSArray
            if tempArr.count > 0{
                let searchPredicate2 = NSPredicate(format: "when = %@","")
                let tempArr2 : NSArray = tempArr.filtered(using: searchPredicate2) as NSArray
                if tempArr2.count > 0{
                    supportingfuction.showMessageHudWithMessage(message: "Please enter the complete details of your surgeries or medical procedures." as NSString, delay: 2.0)
                    return
                }
                
                //Check for other filed
                let searchPredicate3 = NSPredicate(format: "title = %@","Other")
                let tempArr3 : NSArray = tempArr.filtered(using: searchPredicate3) as NSArray
                if tempArr3.count>0{
                    if (tempArr3.object(at: 0) as! NSDictionary).object(forKey: "other_description") as! String == ""{
                        
                        supportingfuction.showMessageHudWithMessage(message: "Please enter the complete details of your surgeries or medical procedures." as NSString, delay: 2.0)
                        return
                    }
                }
            }
            
        }
        
        //Validation for medical conditions
        if self.is_medical_condition == "yes"{
            let searchPredicate1 = NSPredicate(format: "status = %@","active")
            let tempArr : NSArray = self.medicalConditionArray.filtered(using: searchPredicate1) as NSArray
            if tempArr.count > 0{
                let searchPredicate2 = NSPredicate(format: "when = %@","")
                let tempArr2 : NSArray = tempArr.filtered(using: searchPredicate2) as NSArray
                if tempArr2.count > 0{
                    supportingfuction.showMessageHudWithMessage(message: "Please enter the complete details of your medical conditions." as NSString, delay: 2.0)
                    return
                }
                
                //Check for other filed
                let searchPredicate3 = NSPredicate(format: "title = %@","Other")
                let tempArr3 : NSArray = tempArr.filtered(using: searchPredicate3) as NSArray
                if tempArr3.count>0{
                    if (tempArr3.object(at: 0) as! NSDictionary).object(forKey: "other_description") as! String == ""{
                        
                        supportingfuction.showMessageHudWithMessage(message: "Please enter the complete details of your medical conditions." as NSString, delay: 2.0)
                    return
                    }
                }
                
            }
        }
        self.submitDataOnServer()
    }
    
    @IBAction func saveChangeBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.validateEntries()
        
    }
    
    //Web service to submit filled data on server
    func submitDataOnServer(){
        let requestData = NSMutableDictionary()
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: Requesting as NSString, labelText: PleaseWait as NSString)
        
        requestData.setObject(self.jsonOfSurgeries(surgaryArray as NSArray), forKey: "surgeries_array" as NSCopying)
        
        requestData.setObject(self.jsonOfMedicalCondition(medicalConditionArray as NSArray), forKey: "medical_condition_array" as NSCopying)
        
        requestData.setObject(self.jsonOfCurrenMedication((self.medicationDict.object(forKey: "current_medication")) as! NSArray), forKey: "current_medication" as NSCopying)
        
        requestData.setObject(dict.object(forKey: "appointment_id") as! String, forKey: "id_appointment" as NSCopying)
        requestData.setObject(dict.object(forKey: "nurse_id") as! String, forKey: "id_nurse" as NSCopying)
        requestData.setObject(dict.object(forKey: "user_id") as! String, forKey: "id_patient" as NSCopying)
        requestData.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        
        if (allergyDict.object(forKey: "is_drug_sensitivity")) != nil && (allergyDict.object(forKey: "is_drug_sensitivity") is NSNull == false)
        {
            requestData.setObject(allergyDict.object(forKey: "is_drug_sensitivity") as! String, forKey: "is_drug_sensitivity" as NSCopying)
        }else{
            requestData.setObject("no", forKey: "is_drug_sensitivity" as NSCopying)
        }
        
        if (allergyDict.object(forKey: "drug_sensitivity_description")) != nil && (allergyDict.object(forKey: "drug_sensitivity_description") is NSNull == false)
        {
            requestData.setObject(allergyDict.object(forKey: "drug_sensitivity_description") as! String, forKey: "drug_sensitivity_description" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "drug_sensitivity_description" as NSCopying)
        }
        
        
        if self.jsonOfCurrenMedication((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count > 0{
            requestData.setObject("yes", forKey: "is_medication" as NSCopying)
        }else{
            requestData.setObject("no", forKey: "is_medication" as NSCopying)
        }
        
        if self.jsonOfSurgeries(surgaryArray as NSArray).count > 0{
            requestData.setObject("yes", forKey: "is_surgeries_medical_procedure" as NSCopying)
        }else{
            requestData.setObject("no", forKey: "is_surgeries_medical_procedure" as NSCopying)
        }
        
        if self.jsonOfMedicalCondition(medicalConditionArray as NSArray).count > 0{
            requestData.setObject("yes", forKey: "is_medical_condition" as NSCopying)
        }else{
            requestData.setObject("no", forKey: "is_medical_condition" as NSCopying)
        }
        
        if UserDefaults.standard.object(forKey: "key_api") != nil && UserDefaults.standard.object(forKey: "key_api") is NSNull == false && UserDefaults.standard.object(forKey: "key_api") as! String != ""
        {
            requestData.setObject(UserDefaults.standard.object(forKey: "key_api") as! String, forKey: "key_api" as NSCopying)
        }
//        requestData.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.edit_medical_history,requestData, {(operation, responseObject) in
            supportingfuction.hideProgressHudInView(view: self)
            if let dataFromServer = responseObject as? NSDictionary{
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") as! String == "success"{
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            
        }

    }
    
    func jsonOfCurrenMedication(_ data:NSArray)-> NSArray{
       print(data)
        var tempArray:[NSDictionary] = []
        for item in data{
            if (item as! NSDictionary).object(forKey: "medicine") as! String != ""{
                let finalDict = NSMutableDictionary()
                if (item as! NSDictionary).object(forKey: "medicine") as! String != ""{
                    finalDict.setObject((item as! NSDictionary).object(forKey: "medicine")!, forKey: "medicine" as NSCopying)
                    finalDict.setObject((item as! NSDictionary).object(forKey: "strength")!, forKey: "strength" as NSCopying)
                    finalDict.setObject((item as! NSDictionary).object(forKey: "usage")!, forKey: "usage" as NSCopying)
                    finalDict.setObject((item as! NSDictionary).object(forKey: "reason_for_taking")!, forKey: "reason_for_taking" as NSCopying)
                    tempArray.append(finalDict)
                }
            }
        }
        return tempArray as NSArray
    }
    
    func jsonOfSurgeries(_ data:NSArray)-> NSArray{
        print("Surgeries array === \(data)")
        var tempArray:[NSMutableDictionary] = []
        for item in data{
            let finalDict = NSMutableDictionary()
            if (item as! NSDictionary).object(forKey: "when") as! String != ""{
                finalDict.setObject((item as! NSDictionary).object(forKey: "title")!, forKey: "surgery_title" as NSCopying)
                finalDict.setObject((item as! NSDictionary).object(forKey: "when")!, forKey: "when" as NSCopying)
                finalDict.setObject((item as! NSDictionary).object(forKey: "other_description")!, forKey: "other_description" as NSCopying)
                tempArray.append(finalDict)
            }
            
        }
        return tempArray as NSArray
    }
    
    func jsonOfMedicalCondition(_ data:NSArray)-> NSArray{
        print("Medical condition array === \(data)")
        var tempArray:[NSMutableDictionary] = []
        
        for item in data{
            let finalDict = NSMutableDictionary()
            if (item as! NSDictionary).object(forKey: "when") as! String != ""{
                finalDict.setObject((item as! NSDictionary).object(forKey: "title")!, forKey: "medical_condition_title" as NSCopying)
                finalDict.setObject((item as! NSDictionary).object(forKey: "when")!, forKey: "when" as NSCopying)
                finalDict.setObject((item as! NSDictionary).object(forKey: "other_description")!, forKey: "other_description" as NSCopying)
                tempArray.append(finalDict)
            }
        }
        return tempArray as NSArray
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let hitPoint = textView.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: hitPoint)
        if indexPath?.section == 1{
            textView.autocorrectionType = .no
            textView.inputAccessoryView = self.getInputAccessayViewForTextView(textView)
        }
        return true
    }
    
    //MARK:- TextView Delegate Functions
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == ""
        {
        textView.text = ""
        }else
        {
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = ""
        }else
        {
        }
        
        let hitPoint = textView.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: hitPoint)
        if indexPath?.section == 1
        {
            let str = textView.text
            allergyDict.setValue(str, forKey: "drug_sensitivity_description")
        }
        else if indexPath?.section == 2
        {
            
            if (surgaryArray.object(at: (indexPath?.row)! - 2) as AnyObject).object(forKey: "status") as? String == "active" && ((surgaryArray.object(at: (indexPath?.row)! - 2) as AnyObject).object(forKey: "title") as! String).lowercased() == "other"
            {
                
                let dict = (surgaryArray.object(at: (indexPath?.row)! - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setObject(textView.text, forKey: "other_description" as NSCopying)
                surgaryArray.replaceObject(at: (indexPath?.row)! - 2, with: dict)
            }
        }
        else if indexPath?.section == 3
        {
            if (medicalConditionArray.object(at: (indexPath?.row)! - 2) as AnyObject).object(forKey: "status") as? String == "active" && ((medicalConditionArray.object(at: (indexPath?.row)! - 2) as AnyObject).object(forKey: "title") as! String).lowercased() == "other"
            {
                var dict = (medicalConditionArray.object(at: (indexPath?.row)! - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setObject(textView.text, forKey: "other_description" as NSCopying)
                medicalConditionArray.replaceObject(at: (indexPath?.row)! - 2, with: dict)
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let hitPoint = textView.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: hitPoint)
        if indexPath?.section == 1
        {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        if (text == "\n")
        {
            if indexPath?.section == 1
            {
//                self.tableView.beginUpdates()
//                self.tableView.endUpdates()
            }else{
                self.view.endEditing(true)
                return false
            }
        }
        return true
    }
    
    //MARK:- TextField Delegate Function
    func textFieldDidEndEditing(_ textField: UITextField) {
        let hitPoint: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        var str = ""
        str = textField.text!
        var dict = NSMutableDictionary()
        
        
        if textField.tag == 1
        {
            if (self.medicationDict.object(forKey: "current_medication")) != nil && ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count >= (indexPath?.row)!
            {
                dict = (((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (indexPath?.row)! - 1))) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue(str, forKey: "medicine")
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.replaceObject(at:(indexPath?.row)! - 1, with: dict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                medicationName = str
                
            }
            else{
                
                dict = (((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (indexPath?.row)! - 1))) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue(textField.text!, forKey: "medicine")
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.replaceObject(at:(indexPath?.row)! - 1, with: dict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                medicationName = textField.text!
            }
        }else if textField.tag == 21
        {
            if (self.medicationDict.object(forKey: "current_medication")) != nil && ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count >= (indexPath?.row)!
            {
                dict = (((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (indexPath?.row)! - 1))) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue(str, forKey: "strength")
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.replaceObject(at:(indexPath?.row)! - 1, with: dict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                strength = textField.text!
                
            }
            else{
                
                dict = (((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (indexPath?.row)! - 1))) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue(textField.text!, forKey: "strength")
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.replaceObject(at:(indexPath?.row)! - 1, with: dict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                strength = textField.text!
            }
        }else
        {
            if (self.medicationDict.object(forKey: "current_medication")) != nil && ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count >= (indexPath?.row)!
            {
                dict = (((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (indexPath?.row)! - 1))) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue(str, forKey: "reason_for_taking")
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.replaceObject(at:(indexPath?.row)! - 1, with: dict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                reason1 = textField.text!
                
            }
            else{
                dict = (((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: (indexPath?.row)! - 1))) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue(textField.text!, forKey: "reason_for_taking")
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.replaceObject(at:(indexPath?.row)! - 1, with: dict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
                
                reason1 = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func getInputAccessayViewForTextView(_ textView:UITextView)-> UIToolbar{
        let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/17))
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
        return keyboardDoneButtonShow
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK:- health_medicalHistory web method
    @IBAction func usagesBtnClicked(_ sender: UIButton) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
        pushVC.delegate = self
        pushVC.comminfromIndex = "dosage"
        pushVC.from = "dosage"
        ncode = "dosage"
        self.navigationController?.pushViewController(pushVC, animated: true)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
//      
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
 
    
    
    //MARK:- Delegate function
    

    
    // get country code
    func getCountryCode(code: String, ID: String)
    {
        if tempIndexPath.section == 0
        {
            var dict = NSMutableDictionary()
     //       var array = NSMutableArray()
            if ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count >= (tempIndexPath.row)
            {
                dict = (((((self.medicationDict.object(forKey: "current_medication")) as! NSArray).object(at: tempIndexPath.row - 1))) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dict.setValue(code, forKey: "usage")
                dict.setValue(ID, forKey: "id_current_medication")
                let tempArray = NSMutableArray()
                tempArray.addObjects(from: ((self.medicationDict.object(forKey: "current_medication")) as! NSArray) as! [Any])
                tempArray.replaceObject(at:(tempIndexPath.row) - 1, with: dict)
                self.medicationDict.setObject(tempArray, forKey: "current_medication" as NSCopying)
            }
            else{
                medicationDuration = code
                medicationcode = String(ID)
            }
        }
        else if tempIndexPath.section == 2
        {
            var dict = NSMutableDictionary()
            dict = (surgaryArray.object(at: tempIndexPath.row - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            dict.setValue(code, forKey: "when")
            dict.setValue(ID, forKey: "id")
            surgaryArray.replaceObject(at: tempIndexPath.row - 2, with: dict)
        }
        else if tempIndexPath.section == 3
        {
            var dict = NSMutableDictionary()
            dict = (medicalConditionArray.object(at: tempIndexPath.row - 2) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            dict.setValue(code, forKey: "when")
            dict.setValue(ID, forKey: "id")
            medicalConditionArray.replaceObject(at: tempIndexPath.row - 2, with: dict)
        }
        tableView.reloadData()
    }

    
    func getUserData()
        {
            supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
            let dict = NSMutableDictionary()
        dict.setObject(self.id_appointment, forKey: "id_appointment" as NSCopying)
       dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
            let apiSniper = APISniper()
            apiSniper.getDataFromWebAPI(WebAPI.medication,dict, {(operation, responseObject) in
                if let dataFromServer = responseObject as? NSDictionary
                {
                supportingfuction.hideProgressHudInView(view: self)
                    if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                    {
                        logoutUser()
                    }else if dataFromServer.object(forKey: "status") as! String == "success"{
                    print(dataFromServer)
                    if (dataFromServer as AnyObject).object(forKey: "data") != nil
                    {
                        var maindataDict = NSMutableDictionary()
                        maindataDict = (dataFromServer.object(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        if maindataDict.object(forKey: "medical_condition_des") != nil
                        {
                            self.MedicalConditionArray(maindataDict.object(forKey: "medical_condition_des") as! NSArray)
                        }
                        
                        if maindataDict.object(forKey: "surgery__des") != nil && (maindataDict.object(forKey: "surgery__des") is NSArray){
                            self.setSurgeriesArray(maindataDict.object(forKey: "surgery__des") as! NSArray)
                        }
                        
                        
                        let dict = NSMutableDictionary()
                        dict.setObject((maindataDict.object(forKey: "is_drug_sensitivity") as! String), forKey: "is_drug_sensitivity" as NSCopying)
                        dict.setObject((maindataDict.object(forKey: "drug_sensitivity_description") as! String), forKey: "drug_sensitivity_description" as NSCopying)

                        self.allergyDict = dict
                        
                        if maindataDict.object(forKey: "current_medication") != nil && maindataDict.object(forKey: "current_medication") is NSArray{
                            self.medicationDict.setObject((maindataDict.object(forKey: "current_medication") as! NSArray), forKey: "current_medication" as NSCopying)
                        }else{
                            self.medicationDict.setObject(NSArray(), forKey: "current_medication" as NSCopying)
                        }

                        if (maindataDict.object(forKey: "is_medication") is NSNull == false) && (maindataDict.object(forKey: "is_medication")) as! String == "yes"
                        {
                            if ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count > 0{
                                
                                self.medicalRowVar = ((self.medicationDict.object(forKey: "current_medication")) as! NSArray).count + 1
                            }else{
                                self.medicationDict.setObject("no", forKey: "is_medical_condition" as NSCopying)
                                self.medicalRowVar = 0
                            }
                        }
                        else{
                            
                            let array = NSMutableArray()
                            self.medicationDict.setValue(array, forKey: "current_medication")
                            self.medicalRowVar = 0
                           
                        }
                        
                        if (self.allergyDict.object(forKey: "is_drug_sensitivity")) != nil &&
                            (self.allergyDict.object(forKey: "is_drug_sensitivity") is NSNull == false)
                        {
                            if self.allergyDict.object(forKey: "is_drug_sensitivity") as! String == "yes"
                            {
                                self.allergiesRowVar = 1
                            }else
                            {
                                maindataDict.setObject("No", forKey: "is_drug_sensitivity" as NSCopying)
                            }
                        }
                        
                        if (maindataDict.object(forKey: "is_surgeries_medical_procedure")) != nil &&
                            (maindataDict.object(forKey: "is_surgeries_medical_procedure") is NSNull == false)
                        {
                            if (maindataDict.object(forKey: "is_surgeries_medical_procedure") as! String) == "yes"
                            {
                                self.surgeriesRowVar = self.surgaryArray.count + 1
                            }
                            else{
                                self.surgeriesRowVar = 0
                                
                                maindataDict.setObject("No", forKey: "is_surgeries_medical_procedure" as NSCopying)
                            }
                            
                        }
                        
                        if (maindataDict.object(forKey: "is_medical_condition")) != nil &&
                            (maindataDict.object(forKey: "is_medical_condition") is NSNull == false)
                        {
                            if (maindataDict.object(forKey: "is_medical_condition") as! String) == "yes"
                            {
                                self.conditionRowVar = self.medicalConditionArray.count + 1
                            }
                            else
                            {
                                 maindataDict.setObject("No", forKey: "is_medical_condition" as NSCopying)
                                self.conditionRowVar = 0
                                
                            }
                        }
                        
                        self.is_surgeries_medical_procedure = maindataDict.object(forKey: "is_surgeries_medical_procedure") as! String
                        self.is_medical_condition = maindataDict.object(forKey: "is_medical_condition") as! String
                        self.is_medication = (maindataDict.object(forKey: "is_medication")) as! String
                        self.tableView.reloadData()
                    }
                }
            }
        }) { (operation, error) in
           // print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    func MedicalConditionArray(_ data:NSArray){
        for object in data{
            let tempDict = NSMutableDictionary(dictionary: object as! NSDictionary)
            if tempDict.object(forKey: "when") as! String == ""{
                tempDict.setObject("", forKey: "status" as NSCopying)
            }else if tempDict.object(forKey: "when") as! String != ""{
                tempDict.setObject("active", forKey: "status" as NSCopying)
            }
            if tempDict.object(forKey: "title") as! String == "" || (tempDict.object(forKey: "title") as! String).lowercased() == "other"{
                tempDict.setObject("Other", forKey: "title" as NSCopying)
            }
            self.medicalConditionArray.add(tempDict)
        }
//        self.tableView.reloadData()
    }
    
    
    func setSurgeriesArray(_ data:NSArray){
        for object in data{
            let tempDict = NSMutableDictionary(dictionary: object as! NSDictionary)
            if tempDict.object(forKey: "when") as! String == ""{
                tempDict.setObject("", forKey: "status" as NSCopying)
            }
            else if tempDict.object(forKey: "when") as! String != ""{
                tempDict.setObject("active", forKey: "status" as NSCopying)
            }
            
            if tempDict.object(forKey: "title") as! String == "" || (tempDict.object(forKey: "title") as! String).lowercased() == "other"{
                tempDict.setObject("Other", forKey: "title" as NSCopying)
            
            }
            
            self.surgaryArray.add(tempDict)
        }
        
    }
    
    
    
}
