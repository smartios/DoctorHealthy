//
//  PatientTrackListViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class PatientTrackListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!{
        didSet{
            self.tableView.estimatedRowHeight = 150
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.register(UINib(nibName: "PatientTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientTableViewCell")
        }
    }
    
    var patientList:[TrackPatient] = []
    var pageNo = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPatientList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tableview Datasource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientTableViewCell") as! PatientTableViewCell
        cell.UserName.text = self.patientList[indexPath.row].userName
        cell.AppointmentDate.text = self.patientList[indexPath.row].appointmentDate
        cell.AppointmentTime.text = self.patientList[indexPath.row].appointmentTime
        cell.UserID.text = self.patientList[indexPath.row].userID
        if self.patientList[indexPath.row].userImage != ""{
          cell.UserImage.setImageWith(URL(string: self.patientList[indexPath.row].userImage)!, placeholderImage: UIImage(named:"loginlogo"))
        }else{
            cell.UserImage.image = UIImage(named:"loginlogo")
        }
        cell.trackButton.addTarget(self, action: #selector(self.navigateToTrackView(_:)), for:.touchUpInside)
        return cell
    }

    //Navigate to track view contoller
    func navigateToTrackView(_ sender:UIButton){
        let hitPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hitPoint)
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = tabStoryboard.instantiateViewController(withIdentifier: "NurseTrackViewController") as! NurseTrackViewController
        vc.trackUserData = self.patientList[(indexPath?.row)!]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getPatientList(){
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Submitting...")
        let dict = NSMutableDictionary()
        dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "id_user" as NSCopying)
        dict.setObject("nurse", forKey: "user_type" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.track_user, dict, { (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary{
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                    self.setPatientList(data: dataFromServer.object(forKey: "data") as! NSArray)
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else{
                    if dataFromServer.object(forKey: "message") != nil{
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    }
                }
            }
        }){ (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    func setPatientList(data:NSArray){
        if self.pageNo == 0{
            self.patientList.removeAll()
        }
        for item in data{
            self.patientList.append(TrackPatient(json: item as! NSDictionary))
        }
        self.tableView.reloadData()
    }
}
