//
//  InboxView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 11/12/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class InboxView: BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var tableView: UITableView?
    var inboxDic = NSMutableDictionary()
    var inboxList:[NSDictionary] = []
    var pageNo = 0
    var totalCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        //////////for current location////////////////
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.inboxListing()
    }
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
        let patientImg = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        let message = cell.viewWithTag(3) as! UILabel
        let Patientdate = cell.viewWithTag(4) as! UILabel
        patientImg.layer.cornerRadius = patientImg.frame.width/2
        patientImg.clipsToBounds = true
        patientImg.layer.borderWidth = 1
        patientImg.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.clear
        
        if let profilePic = self.inboxList[indexPath.row].object(forKey: "sender_profile_image") as? String{
            patientImg.setImageWith(NSURL(string: profilePic)! as URL, placeholderImage: UIImage(named: "landing_image"))
        }else{
            patientImg.image = UIImage(named: "landing_image")
        }
        
        if let messagetext = self.inboxList[indexPath.row].object(forKey: "message") as? String{
            message.text = messagetext
        }else{
            message.text = "N/A"
        }
        
        if let senderFirstName = self.inboxList[indexPath.row].object(forKey: "sender_first_name") as? String{
            name.text = "\(senderFirstName) \(self.inboxList[indexPath.row].object(forKey: "sender_last_name") as! String)"
        }else{
            name.text = "N/A"
        }
        
        Patientdate.text = AppDateFormat.getDateStringFromDateString(date: (self.inboxList[indexPath.row].object(forKey: "added_on") as! String), fromDateString: "yyyy-MM-dd HH:mm:ss", toDateString: "dd MMM,yy hh:mm a")//(self.inboxList[indexPath.row].object(forKey: "added_on") as! String)
        if indexPath.row == self.inboxList.count - 1{
            if self.inboxList.count != self.totalCount{
                self.pageNo = self.pageNo + 1
                self.inboxListing()
            }
        }
        return cell
    }
    
    func navigateToLogin(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(self.inboxList[indexPath.row])
        if self.inboxList[indexPath.row].object(forKey: "notification_type") as! String == NotificationType.Appointment_Booking.rawValue{
            AppointmentNotification.newAppointmentBooking(self.inboxList[indexPath.row])
        }else if self.inboxList[indexPath.row].object(forKey: "notification_type") as! String == NotificationType.Nurse_Alloted.rawValue{
            AppointmentNotification.newAppointmentBooking(self.inboxList[indexPath.row])
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inboxList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    @IBAction func detailPatientBtnTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientDetailView") as! PatientDetailView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender )
    }
    
    //    MARK:- WebService Inbox Listing
    func inboxListing() {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "id_user" as NSCopying)
        dict.setObject(pageNo, forKey: "pagination" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.inbox_listing, dict, { (operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                    if self.pageNo == 0{
                        self.inboxList.removeAll()
                    }
                    for item in (dataFromServer).object(forKey: "data") as! NSArray{
                        self.inboxList.append(item as! NSDictionary)
                    }
                    if let x = (dataFromServer).object(forKey: "inbox_count") as? Int{
                         self.totalCount = x
                    }else if let x = (dataFromServer).object(forKey: "inbox_count") as? String{
                        self.totalCount = Int(x)!
                    }
                    self.tableView?.reloadData()
                }else{
                    if dataFromServer.object(forKey: "message") != nil{
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
