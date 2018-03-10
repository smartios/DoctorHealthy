//
//  UserProfileViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 28/11/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FloatRatingViewDelegate{
    
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var tableView: UITableView?
    var profileDictionary = NSMutableDictionary(){
        didSet{
            if let qualification = (self.profileDictionary.object(forKey: "data") as! NSDictionary).object(forKey: "qualification") as? NSArray{
                self.qualificationArray.addObjects(from: qualification as! [Any])
            }
            tableView?.reloadData()
        }
    }
    
    var userId :String = UserDefaults.standard.object(forKey: "user_id") as! String
    var qualificationArray:NSMutableArray = NSMutableArray()
    
    
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
        super.viewWillAppear(animated)
        
        userDetailWebService()
    
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float) {
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func userDetailWebService(){
        let dict = NSMutableDictionary()
        
        dict.setObject(userId, forKey: "user_id" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        apiSniper.getDataFromWebAPI(WebAPI.userProfile, dict, {(operation, responseObject) in
            print(responseObject)
            if let response = responseObject as? NSDictionary{
                supportingfuction.hideProgressHudInView(view: self)
                if (response.object(forKey: "error_code") != nil && "\(response.object(forKey: "error_code")!)" != "" && "\(response.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if response.object(forKey: "status") as! String == "success"{
                    self.profileDictionary = response.mutableCopy() as! NSMutableDictionary
                    
                }
                supportingfuction.showMessageHudWithMessage(message: response.object(forKey: "message") as! String as NSString, delay: 2.0)
            }
        },{(operation, error) in
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        })
    }
    
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
            let patientImg = cell.viewWithTag(1) as! UIImageView
            let patientName = cell.viewWithTag(2) as! UILabel
            let patientId = cell.viewWithTag(220) as! UILabel
            
            
            if let firstName = ((profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "first_name") as? String), let lastName = ((profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "last_name") as? String)
            {
                
                patientName.text = (firstName+" "+lastName)
            }
            

            if let id = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "unique_number") as? String{
                patientId.text =  (id != "") ?  id : "N/A"
            }
            
            if let image = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "user_image") as? String{
                patientImg.setImageWith(URL(string: image)!, placeholderImage: UIImage(named:"landing_image"))
            }else{
                patientImg.image = UIImage(named:"landing_image")
            }
            
            
            let nursetRating = cell?.viewWithTag(221) as! FloatRatingView
            nursetRating.isUserInteractionEnabled = false
            nursetRating.emptyImage = UIImage(named: "StarGrey")
            nursetRating.fullImage = UIImage(named: "StarOrange")
            // Optional params
            nursetRating.delegate = self
            nursetRating.contentMode = UIViewContentMode.scaleAspectFit
            nursetRating.maxRating = 5
            nursetRating.minRating = 0
            // floatRatingView.rating = 0
            nursetRating.editable = true
            nursetRating.halfRatings = false
            nursetRating.floatRatings = false
            
            if let rating = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "rating") as? String{
                nursetRating.rating = Float(rating)!
            }else{
                nursetRating.rating = 0.0
            }
            
            patientImg.layer.cornerRadius = patientImg.frame.width/2
            patientImg.clipsToBounds = true
            patientImg.layer.borderWidth = 1
            patientImg.layer.borderColor = UIColor.lightGray.cgColor
            cell.backgroundColor = UIColor.clear
        }else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "datailCell")
            let occupationLabel = cell.viewWithTag(10) as! UILabel
            let genderLabel = cell.viewWithTag(11) as! UILabel
            let dobLabel = cell.viewWithTag(12) as! UILabel
            let ageLabel = cell.viewWithTag(13) as! UILabel
    
            let maritalStatusLabel = cell.viewWithTag(15) as! UILabel
            let emailLabel = cell.viewWithTag(16) as! UILabel
            let mobileLabel = cell.viewWithTag(17) as! UILabel
            let language = cell.viewWithTag(14) as! UILabel
            // if let id = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "id_user") as? String{
            //   patientId.text = id
            // }
            
            if let occupation = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "occupation") as? String{
                occupationLabel.text = (occupation != "") ?  occupation : "N/A"
            }
            
            if let gender = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "gender") as? String{
                genderLabel.text = (gender != "") ?  gender : "N/A"
            }
            
            if let languagevalue = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "language") as? String{
                language.text = (languagevalue != "") ?  languagevalue : "N/A"
            }
            
            if let dob = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "dob") as? String{
                dobLabel.text = (dob != "") ?  dob : "N/A"
            }
            
            if let age = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "age") as? NSNumber{
                ageLabel.text = "\(age) yrs"
            }else{
                ageLabel.text = "N/A"
            }
            
            if let maritialStatus = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "maritualstatus") as? String{
                maritalStatusLabel.text = (maritialStatus != "") ?  maritialStatus : "N/A"
            }
            
            if let email = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "email") as? String{
                emailLabel.text = (email != "") ?  email : "N/A"
            }
            
            if let mobile = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "mobile") as? String, let mobile_ext = (profileDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "mobile_ext") as? String{
                let x = (mobile != "") ?  mobile : "N/A"
                mobileLabel.text = mobile_ext+" "+x
            }
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            
        }else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "qualification")
            let EducationTitle = cell.viewWithTag(1) as! UILabel
            let EducationInstitute = cell.viewWithTag(2) as! UILabel
            let EducationPassingYear = cell.viewWithTag(3) as! UILabel
            
            if let x = (self.qualificationArray.object(at: indexPath.row - 3) as! NSDictionary).object(forKey: "qualification_name") as? String{
                EducationTitle.text = (x != "") ?  x : "N/A"
            }else{
                EducationTitle.text = "N/A"
            }
            
            if let x = (self.qualificationArray.object(at: indexPath.row - 3) as! NSDictionary).object(forKey: "institute") as? String{
                EducationInstitute.text = (x != "") ?  x : "N/A"
            }else{
                EducationInstitute.text = "N/A"
            }
            
            if let x = (self.qualificationArray.object(at: indexPath.row - 3) as! NSDictionary).object(forKey: "passing_year") as? String{
                let year = (x != "") ?  x : "N/A"
                EducationPassingYear.text = "Year Of Passing, \(year)"
            }else{
                EducationPassingYear.text = "N/A"
            }
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 3 + self.qualificationArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return UITableViewAutomaticDimension
        }
        else if indexPath.row == 1
        {
            return 173
        }
        else if indexPath.row == 2
        {
            return 30
        }
        else
        {
            return UITableViewAutomaticDimension
            
        }
    }

    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
}
