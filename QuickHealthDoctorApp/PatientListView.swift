//
//  PatientListView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 24/11/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class PatientListView: BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var noRecordLbl: UILabel!
    var profileDictionary = NSMutableDictionary()
    var inboxDic = NSMutableDictionary()
    var todayAppointment = NSArray()
    var upcomingAppointment = NSArray()
    var appointmentId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        noRecordLbl.text = "No appointment(s) found."
        // Prevent the navigation bar from being hidden when searching.
        //////////for current location////////////////
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appointmentListing()
    }
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
        let patientImg = cell.viewWithTag(1) as! UIImageView
        let patientName = cell.viewWithTag(2) as! UILabel
        let patientId = cell.viewWithTag(3) as! UILabel
        let patientDate = cell.viewWithTag(4) as! UILabel
        let patientTime = cell.viewWithTag(5) as! UILabel
        let patientType = cell.viewWithTag(6) as! UILabel
        let patientDbutton = cell.viewWithTag(7) as! UIButton
        let callBtn = cell.viewWithTag(-217) as! UIButton
        patientDbutton.layer.cornerRadius = 3.0
        patientDbutton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
        patientDbutton.layer.borderWidth = 1
        callBtn.layer.cornerRadius = 3.0
        callBtn.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
        callBtn.layer.borderWidth = 1
        if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
        {
            callBtn.isHidden = false
        }else{
            callBtn.isHidden = true
        }
        
        patientImg.layer.cornerRadius = patientImg.frame.width/2
        patientImg.clipsToBounds = true
        patientImg.layer.borderWidth = 1
        patientImg.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.clear
        
        let appointmentDict:NSDictionary!
        if indexPath.section == 0{
            appointmentDict = todayAppointment.object(at: indexPath.row) as! NSDictionary
        }else{
            appointmentDict = upcomingAppointment.object(at: indexPath.row) as! NSDictionary
        }
        let x = ((appointmentDict.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "user_image") as! String)
        
        patientImg.setImageWith(NSURL(string: x)! as URL, placeholderImage: UIImage(named: "landing_image"))
        
        patientId.text = ((appointmentDict.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "unique_number") as! String)
        
        patientName.text = ((appointmentDict.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "first_name") as! String) + " " + ((appointmentDict.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "last_name") as! String)
        
        patientType.text = ((appointmentDict.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "occupation") as! String).uppercased()
        
        let time = (appointmentDict.object(forKey: "start_time") as! String)
        
        let datetime = (appointmentDict.object(forKey: "available_date") as! String)
        
        patientTime.text = AppDateFormat.getDateStringFromDateString2(date:time , fromDateString: "HH:mm:ss", toDateString: "hh:mm a")//time
        
        patientDate.text = AppDateFormat.getDateStringFromDateString2(date: datetime, fromDateString: "yyyy-MM-dd", toDateString: "dd MMM,yyyy")//datetime
        if appointmentDict.object(forKey: "enable_call") != nil && (appointmentDict.object(forKey: "enable_call") as! String).lowercased() == "true"{
            callBtn.isHidden = false
        }else{
            callBtn.isHidden = true
        }
        return cell
    }
    
    func navigateToLogin(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if self.todayAppointment.count > 0{
                
                return 35
            }
        }else{
            if self.upcomingAppointment.count > 0{
                return 35
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.todayAppointment.count
        }else{
            return self.upcomingAppointment.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.todayAppointment.count == 0 && self.upcomingAppointment.count == 0{
           return 0
        }
        return 2
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("AppointmentListHeader", owner: self, options: nil)?[0] as! UIView
        let headerLabel = headerView.viewWithTag(1) as! UILabel
        if section == 0{
            headerLabel.text =  "TODAY'S APPOINTMENT"
        }else{
            headerLabel.text =  "UPCOMING APPOINTMENT"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK:- Buttons Action
    
    
    @IBAction func callBtnClicked(_ sender: UIButton) {
        let hitPoint: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        
        let dictData = NSMutableDictionary()
        let appointmentDict:NSDictionary!
        if indexPath?.section == 0{
            appointmentDict = ((inboxDic.object(forKey: "todays_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary)
        }else{
            appointmentDict = ((inboxDic.object(forKey: "upcoming_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary)
        }
        dictData.setObject(appointmentDict.object(forKey: "id_doctor") as! String , forKey: "id_doctor" as NSCopying)
        
        dictData.setObject(appointmentDict.object(forKey: "id_patient") as! String , forKey: "id_patient" as NSCopying)
        
        dictData.setObject(appointmentDict.object(forKey: "id_appointment") as! String , forKey: "id_appointment" as NSCopying)
        
        dictData.setObject(appointmentDict.object(forKey: "id_nurse") as! String , forKey: "nurse_id" as NSCopying)
        
        dictData.setObject((appointmentDict.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "id_user") as! String , forKey: "user_id" as NSCopying)
        
        if  let patientDetail = appointmentDict.object(forKey: "patient_detail") as? NSDictionary{
            dictData.setObject("\(patientDetail.object(forKey: "first_name") as! String) \(patientDetail.object(forKey: "last_name") as! String)", forKey: "patient_name" as NSCopying)
            dictData.setObject(patientDetail.object(forKey: "unique_number") as! String, forKey: "patient_unique_number" as NSCopying)
            dictData.setObject(patientDetail.object(forKey: "user_image") as! String, forKey: "user_image" as NSCopying)
        }else{
            dictData.setObject("N/A", forKey: "patient_name" as NSCopying)
            dictData.setObject("N/A", forKey: "patient_unique_number" as NSCopying)
            dictData.setObject("N/A", forKey: "user_image" as NSCopying)
        }

        let vc = VideoCallViewController(nibName: "VideoCallViewController", bundle: nil)
        vc.apointmentDict = dictData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func detailPatientBtnTapped(_ sender: UIButton) {
        
        let hitPoint: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)!
        let dictData = NSMutableDictionary()
        var userId : String?
        var nurseId : String?
        
        if indexPath?.section == 0{
            appointmentId = (((inboxDic.object(forKey: "todays_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary).object(forKey: "id_appointment") as! String)
            
            userId = ((((inboxDic.object(forKey: "todays_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary).object(forKey: "patient_detail") as! NSDictionary).object(forKey: "id_user"))as! String
            
            nurseId = (((inboxDic.object(forKey: "todays_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary).object(forKey: "id_nurse") as! String)
            
           
        }
        else{
            appointmentId = (((inboxDic.object(forKey: "upcoming_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary).object(forKey: "id_appointment") as! String)
            
            userId = ((((inboxDic.object(forKey: "upcoming_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary).object(forKey: "patient_detail") as! NSDictionary).object(forKey: "id_user"))as! String
            
            nurseId = (((inboxDic.object(forKey: "upcoming_appointments") as! NSArray).object(at: (indexPath!.row)) as! NSDictionary).object(forKey: "id_nurse") as! String)
        }
        dictData.setObject(appointmentId, forKey: "appointment_id" as NSCopying)
        dictData.setObject(userId, forKey: "user_id" as NSCopying)
        dictData.setObject(nurseId, forKey: "nurse_id" as NSCopying)
        
//
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientDetailView") as! PatientDetailView
        vc.data = dictData
      self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender )
        
    }
    //    MARK:- WebService Inbox Listing
    func appointmentListing() {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "user_id" as NSCopying)
        if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
        {
            dict.setObject("doctor", forKey: "account_type" as NSCopying)
        }else{
            dict.setObject("nurse", forKey: "account_type" as NSCopying)
        }
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.appointment_list, dict, { (operation, responseObject) in
            
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    self.inboxDic = ((dataFromServer).object(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary;
                    self.assignData()
                    
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
    
    
    func assignData(){
        if self.inboxDic.object(forKey: "todays_appointments") != nil &&  inboxDic.object(forKey: "todays_appointments") is NSNull == false && (inboxDic.object(forKey: "todays_appointments") as! NSArray).count > 0
        {
            self.todayAppointment = (inboxDic.object(forKey: "todays_appointments") as! NSArray)
        }
        
        if self.inboxDic.object(forKey: "upcoming_appointments") != nil &&  inboxDic.object(forKey: "upcoming_appointments") is NSNull == false &&
            (inboxDic.object(forKey: "upcoming_appointments") as! NSArray).count > 0
            
        {
            self.upcomingAppointment = (inboxDic.object(forKey: "upcoming_appointments") as! NSArray)
        }
        
        //Show hide no record label
        if self.todayAppointment.count == 0 && self.upcomingAppointment.count == 0{
            self.noRecordLbl.isHidden = false
        }else{
            self.noRecordLbl.isHidden = true
        }
        
        self.tableView?.reloadData()
    }
    
}
