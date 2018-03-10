//
//  PhysicalStatsViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 08/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class PhysicalStatsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
      @IBOutlet weak var tableView: UITableView?
      var physicalDataDict = NSMutableDictionary()
      var id_appointment = ""
    override func viewWillAppear(_ animated: Bool) {
        if(!appDelegate.hasConnectivity()){
            supportingfuction.showMessageHudWithMessage(message: "No Internet Connection" , delay: 2.0)
        }else{
           getUserData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.estimatedRowHeight = 80
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - backBtn action
    @IBAction func backBtnTapper(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - tableview delegates\\
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 
        {
            return 8
        }else if section == 1
        {
            if let x = (physicalDataDict.object(forKey: "is_smoked") as? String)
            {
                if x.lowercased() == "yes"
                {
                    return 5
                }else
                {
                    return 1
                }
            }else
            {
                return 0
            }
            
        }else if section == 2
        {
            if let x = (physicalDataDict.object(forKey: "is_alcohol") as? String)
            {
                if x.lowercased() == "yes"
                {
                     return 2
                }else
                {
                    return 1
                }
            }else
            {
                return 0
            }
           
        }else if section == 3
        {
            return 1
        }else
        {
           return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                return 70
            }else{
                return UITableViewAutomaticDimension
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                return 70
            }else{
                return 40
            }
        }else if indexPath.section == 3{
            return 70
        }else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if indexPath.section == 0
        {
            if indexPath.row == 0  // height weight cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "heightWeightCell")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let measuredLbl = cell.viewWithTag(3) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let weightheadingLbl = cell.viewWithTag(-2) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-3) as! UILabel
                
                heightheadingLbl.text = "Height :"
                weightheadingLbl.text = "Weight :"
                measuredheadingLbl.text = "Measured On :"
                
                if let x = (physicalDataDict.object(forKey: "height") as? String)
                {
                   heightLbl.text = x + " cm"
                }
                 if let x = (physicalDataDict.object(forKey: "weight") as? String)
                 {
                     weightLbl.text = x + " kg"
                }
               
                if let x = (physicalDataDict.object(forKey: "height_weight_taken") as? String)
                {
                    measuredLbl.text = x
                }
                
                
            }else if indexPath.row == 1  // diastolic systolic  cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "heightWeightCell")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let measuredLbl = cell.viewWithTag(3) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let weightheadingLbl = cell.viewWithTag(-2) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-3) as! UILabel
                heightheadingLbl.text = "Diastolic Blood Pressure :"
                weightheadingLbl.text = "Systolic Blood Pressure :"
                measuredheadingLbl.text = "Measured On :"
                
                
                if let x = (physicalDataDict.object(forKey: "diastolic_blood_pressure") as? String)
                {
                    heightLbl.text = x + " mmHg"
                }
                if let x = (physicalDataDict.object(forKey: "systolic_blood_pressure") as? String)
                {
                   weightLbl.text = x + " mmHg"
                }
               if let x = (physicalDataDict.object(forKey: "diastolic_systolic_pressure_taken") as? String)
               {
                measuredLbl.text = x
                }
     
                

            }else if indexPath.row == 2 // hypoCount  cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "hypoCount")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-2) as! UILabel
                heightheadingLbl.text = "Heartbeat :"
                measuredheadingLbl.text = "Measured On :"
                if let x = (physicalDataDict.object(forKey: "heartbeat") as? String)
                {
                  heightLbl.text = x + " bpm"
                }
                if let x = (physicalDataDict.object(forKey: "heartbeat_taken") as? String)
                {
                weightLbl.text = x
                }
            }else if indexPath.row == 3 // heartbeat cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "hypoCount")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-2) as! UILabel
                heightheadingLbl.text = "Highest Temprature Recorded :"
                measuredheadingLbl.text = "Measured On :"
                if let x = (physicalDataDict.object(forKey: "highest_temperature_recorded") as? String)
                {
                heightLbl.text = x + "°C"
                }
                if let x = (physicalDataDict.object(forKey: "highest_temperature_recorded_taken") as? String)
                {
                weightLbl.text = x
                }
            }else if indexPath.row == 4 // heartbeat cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "hypoCount")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-2) as! UILabel
                heightheadingLbl.text = "Oxygen Level :"
                measuredheadingLbl.text = "Measured On :"
                if let x = (physicalDataDict.object(forKey: "oxygen_level") as? String)
                {
                heightLbl.text = x
                }
                if let x = (physicalDataDict.object(forKey: "oxygen_level_taken") as? String)
                {
                     weightLbl.text = x
                }
               
            }else if indexPath.row == 5 // heartbeat cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "hypoCount")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-2) as! UILabel
                heightheadingLbl.text = "Glucose Level :"
                measuredheadingLbl.text = "Measured On :"
                if let x = (physicalDataDict.object(forKey: "glucose_level") as? String)
                {
                  heightLbl.text = x
                }
                if let x = (physicalDataDict.object(forKey: "glucose_level_taken") as? String)
                {
                weightLbl.text = x
                }
            }else if indexPath.row == 6 // heartbeat cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "hypoCount")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-2) as! UILabel
                heightheadingLbl.text = "Pregnancy Test :"
                measuredheadingLbl.text = "Measured On :"
                if let x = (physicalDataDict.object(forKey: "pregnancy_test") as? String)
                {
                    heightLbl.text = x
                }
                if let x = (physicalDataDict.object(forKey: "pregnancy_test_taken") as? String)
                {
                    weightLbl.text = x
                }
               
            }
            else if indexPath.row == 7 // heartbeat cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "hypoCount")
                let heightLbl = cell.viewWithTag(1) as! UILabel
                let weightLbl = cell.viewWithTag(2) as! UILabel
                let heightheadingLbl = cell.viewWithTag(-1) as! UILabel
                let measuredheadingLbl = cell.viewWithTag(-2) as! UILabel
                heightheadingLbl.text = "Other :"
                measuredheadingLbl.text = "Measured On :"
                if let x =  (physicalDataDict.object(forKey: "other") as? String)
                {
                   heightLbl.text = x
                }
                if let x = (physicalDataDict.object(forKey: "other_taken") as? String)
                {
                    weightLbl.text = x
                }
                
            }
            
            else // lifestyle cell
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingCell")
            }
        }else if indexPath.section == 1
        {
           if indexPath.row == 0
           {
            cell = tableView.dequeueReusableCell(withIdentifier: "generalCell")
            let quesLbl = cell.viewWithTag(1) as! UILabel
            let ansLbl = cell.viewWithTag(2) as! UILabel
            let imgview = cell.viewWithTag(-99) as! UIImageView
            
            quesLbl.text = "Do you smoke or used used any tobacco products?"
            //
            if let x = (physicalDataDict.object(forKey: "is_smoked") as? String)
            {
               ansLbl.text = x
                if x.lowercased() == "yes"
                {
                    imgview.isHidden = true
                }else
                {
                     imgview.isHidden = false
                }
            }
            }else if indexPath.row == 1
            {
             cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
                let quesLbl = cell.viewWithTag(1) as! UILabel
                let ansLbl = cell.viewWithTag(2) as! UILabel
                 let imgview = cell.viewWithTag(-99) as! UIImageView
                imgview.isHidden = true
                quesLbl.text = "NUMBER OF STICKS A DAY ON AVERAGE?"
                
                if let x = (physicalDataDict.object(forKey: "smoked_1") as? String)
                {
                    ansLbl.text = x
                }
            }
           else if indexPath.row == 2
           {
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
            let quesLbl = cell.viewWithTag(1) as! UILabel
            let ansLbl = cell.viewWithTag(2) as! UILabel
            let imgview = cell.viewWithTag(-99) as! UIImageView
            imgview.isHidden = true
            quesLbl.text = "NUMBER OF YEARS OF SMOKING?"
            
            if let x = (physicalDataDict.object(forKey: "smoked_2") as? String)
            {
                ansLbl.text = x
            }
           }
           else if indexPath.row == 3
           {
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
            let quesLbl = cell.viewWithTag(1) as! UILabel
            let ansLbl = cell.viewWithTag(2) as! UILabel
            let imgview = cell.viewWithTag(-99) as! UIImageView
            imgview.isHidden = true
            quesLbl.text = "CURRENT OR EX-SMOKER?"
            if let x = (physicalDataDict.object(forKey: "smoked_3") as? String)
            {
                ansLbl.text = x
            }
           }
           else
           {
       
            cell = tableView.dequeueReusableCell(withIdentifier: "optionCell2")
            let quesLbl = cell.viewWithTag(1) as! UILabel
            let ansLbl = cell.viewWithTag(2) as! UILabel
            let imgview = cell.viewWithTag(-99) as! UIImageView
            imgview.isHidden = false
            quesLbl.text = "HOW LONG AGO DID YOU USED TOBACCO PROD?"
            if let x = (physicalDataDict.object(forKey: "smoked_4") as? String)
            {
                ansLbl.text = x
            }
            }
            
        }else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "generalCell")
                let quesLbl = cell.viewWithTag(1) as! UILabel
                let ansLbl = cell.viewWithTag(2) as! UILabel
                let imgview = cell.viewWithTag(-99) as! UIImageView
                quesLbl.text = "Do you consume alcohol?"
                //
                if let x = (physicalDataDict.object(forKey: "is_alcohol") as? String)
                {
                    ansLbl.text = x
                    if x.lowercased() == "yes"
                    {
                        imgview.isHidden = true
                    }else
                    {
                        imgview.isHidden = false
                    }
                }
            }else
            {
  
                cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
                let quesLbl = cell.viewWithTag(1) as! UILabel
                let ansLbl = cell.viewWithTag(2) as! UILabel
                let imgview = cell.viewWithTag(-99) as! UIImageView
                imgview.isHidden = false
                quesLbl.text = "NUMBER OF DRINKS A WEEK ON AVERAGE?"
                if let x = (physicalDataDict.object(forKey: "no_of_drinks") as? String)
                {
                    ansLbl.text = x
                }
            }
            
            
        }else if indexPath.section == 3
        {
             cell = tableView.dequeueReusableCell(withIdentifier: "generalCell")
            let quesLbl = cell.viewWithTag(1) as! UILabel
            let ansLbl = cell.viewWithTag(2) as! UILabel
            
            let imgview = cell.viewWithTag(-99) as! UIImageView
            imgview.isHidden = false
            quesLbl.text = "Do you exercise?"
            //
            if let x = (physicalDataDict.object(forKey: "is_exercise") as? String)
            {
                ansLbl.text = x
            }
        }else
        {
             cell = tableView.dequeueReusableCell(withIdentifier: "generalCell")
            let quesLbl = cell.viewWithTag(1) as! UILabel
            let ansLbl = cell.viewWithTag(2) as! UILabel
            
            let imgview = cell.viewWithTag(-99) as! UIImageView
            imgview.isHidden = false
            quesLbl.text = "Do you work?"
            //
            if let x = (physicalDataDict.object(forKey: "is_work") as? String)
            {
                ansLbl.text = x
            }
        }
        
        
        return cell
    }
    
    // MARK: - webservice
    func getUserData()
    {
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
                    self.physicalDataDict = (dataFromServer.object(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
