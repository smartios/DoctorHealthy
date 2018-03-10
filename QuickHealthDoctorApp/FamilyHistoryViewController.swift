//
//  FamilyHistoryViewController.swift
//  QuickHealthPatient
//
//  Created by mac  on 15/01/18.
//  Copyright © 2018 SL161. All rights reserved.
//

import UIKit

class FamilyHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
     var historyDict = NSArray()
        var historyData = NSDictionary()
    
    var id_appointment = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 150
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        familyHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - uitableview dlegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "diseases_name") as! String).lowercased() == "other"{
            return UITableViewAutomaticDimension
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
       
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let lbl1 = cell.viewWithTag(1) as! UILabel
            let lbl2 = cell.viewWithTag(2) as! UILabel
        
        if ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "diseases_name") as! String).lowercased() == "other"{
            
            lbl1.text = ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "other_description") as! String)
        }else{
            lbl1.text = ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "diseases_name") as! String)
        }
        lbl2.text = ((historyDict.object(at: indexPath.row) as! NSDictionary).object(forKey: "to_whom") as! String)
            
        return cell
    }

    
    @IBAction func backBtnTapper(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
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
        dict.setObject(id_appointment, forKey: "id_appointment" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.view_family_history, dict, { (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    self.historyDict = ((dataFromServer).object(forKey: "data") as! NSArray).mutableCopy() as! NSArray;
                    
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

}
