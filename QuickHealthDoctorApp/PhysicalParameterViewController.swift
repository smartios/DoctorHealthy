//
//  PhysicalParameterViewController.swift
//  QuickHealthdoctorApp
//
//  Created by SS21 on 04/04/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit

class PhysicalParameterViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    //SelectedValueDelegate {
    
    var goingFrom = -1
    var dataInfoDict  = NSMutableDictionary()
    var currentindex = -1
    var drinkCell = 0
    var smokeCell = 0
    var no_of_stick = ""
    var year_smoking = ""
    var curr_ex = ""
    var stopped_time = ""
    var no_of_drink = ""
    var id_appointment = ""
    var dataDict = NSMutableDictionary()
    // date picker
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.rowHeight = 150
            self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(PhysicalParameterViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhysicalParameterViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialDict()
        
        //date picker
        datePickerView.isHidden = true
        datePickerView.isHidden = true
        datePicker.datePickerMode = UIDatePickerMode.date
        if(!appDelegate.hasConnectivity()){
            supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
        }else{
            getUserData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setInitialDict(){
        // blank in dict
        dataInfoDict.setObject("", forKey: "height" as NSCopying)
        dataInfoDict.setObject("", forKey: "weight" as NSCopying)
        dataInfoDict.setObject("", forKey: "oxygen_level_taken" as NSCopying)
        dataInfoDict.setObject("", forKey: "systolic_blood_pressure" as NSCopying)
        dataInfoDict.setObject("", forKey: "diastolic_blood_pressure" as NSCopying)
        dataInfoDict.setObject("", forKey: "diastolic_systolic_pressure_taken" as NSCopying)
        dataInfoDict.setObject("", forKey: " physique_health_rate_duration" as NSCopying)
        dataInfoDict.setObject("", forKey: "heart_rate" as NSCopying)
        dataInfoDict.setObject("", forKey: "heartbeat" as NSCopying)
        dataInfoDict.setObject("", forKey: "oxygen_level" as NSCopying)
        dataInfoDict.setObject("", forKey: "height_weight_taken" as NSCopying)
        dataInfoDict.setObject("", forKey: "highest_temperature_recorded_taken" as NSCopying)
        dataInfoDict.setObject("", forKey: "other" as NSCopying)
        dataInfoDict.setObject("", forKey: "oxygen_level_taken" as NSCopying)
        dataInfoDict.setObject("", forKey: "pregnancy_test_taken" as NSCopying)
        dataInfoDict.setObject("", forKey: "other_taken" as NSCopying)
        dataInfoDict.setObject("no", forKey: "is_smoked" as NSCopying)
        dataInfoDict.setObject("", forKey: "smoked_1" as NSCopying)
        dataInfoDict.setObject("", forKey: "smoked_2" as NSCopying)
//
        dataInfoDict.setObject("", forKey: "smoked_3" as NSCopying)
        dataInfoDict.setObject("no", forKey: "is_alcohol" as NSCopying)
        dataInfoDict.setObject("", forKey: "no_of_drinks" as NSCopying)
//
//        self.dataInfoDict.setObject("", forKey: "lifestyle_step2" as NSCopying)
//        self.dataInfoDict.setObject("", forKey: "lifestyle_step3" as NSCopying)
        self.dataInfoDict.setObject("", forKey: "is_exercise" as NSCopying)
//        self.dataInfoDict.setObject("", forKey: "lifestyle_step8" as NSCopying)
    }
    
    //MARK:- TableViewDelegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 19
        }
        else if section == 1
        {
            // ques ans section
            return 9 + drinkCell + smokeCell // 9 = 8 ques ,1 heading
            
        }else if section == 2
        {
            return 1
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "mainheadingCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  labeltext2 = cell.viewWithTag(2) as! UILabel
                //cell.backgroundColor = UIColor.red
                labeltext.text = ""
                labeltext2.text = "PHYSICAL STATS"
                labeltext2.isHidden = false
            }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                textField.placeholder = "Height".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "Height(CM)".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "(CM)".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                //textField.layer.borderWidth = 0.0
                //textField.layer.borderColor = UIColor(red: 136.0 / 255.0, green: 216.0 / 255.0, blue: 209.0 / 255.0, alpha:1.0).cgColor
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.decimalPad
                
                if (dataInfoDict.object(forKey: "height")) != nil && (dataInfoDict.object(forKey: "height") is NSNull == false) && (dataInfoDict.object(forKey: "height") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "height") as! String)
                }
                else
                {
                    textField.text = ""
                }
                
            }
            else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                btn.isHidden = true
                textField.placeholder = "Weight".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "Weight(KG)".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "(KG)".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.decimalPad
                
                if (dataInfoDict.object(forKey: "weight")) != nil && (dataInfoDict.object(forKey: "weight") is NSNull == false) && (dataInfoDict.object(forKey: "weight") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "weight") as! String)
                }
                else
                {
                    textField.text = ""
                }
                
            }
            else if indexPath.row == 5
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                labeltext.text = "Systolic blood pressure(MM/HG)".uppercased()
                textField.placeholder = "Systolic blood pressure".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "Systolic blood pressure(MM/HG)".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "(MM/HG)".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                //systolic_blood_pressure
                
                //textField.layer.borderWidth = 0.0
                //textField.layer.borderColor = UIColor(red: 136.0 / 255.0, green: 216.0 / 255.0, blue: 209.0 / 255.0, alpha:1.0).cgColor
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.decimalPad
                
                if (dataInfoDict.object(forKey: "systolic_blood_pressure")) != nil && (dataInfoDict.object(forKey: "systolic_blood_pressure") is NSNull == false) && (dataInfoDict.object(forKey: "systolic_blood_pressure") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "systolic_blood_pressure") as! String)
                }
                else
                {
                    textField.text = ""
                }
                
            }
            else if indexPath.row == 4
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                btn.isHidden = true
                labeltext.text = "Diastolic blood pressue(MM/HG)".uppercased()
                textField.placeholder = "Diastolic blood pressue".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "Diastolic blood pressure(MM/HG)".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "(MM/HG)".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.decimalPad
                //diastolic_blood_pressure
                if (dataInfoDict.object(forKey: "diastolic_blood_pressure")) != nil && (dataInfoDict.object(forKey: "diastolic_blood_pressure") is NSNull == false) && (dataInfoDict.object(forKey: "diastolic_blood_pressure") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "diastolic_blood_pressure") as! String)
                }
                else
                {
                    textField.text = ""
                }
                
            }
                
            else if indexPath.row == 7
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                labeltext.text = "HEARTBEAT(BPM)".uppercased()
                textField.placeholder = "HEARTBEAT(BPM)".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "HEARTBEAT(BPM)".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "(BPM)".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.decimalPad
                
                if (dataInfoDict.object(forKey: "heartbeat")) != nil && (dataInfoDict.object(forKey: "heartbeat") is NSNull == false) && (dataInfoDict.object(forKey: "heartbeat") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "heartbeat") as! String)
                }
                else
                {
                    textField.text = ""
                }
                
            }
            else if indexPath.row == 11
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                
                labeltext.text = "OXYGEN LEVEL".uppercased()
                textField.placeholder = "OXYGEN LEVEL".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "OXYGEN LEVEL".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.decimalPad
                
                //oxygen_level
                if (dataInfoDict.object(forKey: "oxygen_level")) != nil && (dataInfoDict.object(forKey: "oxygen_level") is NSNull == false) && (dataInfoDict.object(forKey: "oxygen_level") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "oxygen_level") as! String)
                }
                else
                {
                    textField.text = ""
                }
            }
            else if indexPath.row == 13
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                
                labeltext.text = "GLUCOSE LEVEL".uppercased()
                textField.placeholder = "GLUCOSE LEVEL".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "GLUCOSE LEVEL".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.decimalPad
                
                //oxygen_level
                if (dataInfoDict.object(forKey: "glucose_level")) != nil && (dataInfoDict.object(forKey: "glucose_level") is NSNull == false) && (dataInfoDict.object(forKey: "glucose_level") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "glucose_level") as! String)
                }
                else
                {
                    textField.text = ""
                }
            }
                
                
            else if indexPath.row == 15
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                
                labeltext.text = "PREGNANCY TEST".uppercased()
                textField.placeholder = "PREGNANCY TEST".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "PREGNANCY TEST".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.default
                
                //oxygen_level
                if (dataInfoDict.object(forKey: "pregnancy_test")) != nil && (dataInfoDict.object(forKey: "pregnancy_test") is NSNull == false) && (dataInfoDict.object(forKey: "pregnancy_test") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "pregnancy_test") as! String)
                }
                else
                {
                    textField.text = ""
                }
            }
                
            else if indexPath.row == 17
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                
                labeltext.text = "OTHER".uppercased()
                textField.placeholder = "OTHER".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "OTHER".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.default
                
                //oxygen_level
                if (dataInfoDict.object(forKey: "other")) != nil && (dataInfoDict.object(forKey: "other") is NSNull == false) && (dataInfoDict.object(forKey: "other") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "other") as! String)
                }
                else
                {
                    textField.text = ""
                }
            }
                
                
            else if indexPath.row == 9
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "singleEntryCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  textField = cell.viewWithTag(2) as! UITextField
                let  btn = cell.viewWithTag(3) as! UIButton
                
                btn.isHidden = true
                
                labeltext.text = "HIGHEST TEMPRATURE RECORDED(°C)".uppercased()
                textField.placeholder = "HIGHEST TEMPRATURE RECORDED".uppercased()
                labeltext.attributedText = CommonValidations.createAttributedString(fullString: "HIGHEST TEMPRATURE RECORDED(°C)".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "(°C)".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
                
                
                textField.leftViewMode = UITextFieldViewMode.always
                textField.keyboardType = UIKeyboardType.numberPad
                
                //highest_temperature_recorded
                if (dataInfoDict.object(forKey: "highest_temperature_recorded")) != nil && (dataInfoDict.object(forKey: "highest_temperature_recorded") is NSNull == false)  && (dataInfoDict.object(forKey: "highest_temperature_recorded") as! String) != ""
                {
                    textField.text = (dataInfoDict.object(forKey: "highest_temperature_recorded") as! String)
                }
                else
                {
                    textField.text = ""
                }
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "whenTappedCell")
                let label = cell.viewWithTag(2) as! UITextField
                label.placeholder = "MEASURED ON"
                if indexPath.row == 3
                {
                    if (dataInfoDict.object(forKey: "height_weight_taken")) != nil  && (dataInfoDict.object(forKey: "height_weight_taken") is NSNull == false) && (dataInfoDict.object(forKey: "height_weight_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "height_weight_taken") as! String)
                    }
                    else
                    {
                        label.text =  ""
                    }
                    
                }
                //""
                if indexPath.row == 12
                {
                    if (dataInfoDict.object(forKey: "oxygen_level_taken")) != nil  && (dataInfoDict.object(forKey: "oxygen_level_taken") is NSNull == false) && (dataInfoDict.object(forKey: "oxygen_level_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "oxygen_level_taken") as! String)
                    }
                    else
                    {
                        label.text =  ""
                    }
                    
                }
                else if indexPath.row == 6
                {
                    
                    //diastolic_systolic_pressure_taken
                    if (dataInfoDict.object(forKey: "diastolic_systolic_pressure_taken")) != nil && (dataInfoDict.object(forKey: "diastolic_systolic_pressure_taken") is NSNull == false) && (dataInfoDict.object(forKey: "diastolic_systolic_pressure_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "diastolic_systolic_pressure_taken") as! String)
                    }
                    else
                    {
                        label.text =  ""
                    }
                }else if indexPath.row == 10
                {
                    
                    if (dataInfoDict.object(forKey: "highest_temperature_recorded_taken")) != nil && (dataInfoDict.object(forKey: "highest_temperature_recorded_taken") is NSNull == false)  && (dataInfoDict.object(forKey: "highest_temperature_recorded_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "highest_temperature_recorded_taken") as! String)
                    }
                    else
                    {
                        label.text =  ""
                    }
                }
                    
                else if indexPath.row == 14
                {
                    //oxygen_level_taken
                    if (dataInfoDict.object(forKey: "glucose_level_taken")) != nil && (dataInfoDict.object(forKey: "glucose_level_taken") is NSNull == false)  && (dataInfoDict.object(forKey: "glucose_level_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "glucose_level_taken") as! String)
                    }
                    else
                    {
                        label.text =  ""
                    }
                }
                else if indexPath.row == 16
                {
                    //Pregenency taken
                    if (dataInfoDict.object(forKey: "pregnancy_test_taken")) != nil && (dataInfoDict.object(forKey: "pregnancy_test_taken") is NSNull == false)  && (dataInfoDict.object(forKey: "pregnancy_test_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "pregnancy_test_taken") as! String)
                    }
                    else
                    {
                        label.text =  ""
                    }
                }
                    
                else if indexPath.row == 18
                {
                    //Other
                    if (dataInfoDict.object(forKey: "other_taken")) != nil && (dataInfoDict.object(forKey: "other_taken") is NSNull == false)  && (dataInfoDict.object(forKey: "other_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "other_taken") as! String)
                    }
                    else
                    {
                        label.text =  ""
                    }
                }
                    
                    
                    
                else if indexPath.row == 8
                {
                    //heartbeat_taken
                    if (dataInfoDict.object(forKey: "heartbeat_taken")) != nil && (dataInfoDict.object(forKey: "heartbeat_taken") is NSNull == false)  && (dataInfoDict.object(forKey: "heartbeat_taken") as! String) != ""
                    {
                        label.text = (dataInfoDict.object(forKey: "heartbeat_taken") as! String)
                    }else
                    {
                        label.text = ""
                    }
                    
                }
                
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingCell")
                let  labeltext = cell.viewWithTag(1) as! UILabel
                let  labeltext2 = cell.viewWithTag(2) as! UILabel
                labeltext.text = ""
                labeltext2.attributedText = CommonValidations.createAttributedString(fullString: "LIFESTYLE".uppercased(), fullStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0x000000), subString: "".uppercased(), subStringColor: CommonValidations.UIColorFromRGB(rgbValue: 0xA1A1A1))
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "HeadingCell")
                let yesButton = cell.viewWithTag(2) as! UIButton
                let label = cell.viewWithTag(3) as! UILabel
                if indexPath.row == 1 //+ drinkCell + smokeCell
                {
                    label.text = "Do you get at least 7 hours of sleep daily?".uppercased()
                    if (dataInfoDict.object(forKey: "is_smoked")) != nil && (dataInfoDict.object(forKey: "is_smoked") is NSNull == false)  && (dataInfoDict.object(forKey: "is_smoked") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "is_smoked") as! String).lowercased() == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                            
                            
                        }
                    }else
                    {
                        yesButton.isSelected = false
                        yesButton.backgroundColor = UIColor.white
                    }
                    
                    
                } else if indexPath.row == 2 //+ drinkCell + smokeCell
                {
                    label.text = "Do you exercise at least 3 times a week, 20 minutes each time?".uppercased()
                    if (dataInfoDict.object(forKey: "lifestyle_step2")) != nil && (dataInfoDict.object(forKey: "lifestyle_step2") is NSNull == false) && (dataInfoDict.object(forKey: "lifestyle_step2") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "lifestyle_step2") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                        }else
                        {
                            yesButton.isSelected = false
                            
                        }
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                    
                    
                } else if indexPath.row == 3 //+ drinkCell + smokeCell
                {
                    label.text = "Did you get a flu vaccination in the last one year?".uppercased()
                    if (dataInfoDict.object(forKey: "lifestyle_step3")) != nil  && (dataInfoDict.object(forKey: "lifestyle_step3") is NSNull == false) && (dataInfoDict.object(forKey: "lifestyle_step3") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "lifestyle_step3") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                            
                        }
                        
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                    
                } else if indexPath.row == 4 //+ drinkCell + smokeCell
                {
                    label.text = "Do you smoked or used any tobacco products?"
                    if (dataInfoDict.object(forKey: "is_smoked")) != nil && (dataInfoDict.object(forKey: "is_smoked") is NSNull == false) &&  (dataInfoDict.object(forKey: "is_smoked") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "is_smoked") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                            
                        }
                        
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                    
                } else if indexPath.row == 5 + smokeCell //+ smokeCell
                {
                    label.text = "Do you consume alcohol?"
                    if  (dataInfoDict.object(forKey: "is_alcohol")) != nil && (dataInfoDict.object(forKey: "is_alcohol") is NSNull == false) && (dataInfoDict.object(forKey: "is_alcohol") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "is_alcohol") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                            
                        }
                        
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                    
                } else if indexPath.row == 7 + drinkCell + smokeCell
                {
                    label.text = "Do you work?"
                    if (dataInfoDict.object(forKey: "is_work")) != nil &&  (dataInfoDict.object(forKey: "is_work") is NSNull == false) && (dataInfoDict.object(forKey: "is_work") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "is_work") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                            
                        }
                        
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                    
                } else if indexPath.row == 6 + drinkCell + smokeCell
                {
                    label.text = "Do you exercise?"
                    if (dataInfoDict.object(forKey: "is_exercise")) != nil && (dataInfoDict.object(forKey: "is_exercise") is NSNull == false) &&  (dataInfoDict.object(forKey: "is_exercise") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "is_exercise") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                        }
                        
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                }else if indexPath.row == 8 + drinkCell + smokeCell
                {
                    label.text = "Are you or have you ever been disabled?".uppercased()
                    if (dataInfoDict.object(forKey: "lifestyle_step8")) != nil && (dataInfoDict.object(forKey: "lifestyle_step8") is NSNull == false) && (dataInfoDict.object(forKey: "lifestyle_step8") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "lifestyle_step8") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                            
                        }
                        
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                    
                }else if indexPath.row == 9 + drinkCell + smokeCell
                {
                    label.text = "Are you or have you ever been disabled?".uppercased()
                    if (dataInfoDict.object(forKey: "lifestyle_step8")) != nil && (dataInfoDict.object(forKey: "lifestyle_step8") is NSNull == false) && (dataInfoDict.object(forKey: "lifestyle_step8") as! String) != ""
                    {
                        if (dataInfoDict.object(forKey: "lifestyle_step8") as! String) == "yes"
                        {
                            yesButton.isSelected = true
                            
                        }else
                        {
                            yesButton.isSelected = false
                            
                        }
                    }else
                    {
                        yesButton.isSelected = false
                        
                    }
                    
                }else
                {
                    // do nothimng
                }
                
                if drinkCell > 0 && smokeCell > 0
                {
                    if indexPath.row == 5 ||   indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 ||  indexPath.row == 10
                    {
                        cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")!
                        let ques_label = cell.viewWithTag(1) as! UILabel
                        let anss_label = cell.viewWithTag(2) as! UITextField
                        let arrowBtn = cell.viewWithTag(121) as! UIButton
                        anss_label.isSecureTextEntry = false
                        anss_label.placeholder = ""
                        anss_label.isUserInteractionEnabled = true
                        arrowBtn.isHidden = true
                        
                        let borderColor = UIColor(red: 138.0 / 255.0, green: 219.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
                        
                        
                        
                        
                        anss_label.layer.borderColor = borderColor.cgColor;
                        anss_label.layer.borderWidth = 0.0;
                        //ques_label.text = "varun1"
                        anss_label.layer.borderColor = borderColor.cgColor;
                        anss_label.layer.borderWidth = 0.0;
                        //anss_label.text = "varun"
                        
                        if indexPath.row == 5
                        {
                            ques_label.text = "Number of sticks a day on average?".uppercased()
                            anss_label.placeholder = "Number of sticks a day on average.".uppercased()
                            if (dataInfoDict.object(forKey: "smoked_1")) != nil && (dataInfoDict.object(forKey: "smoked_1") is NSNull == false) && (dataInfoDict.object(forKey: "smoked_1") as! String) != ""
                            {
                                
                                anss_label.text = (dataInfoDict.object(forKey: "smoked_1") as! String)
                            }
                            else
                            {
                                anss_label.text = ""
                            }
                            
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.numberPad
                        }
                        else if indexPath.row == 6
                        {
                            ques_label.text = "Number of years of smoking?".uppercased()
                            anss_label.placeholder = "Number of years of smoking.".uppercased()
                            if (dataInfoDict.object(forKey: "smoked_2")) != nil && (dataInfoDict.object(forKey: "smoked_2") is NSNull == false) && (dataInfoDict.object(forKey: "smoked_2") as! String) != ""
                            {
                                
                                anss_label.text = (dataInfoDict.object(forKey: "smoked_2") as! String)
                            }
                            else
                            {
                                anss_label.text = ""
                            }
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.numberPad
                        }
                        else if indexPath.row == 7
                        {
                            ques_label.text = "Current or ex-smoker?".uppercased()
                            anss_label.text = curr_ex
                            anss_label.text = "Current or ex-smoker.".uppercased()
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.default
                        }else if indexPath.row == 8
                        {
                            ques_label.text = "How long ago did you used tobacco prod?".uppercased()
                            anss_label.placeholder = "How long ago did you used tobacco prod.".uppercased()
                            if (dataInfoDict.object(forKey: "smoked_4")) != nil && (dataInfoDict.object(forKey: "smoked_4") is NSNull == false) && (dataInfoDict.object(forKey: "smoked_4") as! String) != ""
                            {
                                
                                anss_label.text = (dataInfoDict.object(forKey: "smoked_4") as! String)
                            }
                            else
                            {
                                anss_label.text = ""
                            }
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.asciiCapable
                        }else if indexPath.row == 10
                        {
                            ques_label.text = "Number of drinks a week on average".uppercased()
                            anss_label.placeholder = "Number of drinks a week on average".uppercased()
                            anss_label.keyboardType = UIKeyboardType.numberPad
                            anss_label.text = no_of_drink
                            anss_label.isUserInteractionEnabled = true
                        }else
                        {
                            ques_label.text = ""
                            anss_label.text = ""
                            anss_label.isUserInteractionEnabled = true
                        }
                    }
                    
                }else if smokeCell > 0 && drinkCell == 0
                {
                    if indexPath.row == 5 ||   indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8
                    {
                        cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")!
                        let ques_label = cell.viewWithTag(1) as! UILabel
                        let anss_label = cell.viewWithTag(2) as! UITextField
                        let arrowBtn = cell.viewWithTag(121) as! UIButton
                        anss_label.isSecureTextEntry = false
                        anss_label.placeholder = ""
                        anss_label.isUserInteractionEnabled = true
                        arrowBtn.isHidden = true
                        
                        let borderColor = UIColor(red: 138.0 / 255.0, green: 219.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
                        
                        anss_label.leftViewMode = UITextFieldViewMode.always
                        anss_label.layer.borderColor = borderColor.cgColor;
                        anss_label.layer.borderWidth = 0.0;
                        anss_label.layer.borderColor = borderColor.cgColor;
                        anss_label.layer.borderWidth = 0.0;
                        
                        if indexPath.row == 5
                        {
                            ques_label.text = "Number of sticks a day on average?".uppercased()
                            anss_label.placeholder = "Number of sticks a day on average".uppercased()
                            
                            if (dataInfoDict.object(forKey: "smoked_1")) != nil && (dataInfoDict.object(forKey: "smoked_1") is NSNull == false) && (dataInfoDict.object(forKey: "smoked_1") as! String) != ""
                            {
                                anss_label.text = (dataInfoDict.object(forKey: "smoked_1") as! String)
                            }
                            else
                            {
                                anss_label.text = ""
                            }
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.numberPad
                        }
                        else if indexPath.row == 6
                        {
                            ques_label.text = "Number of years of smoking?".uppercased()
                            anss_label.placeholder = "Number of years of smoking".uppercased()
                            if (dataInfoDict.object(forKey: "smoked_2")) != nil && (dataInfoDict.object(forKey: "smoked_2") is NSNull == false) && (dataInfoDict.object(forKey: "smoked_2") as! String) != ""
                            {
                                anss_label.text = (dataInfoDict.object(forKey: "smoked_2") as! String)
                            }
                            else
                            {
                                anss_label.text = ""
                            }
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.numberPad
                        }
                        else if indexPath.row == 7
                        {
                            ques_label.text = "Current or ex-smoker?".uppercased()
                            anss_label.placeholder = "Current or ex-smoker".uppercased()
                            anss_label.text = curr_ex
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.default
                        }else if indexPath.row == 8
                        {
                            ques_label.text = "How long ago did you used tobacco prod?".uppercased()
                            anss_label.placeholder = "How long ago did you used tobacco prod".uppercased()
                            if (dataInfoDict.object(forKey: "smoked_4")) != nil && (dataInfoDict.object(forKey: "smoked_4") is NSNull == false) && (dataInfoDict.object(forKey: "smoked_4") as! String) != ""
                            {
                                anss_label.text = (dataInfoDict.object(forKey: "smoked_4") as! String)
                            }
                            else
                            {
                                anss_label.text = ""
                            }
                            anss_label.isUserInteractionEnabled = true
                            anss_label.keyboardType = UIKeyboardType.default
                        }else
                        {
                            ques_label.text = ""
                            anss_label.text = ""
                            anss_label.isUserInteractionEnabled = true
                        }
                    }
                    
                }else if drinkCell > 0 && smokeCell == 0
                {
                    if indexPath.row == 6
                    {
                        cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")!
                        let ques_label = cell.viewWithTag(1) as! UILabel
                        let anss_label = cell.viewWithTag(2) as! UITextField
                        let arrowBtn = cell.viewWithTag(121) as! UIButton
                        anss_label.isSecureTextEntry = false
                        anss_label.placeholder = ""
                        anss_label.isUserInteractionEnabled = true
                        arrowBtn.isHidden = true
                        let borderColor = UIColor(red: 138.0 / 255.0, green: 219.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
                        anss_label.leftViewMode = UITextFieldViewMode.always
                        anss_label.layer.borderColor = borderColor.cgColor;
                        anss_label.layer.borderWidth = 0.0;
                        ques_label.text = "Number of drinks a week on average".uppercased()
                        anss_label.placeholder = "Number of drinks a week on average".uppercased()
                        anss_label.layer.borderColor = borderColor.cgColor;
                        anss_label.layer.borderWidth = 0.0;
                        anss_label.text = no_of_drink
                        anss_label.isUserInteractionEnabled = true
                    }
                }
            }
        }else if indexPath.section == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            let arrowBtn = cell.viewWithTag(111) as! UIButton
            arrowBtn.layer.cornerRadius = 3.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return UITableViewAutomaticDimension
            }
            
            if indexPath.row == 10 || indexPath.row == 8 || indexPath.row == 6
            {
                return 55
            }
            else
            {
                if indexPath.row == 1  || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 11 || indexPath.row == 13 || indexPath.row == 15 || indexPath.row == 17
                {
                    return UITableViewAutomaticDimension
                }else
                {
                    return 55
                }
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                return 56
            }
            else
            {
                
                if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
                {
                    return 0
                }
                
                if drinkCell > 0 && smokeCell > 0
                {
                    if indexPath.row == 5 ||   indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 ||  indexPath.row == 10
                    {
                        return 55
                    }else if indexPath.row == 13
                    {
                        return 0
                    }
                }else if smokeCell > 0 && drinkCell == 0
                {
                    if indexPath.row == 5 ||   indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8
                    {
                        return 55
                    }else if indexPath.row == 12
                    {
                        return 0
                    }
                    
                }else if drinkCell > 0 && smokeCell == 0
                {
                    if indexPath.row == 6
                    {
                        return 55
                    }else if indexPath.row == 8
                    {
                        return 0
                    }
                }
                else
                {
                    if indexPath.row == 8
                    {
                        return 0
                    }else
                    {
                        return UITableViewAutomaticDimension
                    }
                    
                }
            }
        }else if indexPath.section == 2
        {
            return UITableViewAutomaticDimension
        }
        else{
            return 70
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.view.endEditing(true)
        currentindex = indexPath.row
        print(indexPath.row)
        if indexPath.section == 0
        {
            if indexPath.row == 3 || indexPath.row == 12 || indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 14 || indexPath.row == 16 || indexPath.row == 18
            {
                datePickerView.isHidden = false
            }else
            {
                datePickerView.isHidden = true
            }
        }
            
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
            }
            else
            {
                if drinkCell > 0 && smokeCell > 0
                {
                    if indexPath.row == 7
                    {
                        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyHistoryOptionsViewController") as! FamilyHistoryOptionsViewController
                        //vc.delegate = self
                        // smoke value
                        //goingFrom = 7
                        // vc.commingFor = "Currentorex-smoker"
                        //self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if smokeCell > 0 && drinkCell == 0
                {
                    if indexPath.row == 7
                    {
                        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyHistoryOptionsViewController") as! FamilyHistoryOptionsViewController
                        //vc.delegate = self
                        // smoke value
                        //goingFrom = 7
                        //vc.commingFor = "Currentorex-smoker"
                        //self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if drinkCell > 0 && smokeCell == 0
                {
                }else
                {
                }
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
    
    // text filed delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let hitPoint: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        if (indexPath?.section)! == 0{
            let resultString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if (indexPath?.row)! == 17{
                return true
            }
            return  self.validateDecimalValue(resultString)
        }
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        datePickerView.isHidden = true
        textField.inputAccessoryView = self.getInputAccessayViewForTextField(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let hitPoint: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        
        if (indexPath?.section)! == 0
        {
            if indexPath?.row == 1
            {
                if textField.tag == 2
                {
//                    if textField.text! != "" && Float(textField.text!)! > 999.0{
//                        supportingfuction.showMessageHudWithMessage(message: "Invalid height.", delay: 2.0)
//                        return
//                    }
                    dataInfoDict.setValue(textField.text, forKey: "height")
                }
                
            }
            else if indexPath?.row == 2
            {
                if textField.tag == 2
                {
                    dataInfoDict.setValue(textField.text, forKey: "weight")
                }
            }
                
            else if indexPath?.row == 5
            {
                if textField.tag == 2
                {
                    dataInfoDict.setValue(textField.text, forKey: "systolic_blood_pressure")
                }
                else if textField.tag == 4
                {
                    dataInfoDict.setValue(textField.text, forKey: "diastolic_blood_pressure")
                }
            }
            else if indexPath?.row == 4
            {
                if textField.tag == 2
                {
                    dataInfoDict.setValue(textField.text, forKey: "diastolic_blood_pressure")
                }
            }
                
            else  if indexPath?.row == 7
            {
                dataInfoDict.setValue(textField.text, forKey: "heartbeat")
            }
            else  if indexPath?.row == 11
            {
                dataInfoDict.setValue(textField.text, forKey: "oxygen_level")
            }
            else  if indexPath?.row == 13
            {
                dataInfoDict.setValue(textField.text, forKey: "glucose_level")
            }
            else  if indexPath?.row == 15
            {
                dataInfoDict.setValue(textField.text, forKey: "pregnancy_test")
            }
            else  if indexPath?.row == 17
            {
                dataInfoDict.setValue(textField.text, forKey: "other")
            }
                
            else  if indexPath?.row == 9
            {
                dataInfoDict.setValue(textField.text, forKey: "highest_temperature_recorded")
            }
        }
        else if (indexPath?.section)! == 1
        {
            if dataInfoDict.object(forKey: "is_smoked") != nil && dataInfoDict.object(forKey: "is_smoked") as! String == "" && dataInfoDict.object(forKey: "is_alcohol") != nil && dataInfoDict.object(forKey: "is_alcohol") as! String == "yes"
            {
                if indexPath!.row == 6
                {
                    no_of_drink  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "no_of_drinks")
                }
            }
            
            if dataInfoDict.object(forKey: "is_smoked") != nil && dataInfoDict.object(forKey: "is_smoked") as! String == "yes" &&
                dataInfoDict.object(forKey: "is_alcohol") != nil  && dataInfoDict.object(forKey: "is_alcohol") as! String == "yes"
            {
                if indexPath?.row == 5
                {
                    no_of_stick = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_1")
                }
                else if indexPath?.row == 6
                {
                    year_smoking  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_2")
                }
                else if indexPath?.row == 7
                {
                    curr_ex = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_3")
                    //
                }
                else if indexPath?.row == 8
                {
                    stopped_time  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_4")
                }
                else if  indexPath?.row == 10
                {
                    no_of_drink  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "no_of_drinks")
                }else
                {
                    // do nothing
                }
            }else if  dataInfoDict.object(forKey: "is_smoked") != nil && dataInfoDict.object(forKey: "is_smoked") as! String == "yes" && dataInfoDict.object(forKey: "is_alcohol") != nil && dataInfoDict.object(forKey: "is_alcohol") as! String == "no"
            {
                if indexPath?.row == 5
                {
                    no_of_stick  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_1")
                }else if   indexPath?.row == 6
                {
                    year_smoking  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_2")
                    
                }else if  indexPath?.row == 7
                {
                    curr_ex = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_3")
                    //
                }else if  indexPath?.row == 8
                {
                    stopped_time  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_4")
                }else
                {
                    // do nothing
                }
            }
            else if dataInfoDict.object(forKey: "is_alcohol") != nil && dataInfoDict.object(forKey: "is_alcohol") as! String == "yes" && dataInfoDict.object(forKey: "is_smoked") != nil && dataInfoDict.object(forKey: "is_smoked") as! String == "no"
            {
                if indexPath?.row == 6
                {
                    no_of_drink  = (textField.text)!
                    dataInfoDict.setValue(textField.text, forKey: "smoked_1")
                }
            }else
            {
            }
        }
    }
    
    
    func getInputAccessayViewForTextField(_ textField:UITextField)-> UIToolbar{
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
    
    func takeTheSelectedValue(dataDict: String, index: Int)
    {
        if  goingFrom == 7 // smoke value
        {
            if dataDict != ""
            {
                curr_ex = dataDict
            }
            print(dataDict)
        }
        tableView.reloadData()
    }
    
    
    func validateDecimalValue(_ string:String)-> Bool{
        
        var sep = string.components(separatedBy: ".")
        var sepStr2 = sep[0] as! String
        
//        if sepStr2.characters.count > 3{
//            return false
//        }
//        else
            if sep.count == 2{
            var sepStr = sep[1] as! String
            
            if sepStr.characters.count > 3{
                return false
            }
            return true
        }else if sep.count > 2{
            return false
        }
        return true
    }
    
    func getUserData(){
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(self.id_appointment, forKey: "id_appointment" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.physical_stats,dict, {(operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                    
                {
                    if (dataFromServer as AnyObject).object(forKey: "data") != nil
                    {
                        self.dataInfoDict = (dataFromServer.object(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        if (self.dataInfoDict.object(forKey: "smoked_1") is NSNull == false) && (self.dataInfoDict.object(forKey: "smoked_1")) != nil && (self.dataInfoDict.object(forKey: "smoked_1") as! String) != ""
                        {
                            self.no_of_stick = self.dataInfoDict.object(forKey: "smoked_1") as! String
                        }
                        
                        if (self.dataInfoDict.object(forKey: "smoked_2") is NSNull == false) && (self.dataInfoDict.object(forKey: "smoked_2")) != nil && (self.dataInfoDict.object(forKey: "smoked_2") as! String) != ""
                        {
                            self.year_smoking = self.dataInfoDict.object(forKey: "smoked_2") as! String
                        }
                        if (self.dataInfoDict.object(forKey: "smoked_3") is NSNull == false) && (self.dataInfoDict.object(forKey: "smoked_3")) != nil && (self.dataInfoDict.object(forKey: "smoked_3") as! String) != ""
                        {
                            self.curr_ex = (self.dataInfoDict.object(forKey: "smoked_3") as! String).capitalized
                        }
                        
                        if (self.dataInfoDict.object(forKey: "smoked_4") is NSNull == false) && (self.dataInfoDict.object(forKey: "smoked_4")) != nil && (self.dataInfoDict.object(forKey: "smoked_4") as! String) != ""
                        {
                            self.stopped_time = self.dataInfoDict.object(forKey: "smoked_4") as! String
                        }
                        
                        if (self.dataInfoDict.object(forKey: "no_of_drinks") is NSNull == false) && (self.dataInfoDict.object(forKey: "no_of_drinks")) != nil && (self.dataInfoDict.object(forKey: "no_of_drinks") as! String) != ""
                        {
                            self.no_of_drink = self.dataInfoDict.object(forKey: "no_of_drinks") as! String
                        }
                        if (self.dataInfoDict.object(forKey: "is_smoked") as! String) == "yes"
                        {
                            self.smokeCell = 4
                        }
                        if (self.dataInfoDict.object(forKey: "is_alcohol") as! String) == "yes"
                        {
                            self.drinkCell = 1
                        }
                        self.tableView?.reloadData()
                    }
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else{
                    supportingfuction.hideProgressHudInView(view: self)
                    
                    self.dataInfoDict.setObject("", forKey: "is_smoked" as NSCopying)
                    self.dataInfoDict.setObject("", forKey: "lifestyle_step2" as NSCopying)
                    self.dataInfoDict.setObject("", forKey: "lifestyle_step3" as NSCopying)
                    self.dataInfoDict.setObject("", forKey: "is_smoked" as NSCopying)
                    self.dataInfoDict.setObject("", forKey: "is_alcohol" as NSCopying)
                    self.dataInfoDict.setObject("", forKey: "is_work" as NSCopying)
                    self.dataInfoDict.setObject("", forKey: "is_exercise" as NSCopying)
                    self.dataInfoDict.setObject("", forKey: "lifestyle_step8" as NSCopying)
                    
                    if dataFromServer.object(forKey: "message") != nil
                    {
                        //                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    }
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    // date picker
    func setDateAndTime()
    {
        datePicker.datePickerMode = UIDatePickerMode.date
        let date: DateFormatter = DateFormatter()
        //date.dateFormat = "dd-MM-YYYY"
        date.dateFormat = "dd MMM, yyyy"
        let currDate = NSDate() as Date
        if currDate.compare(datePicker.date) == .orderedAscending
        {
            // appdelegate.showMessageHudWithMessage(message: "Please select valid date." as NSString, delay: 2.0)
            return
        }
        else
        {
            
            if currentindex == 3
            {
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "height_weight_taken")
                
            }else if currentindex == 6
            {
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "diastolic_systolic_pressure_taken")
            }else if currentindex == 10
            {
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "highest_temperature_recorded_taken")
            }
            else if currentindex == 8
            {
                
                //data not decided
                
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "heartbeat_taken")
            }
            else if currentindex == 14
            {
                //glucose_level_taken
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "glucose_level_taken")
            }
                
            else if currentindex == 16
            {
                //glucose_level_taken
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "pregnancy_test_taken")
            }
                
                
            else if currentindex == 18
            {
                //glucose_level_taken
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "other_taken")
            }
                //other_taken
                
            else
            {
                // currrent index == 12
                dataInfoDict.setValue((date.string(from: datePicker.date) ), forKey: "oxygen_level_taken")
            }
            // signUpDictionary.setObject((date.string(from: datePicker.date) ), forKey: "date_of_birth" as NSCopying)
        }
        self.tableView?.reloadData()
    }
    
    //MARK:- Action Functions
    //after tapped it will call
    @IBAction func selectedDate(sender: AnyObject)
    {
        setDateAndTime()
        datePickerView.isHidden = true
    }
    
    @IBAction func DateCancelBtn(sender: UIButton)
    {
        datePickerView.isHidden = true
    }
    
    @IBAction func backbtnTapped(sender: UIButton){
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        //        self.view.endEditing(true)
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    @IBAction func yesButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if sender.isSelected == false
        {
            let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
            let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
            print(cellIndexPath!)
            if cellIndexPath?[1] == 1
            {
                dataInfoDict.setObject("yes", forKey: "is_smoked" as NSCopying)
            }else if cellIndexPath?[1] == 2
            {
                dataInfoDict.setObject("yes", forKey: "lifestyle_step2" as NSCopying)
            }
            else if cellIndexPath?[1] == 3
            {
                dataInfoDict.setObject("yes", forKey: "lifestyle_step3" as NSCopying)
            }
            else if cellIndexPath?[1] == 4
            {
                dataInfoDict.setObject("yes", forKey: "is_smoked" as NSCopying)
                smokeCell = 4
            }
            else if cellIndexPath?[1] == 5 + smokeCell
            {
                drinkCell = 1
                dataInfoDict.setObject("yes", forKey: "is_alcohol" as NSCopying)
            }else if cellIndexPath?[1] == 7 + drinkCell + smokeCell
            {
                dataInfoDict.setObject("yes", forKey: "is_work" as NSCopying)
            }else if cellIndexPath?[1] == 6 + drinkCell + smokeCell
            {
                dataInfoDict.setObject("yes", forKey: "is_exercise" as NSCopying)
            }else if cellIndexPath?[1] == 8 + drinkCell + smokeCell
            {
                dataInfoDict.setObject("yes", forKey: "lifestyle_step8" as NSCopying)
            }
        }
        else
        {
            
            self.view.endEditing(true)
            let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
            let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
            
            print(cellIndexPath!)
            
            if cellIndexPath?[1] == 1
            {
                dataInfoDict.setObject("no", forKey: "is_smoked" as NSCopying)
            }else if cellIndexPath?[1] == 2
            {
                dataInfoDict.setObject("no", forKey: "lifestyle_step2" as NSCopying)
            }
            else if cellIndexPath?[1] == 3
            {
                dataInfoDict.setObject("no", forKey: "lifestyle_step3" as NSCopying)
            }
            else if cellIndexPath?[1] == 4
            {
                dataInfoDict.setObject("no", forKey: "is_smoked" as NSCopying)
                //smokeCell = 0
                smokeCell = 0
            }
            else if cellIndexPath?[1] == 5 + smokeCell
            {
                drinkCell = 0
                dataInfoDict.setObject("no", forKey: "is_alcohol" as NSCopying)
            }else if cellIndexPath?[1] ==  7 + drinkCell + smokeCell
            {
                dataInfoDict.setObject("no", forKey: "is_work" as NSCopying)
            }else if cellIndexPath?[1] == 6 + drinkCell + smokeCell
            {
                dataInfoDict.setObject("no", forKey: "is_exercise" as NSCopying)
            }else if cellIndexPath?[1] == 8 + drinkCell + smokeCell
            {
                dataInfoDict.setObject("no", forKey: "lifestyle_step8" as NSCopying)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func noButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        
        print(cellIndexPath!)
        
        if cellIndexPath?[1] == 1
        {
            dataInfoDict.setObject("no", forKey: "is_smoked" as NSCopying)
        }else if cellIndexPath?[1] == 2
        {
            dataInfoDict.setObject("no", forKey: "lifestyle_step2" as NSCopying)
        }
        else if cellIndexPath?[1] == 3
        {
            dataInfoDict.setObject("no", forKey: "lifestyle_step3" as NSCopying)
        }
        else if cellIndexPath?[1] == 4
        {
            dataInfoDict.setObject("no", forKey: "is_smoked" as NSCopying)
            //smokeCell = 0
            smokeCell = 0
        }
        else if cellIndexPath?[1] == 5 + smokeCell
        {
            drinkCell = 0
            dataInfoDict.setObject("no", forKey: "is_alcohol" as NSCopying)
        }else if cellIndexPath?[1] ==  6 + drinkCell + smokeCell
        {
            dataInfoDict.setObject("no", forKey: "is_work" as NSCopying)
        }else if cellIndexPath?[1] == 7 + drinkCell + smokeCell
        {
            dataInfoDict.setObject("no", forKey: "is_exercise" as NSCopying)
        }else if cellIndexPath?[1] == 8 + drinkCell + smokeCell
        {
            dataInfoDict.setObject("no", forKey: "lifestyle_step8" as NSCopying)
        }
        tableView.reloadData()
    }
    
    @IBAction func whenDropAction(_ sender: AnyObject) {
    }
    
    
    //MARK:- edit_physicalParam web method
    
    @IBAction func nextAction(_ sender: AnyObject)
    {
        self.view.endEditing(true)
        self.validatePhysicalStatData()
//        physical_stats_edit()
    }
    
    func validatePhysicalStatData(){
        print(dataInfoDict)
        
        if dataInfoDict.object(forKey:"height") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter height.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"weight") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter weight.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"height_weight_taken") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select height and weight measured date.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"diastolic_blood_pressure") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter Diastolic blood pressue(MM/HG).", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"systolic_blood_pressure") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter Systolic blood pressue(MM/HG).", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"diastolic_systolic_pressure_taken") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select diastolic and systolic measured date.", delay: 2.0)
            return
        }
        
        if dataInfoDict.object(forKey:"heartbeat") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter heartbeat.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"heartbeat_taken") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select heartbeat measured date.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"highest_temperature_recorded") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter highest temperature recorded.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"highest_temperature_recorded_taken") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select highest temperature measured date.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"oxygen_level") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter oxygen level.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"oxygen_level_taken") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select oxygen level measured date.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"pregnancy_test") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter pregnancy test.", delay: 2.0)
            return
        }
        
        if dataInfoDict.object(forKey:"pregnancy_test_taken") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select pregnancy test measured date.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"other") as! String != "" &&  dataInfoDict.object(forKey:"other_taken") as! String == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select other test measured date.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"other") as! String == "" &&  dataInfoDict.object(forKey:"other_taken") as! String != ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter other test discription.", delay: 2.0)
            return
        }
        if dataInfoDict.object(forKey:"is_smoked") as! String == "yes" {
            
//            requestData.setObject(no_of_stick, forKey: "smoked_1" as NSCopying)
//            requestData.setObject(year_smoking, forKey: "smoked_2" as NSCopying)
//            requestData.setObject(curr_ex, forKey: "smoked_3" as NSCopying)
//            requestData.setObject(stopped_time, forKey: "smoked_4" as NSCopying)
//            requestData.setObject(no_of_drink, forKey: "no_of_drinks" as NSCopying)
            
            if self.no_of_stick == "" {
                supportingfuction.showMessageHudWithMessage(message: "Please enter number of sticks a day on average.", delay: 2.0)
                return
            }
            if self.year_smoking == "" {
                supportingfuction.showMessageHudWithMessage(message: "Please enter number of years of smoking.", delay: 2.0)
                return
            }
            if self.curr_ex == "" {
                supportingfuction.showMessageHudWithMessage(message: "Please enter current of ex-smoker.", delay: 2.0)
                return
            }
            if self.stopped_time == "" {
                supportingfuction.showMessageHudWithMessage(message: "Please enter how long ago did you used tobacco prod.", delay: 2.0)
                return
            }
        }
        if dataInfoDict.object(forKey:"is_alcohol") as! String == "yes" {
            if self.no_of_drink == "" {
                supportingfuction.showMessageHudWithMessage(message: "Please enter number of drinks a week on average.", delay: 2.0)
                return
            }
        }
        physical_stats_edit()
    }
    
    func physical_stats_edit()
    {
        self.view.endEditing(true)
        
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            return
        }
        else
        {
            
        }
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let requestData = NSMutableDictionary()
        
        requestData.setObject(self.dataDict.object(forKey: "user_id"), forKey: "id_user" as NSCopying)
        requestData.setObject(self.dataDict.object(forKey:"nurse_id"), forKey: "id_nurse" as NSCopying)
        requestData.setObject(self.dataDict.object(forKey: "appointment_id"), forKey: "id_appointment" as NSCopying)
        
        if (dataInfoDict.object(forKey: "height")) != nil && (dataInfoDict.object(forKey: "height") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "height") as! String, forKey: "height" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "height" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "weight")) != nil && (dataInfoDict.object(forKey: "weight") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "weight") as! String, forKey: "weight" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "weight" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "height_weight_taken")) != nil && (dataInfoDict.object(forKey: "height_weight_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "height_weight_taken") as! String, forKey: "height_weight_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "height_weight_taken" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "systolic_blood_pressure")) != nil && (dataInfoDict.object(forKey: "systolic_blood_pressure") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "systolic_blood_pressure") as! String, forKey: "systolic_blood_pressure" as NSCopying)
        }else
        {
            
            requestData.setObject("", forKey: "systolic_blood_pressure" as NSCopying)
        }
        if (dataInfoDict.object(forKey: "diastolic_blood_pressure")) != nil && (dataInfoDict.object(forKey: "diastolic_blood_pressure") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "diastolic_blood_pressure") as! String, forKey: "diastolic_blood_pressure" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "diastolic_blood_pressure" as NSCopying)
        }
        if (dataInfoDict.object(forKey: "diastolic_systolic_pressure_taken")) != nil && (dataInfoDict.object(forKey: "diastolic_systolic_pressure_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "diastolic_systolic_pressure_taken") as! String, forKey: "diastolic_systolic_pressure_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "diastolic_systolic_pressure_taken" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "heartbeat")) != nil && (dataInfoDict.object(forKey: "heartbeat") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "heartbeat") as! String, forKey: "heartbeat" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "heartbeat" as NSCopying)
        }
        if (dataInfoDict.object(forKey: "heartbeat_taken")) != nil && (dataInfoDict.object(forKey: "heartbeat_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "heartbeat_taken") as! String, forKey: "heartbeat_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "heartbeat_taken" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "highest_temperature_recorded")) != nil && (dataInfoDict.object(forKey: "highest_temperature_recorded") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "highest_temperature_recorded") as! String, forKey: "highest_temperature_recorded" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "highest_temperature_recorded" as NSCopying)
        }
        if (dataInfoDict.object(forKey: "highest_temperature_recorded_taken")) != nil && (dataInfoDict.object(forKey: "highest_temperature_recorded_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "highest_temperature_recorded_taken") as! String, forKey: "highest_temperature_recorded_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: " highest_temperature_recorded_taken" as NSCopying)
        }
        if (dataInfoDict.object(forKey: "oxygen_level")) != nil && (dataInfoDict.object(forKey: "oxygen_level") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "oxygen_level") as! String, forKey: "oxygen_level" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "oxygen_level" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "oxygen_level_taken")) != nil && (dataInfoDict.object(forKey: "oxygen_level_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "oxygen_level_taken") as! String, forKey: "oxygen_level_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "oxygen_level_taken" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "glucose_level")) != nil && (dataInfoDict.object(forKey: "glucose_level") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "glucose_level") as! String, forKey: "glucose_level" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "glucose_level" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "glucose_level_taken")) != nil && (dataInfoDict.object(forKey: "glucose_level_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "glucose_level_taken") as! String, forKey: "glucose_level_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "glucose_level_taken" as NSCopying)
        }
        if (dataInfoDict.object(forKey: "pregnancy_test")) != nil && (dataInfoDict.object(forKey: "pregnancy_test") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "pregnancy_test") as! String, forKey: "pregnancy_test" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "pregnancy_test" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "pregnancy_test_taken")) != nil && (dataInfoDict.object(forKey: "pregnancy_test_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "pregnancy_test_taken") as! String, forKey: "pregnancy_test_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "pregnancy_test_taken" as NSCopying)
        }
        
        /////////
        if (dataInfoDict.object(forKey: "other")) != nil && (dataInfoDict.object(forKey: "other") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "other") as! String, forKey: "other" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "other" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "other_taken")) != nil && (dataInfoDict.object(forKey: "other_taken") is NSNull == false)
        {
            requestData.setObject(dataInfoDict.object(forKey: "other_taken") as! String, forKey: "other_taken" as NSCopying)
        }else
        {
            requestData.setObject("", forKey: "other_taken" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "is_smoked")) != nil && (dataInfoDict.object(forKey: "is_smoked") is NSNull == false) && dataInfoDict.object(forKey: "is_smoked") as! String != ""
        {
            requestData.setObject(dataInfoDict.object(forKey: "is_smoked") as! String, forKey: "is_smoked" as NSCopying)
        }else
        {
            requestData.setObject("no", forKey: "is_smoked" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "is_alcohol")) != nil && (dataInfoDict.object(forKey: "is_alcohol") is NSNull == false) && dataInfoDict.object(forKey: "is_alcohol") as! String != ""

        {
            requestData.setObject(dataInfoDict.object(forKey: "is_alcohol") as! String, forKey: "is_alcohol" as NSCopying)
        }else
        {
            requestData.setObject("no", forKey: "is_alcohol" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "is_work")) != nil && (dataInfoDict.object(forKey: "is_work") is NSNull == false) && dataInfoDict.object(forKey: "is_work") as! String != ""
        {
            requestData.setObject(dataInfoDict.object(forKey: "is_work") as! String, forKey: "is_work" as NSCopying)
        }else
        {
            requestData.setObject("no", forKey: "is_work" as NSCopying)
        }
        
        if (dataInfoDict.object(forKey: "is_exercise")) != nil && (dataInfoDict.object(forKey: "is_exercise") is NSNull == false) && dataInfoDict.object(forKey: "is_exercise") as! String != ""

        {
            requestData.setObject(dataInfoDict.object(forKey: "is_exercise") as! String, forKey: "is_exercise" as NSCopying)
        }else
        {
            requestData.setObject("no", forKey: "is_exercise" as NSCopying)
        }
        
        requestData.setObject(no_of_stick, forKey: "smoked_1" as NSCopying)
        requestData.setObject(year_smoking, forKey: "smoked_2" as NSCopying)
        requestData.setObject(curr_ex, forKey: "smoked_3" as NSCopying)
        requestData.setObject(stopped_time, forKey: "smoked_4" as NSCopying)
        requestData.setObject(no_of_drink, forKey: "no_of_drinks" as NSCopying)
//        requestData.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.physical_stats_edit,requestData, {(operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                // print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") as! String == "success"
                {
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    
                }else
                {
                    supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "msg") as! String as NSString, delay: 2.0)
                }
            }
            
        }) { (operation, error) in
            // print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
}
