//
//  MedicalHistoryView.swift
//  QuickHealthDoctorApp
//
//  Created by SS21 on 23/01/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class MedicalHistoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView?
    
    var appointmentID = ""
    
    var medicalHistoryData:MedicalHistory!{
        didSet{
            self.tableViewHeaders = MedicationHeaders()
        }
    }
    
    var tableViewHeaders:MedicationHeaders!{
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.rowHeight = 150
        self.tableView?.sectionHeaderHeight =  100
        self.tableView?.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        medicalHistory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK:- Table View  Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return self.medicalHistoryData.currentMedications.count + 1
        }else if section == 1{
            if self.medicalHistoryData.is_drug_sensitivity ==  "no"{
                return 1
            }else{
                return 1 + 1
            }
        }else if section == 2{
            return self.medicalHistoryData.medicalSurgery.count + 1
        }else{
            return self.medicalHistoryData.medicalConditions.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        if indexPath.section == 0
        {
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                let headerQuestion = cell.viewWithTag(1) as! UILabel
                let headerAnswer = cell.viewWithTag(2) as! UILabel
                headerQuestion.text = tableViewHeaders.currentMedicationLabel
                headerAnswer.text = self.medicalHistoryData.is_medication
            }else{
              cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
                let medicineName = cell.viewWithTag(1) as! UILabel
                let takingValue =  cell.viewWithTag(2) as! UILabel
                let description = cell.viewWithTag(3) as! UILabel
                let seperatorView = cell.viewWithTag(4)
                if let x = self.medicalHistoryData.currentMedications[indexPath.row - 1] as? CurrentMedication{
                    medicineName.text = "\(x.medicine) \(x.strength)"
                    takingValue.text = x.usage
                    description.text = x.reason_for_taking
                }
                seperatorView?.isHidden = false
//                if indexPath.row == self.medicalHistoryData.currentMedications.count{
//                    seperatorView?.isHidden = false
//                }else{
//                    seperatorView?.isHidden = true
//                }
            }
            return cell
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                let headerQuestion = cell.viewWithTag(1) as! UILabel
                let headerAnswer = cell.viewWithTag(2) as! UILabel
                headerQuestion.text = tableViewHeaders.drugSenstivityLabel
                headerAnswer.text = self.medicalHistoryData.is_drug_sensitivity
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "historyQuesCell", for: indexPath)
                let description = cell.viewWithTag(1) as! UILabel
                description.text = self.medicalHistoryData.drug_sensitivity_description
            }
            return cell
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                let headerQuestion = cell.viewWithTag(1) as! UILabel
                let headerAnswer = cell.viewWithTag(2) as! UILabel
                headerQuestion.text = tableViewHeaders.surgeriesLabel
                headerAnswer.text = self.medicalHistoryData.is_surgeries_medical_procedure
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "medicalStatCell", for: indexPath)
                let title = cell.viewWithTag(1) as! UILabel
                let value = cell.viewWithTag(2) as! UILabel
                
                if let x = self.medicalHistoryData.medicalSurgery[indexPath.row - 1] as? MedicalSurgery{
                    title.text = x.title
                    value.text = x.when
                }
                let seperatorView = cell.viewWithTag(4)
                seperatorView?.isHidden = false
//                if indexPath.row - 2 == self.medicalHistoryData.medicalSurgery.count{
//                    seperatorView?.isHidden = false
//                }else{
//                    seperatorView?.isHidden = true
//                }
            }
            return cell
        }else{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                let headerQuestion = cell.viewWithTag(1) as! UILabel
                let headerAnswer = cell.viewWithTag(2) as! UILabel
                headerQuestion.text = tableViewHeaders.medicalConditionsLabel
                headerAnswer.text = self.medicalHistoryData.is_medical_condition
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "medicalStatCell", for: indexPath)
                let title = cell.viewWithTag(1) as! UILabel
                let value = cell.viewWithTag(2) as! UILabel
                if let x = self.medicalHistoryData.medicalConditions[indexPath.row - 1] as? MedicalCondition{
                    title.text = x.title
                    value.text = x.when
                }
                let seperatorView = cell.viewWithTag(4)
                seperatorView?.isHidden = false
//                if indexPath.row - 1 == self.medicalHistoryData.medicalConditions.count{
//                    seperatorView?.isHidden = false
//                }else{
//                    seperatorView?.isHidden = true
//                }
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.medicalHistoryData != nil{
          return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- Web Service Implementation
    
    func medicalHistory()->Void{
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject(self.appointmentID, forKey: "id_appointment" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.medication,dict, {(operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary{
                supportingfuction.hideProgressHudInView(view: self)
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306"){
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") as! String == "success"{
                    if (dataFromServer as AnyObject).object(forKey: "data") != nil{
                        self.medicalHistoryData = MedicalHistory(json: dataFromServer.object(forKey: "data") as! NSDictionary)
                    }
                }
            }
        }) { (operation, error) in
            // print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    
}

