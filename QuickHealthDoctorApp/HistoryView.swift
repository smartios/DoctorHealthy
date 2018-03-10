//
//  HistoryView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 11/12/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class HistoryView: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var tableView: UITableView?
    var profileDictionary = NSMutableDictionary()
    var callStatus = ["ACCEPTED","REJECTED","ACCEPTED","ACCEPTED","REJECTED","ACCEPTED","REJECTED","ACCEPTED","REJECTED","REJECTED"]
    var historyList:[NSDictionary] = []
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        //////////for current location////////////////
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.historyListWebService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
        let patientImg = cell.viewWithTag(1) as! UIImageView
        let patientName = cell.viewWithTag(2) as! UILabel
        let patientId = cell.viewWithTag(3) as! UILabel
        let call_Date = cell.viewWithTag(4) as! UILabel
        let call_Time = cell.viewWithTag(5) as! UILabel
        let call_Status = cell.viewWithTag(6) as! UILabel
        let patientDbutton = cell.viewWithTag(7) as! UIButton
        
        
        patientImg.image = UIImage(named:"landing_image")
        patientDbutton.layer.cornerRadius = 3.0
        patientDbutton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
        patientDbutton.layer.borderWidth = 1
        patientImg.layer.cornerRadius = patientImg.frame.width/2
        patientImg.clipsToBounds = true
        patientImg.layer.borderWidth = 1
        patientImg.layer.borderColor = UIColor.lightGray.cgColor
        
        if let patient_img = self.historyList[indexPath.row].object(forKey: "patient_image") as? String{
            patientImg.setImageWith(URL(string: patient_img)!, placeholderImage: UIImage(named:"landing_image"))
        }else{
            patientImg.image = UIImage(named:"landing_image")
        }
        
        if let patient_Name = self.historyList[indexPath.row].object(forKey: "patient_name") as? String{
            patientName.text = patient_Name
        }else{
            patientName.text = "N/A"
        }
        
        if let patient_id = self.historyList[indexPath.row].object(forKey: "unique_number") as? String{
            patientId.text = patient_id
        }else{
            patientId.text = "N/A"
        }
        
        if let call_start = self.historyList[indexPath.row].object(forKey: "call_start") as? String,call_start != "0000-00-00 00:00:00"{
            call_Date.text = AppDateFormat.getDateStringFromDateString(date: call_start, fromDateString: "YYYY-MM-dd HH:mm:ss", toDateString: "dd MMM,YYYY")
            call_Time.text = AppDateFormat.getDateStringFromDateString(date: call_start, fromDateString: "YYYY-MM-dd HH:mm:ss", toDateString: "hh:mm a")
        }else{
            call_Date.text = "N/A"
            call_Time.text = "N/A"
        }
        
        if let status = self.historyList[indexPath.row].object(forKey: "call_status") as? String,status != ""{
            call_Status.text = status.uppercased()
            
        }else{
            call_Status.text = "N/A"
        }
        
        self.setCallStaus(status: call_Status.text!, label: call_Status)
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @IBAction func detailPatientBtnTapped(_ sender: UIButton) {
     
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setCallStaus(status:String,label:UILabel){
        switch status.lowercased() {
        case "accepted":
            label.textColor = UIColor.green
            break
        case "rejected":
            label.textColor = UIColor.red
            break
        case "cancelled":
            label.textColor = UIColor.black
            break
        case "complete":
            label.textColor = UIColor.blue
            break
        case "n/a":
            label.textColor = UIColor.darkGray
            break
        default:
            print(status)
        }
    }
    
    //History listing web service
    func historyListWebService(){
        if !appDelegate.hasConnectivity(){
            supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            return
        }
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id" as NSCopying)
        dict.setObject(((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased(), forKey: "account_type" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        apiSniper.getDataFromWebAPI(WebAPI.history, dict, {(operation, responseObject) in
            print(responseObject)
            if let response = responseObject as? NSDictionary{
                supportingfuction.hideProgressHudInView(view: self)
                if (response.object(forKey: "error_code") != nil && "\(response.object(forKey: "error_code")!)" != "" && "\(response.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if response.object(forKey: "status") as! String == "success"{
                    if self.page == 0{
                        self.historyList.removeAll()
                    }
                    self.historyList.append(contentsOf: response.object(forKey: "data") as! NSArray as! [NSDictionary])
                    self.tableView?.reloadData()
                }
            }
        },{(operation, error) in
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        })
    }
}
