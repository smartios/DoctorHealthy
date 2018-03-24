//
//  PatientDetailView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 22/11/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class PatientDetailView: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,FloatRatingViewDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    var userInterface = UIDevice.current.userInterfaceIdiom
    var data = NSMutableDictionary()
    
    var resultView: UITextView?
    @IBOutlet weak var tableView: UITableView?
    var profileDictionary = NSMutableDictionary()
    var imgArray = NSMutableArray()
    var pdfArray = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        UIApplication.shared.statusBarView?.backgroundColor = .white
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"{
            self.appointmentListing()
        }
        print(data)
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "nurse"{
            self.appointmentListing()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float) {
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        if indexPath.section == 0{
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
                let patientImg = cell.viewWithTag(1) as! UIImageView
                
                let patientName = cell.viewWithTag(2) as! UILabel
                let patientId = cell.viewWithTag(3) as! UILabel
                let patientDate = cell.viewWithTag(4) as! UILabel
                let patientTime = cell.viewWithTag(5) as! UILabel
                let patientType = cell.viewWithTag(6) as! UILabel
                let patientDbutton = cell.viewWithTag(7) as! UIButton
                
                patientDbutton.layer.cornerRadius = 3.0
                
                
               
                
                if profileDictionary.count>0 && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "user_image") != nil && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "user_image") is NSNull == false && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "user_image") as! String != ""
                {
                    patientImg.setImageWith(NSURL(string:(self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "user_image") as! String) as! URL, placeholderImage:UIImage(named:"landing_image"))
                }
                else
                {
                    patientImg.image = UIImage(named:"landing_image")
                }
                
                
                if profileDictionary.count>0 && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "first_name") != nil && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "first_name") is NSNull == false && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "first_name") as! String != "" && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "last_name") != nil && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "last_name") is NSNull == false && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "last_name") as! String != ""
                {
                    let firstName = (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "first_name") as! String
                    let lastName = (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "last_name") as! String
                    patientName.text = firstName+" "+lastName
                }
                else
                {
                    patientName.text = ""
                }
                
                
                if profileDictionary.count>0 && (self.profileDictionary).object(forKey: "available_date") != nil && (self.profileDictionary).object(forKey: "available_date") is NSNull == false && (self.profileDictionary).object(forKey: "available_date") as! String != ""
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let date = formatter.date(from:  (self.profileDictionary).object(forKey: "available_date") as! String)
                    formatter.dateFormat = "dd MMM, yyyy"
                    
                    let convertDate = formatter.string(from: date!)
                    patientDate.text = convertDate
                }
                else
                {
                    patientDate.text = ""
                }
                
                
                
                
                
                
                if profileDictionary.count>0 && (self.profileDictionary).object(forKey: "start_time") != nil && (self.profileDictionary).object(forKey: "start_time") is NSNull == false && (self.profileDictionary).object(forKey: "start_time") as! String != ""{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    
                    let date = dateFormatter.date(from: (self.profileDictionary).object(forKey: "start_time") as! String)
                    dateFormatter.dateFormat = "hh:mm a"
                    let convertTime = dateFormatter.string(from: date!)
                    patientTime.text = convertTime
                }else{
                    patientTime.text = ""
                }
                
                
                if profileDictionary.count>0 && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "occupation") != nil && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "occupation") is NSNull == false && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "occupation") as! String != ""
                {
                    patientType.text = ((self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "occupation") as! String).uppercased()
                }
                else
                {
                    patientType.text = ""
                }
                
                //
                //
                
                if profileDictionary.count>0 && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "unique_number") != nil && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "unique_number") is NSNull == false && (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "unique_number") as! String != ""
                {
                    patientId.text = (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "unique_number") as? String
                }
                else
                {
                    patientId.text = ""
                }
                
                
                patientDbutton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
                patientDbutton.layer.borderWidth = 1
                
                patientImg.layer.cornerRadius = patientImg.frame.width/2
                
                patientImg.clipsToBounds = true
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "assignedUserCell")
                let nurseDbutton = cell.viewWithTag(11) as! UIButton
                let nurseImg = cell.viewWithTag(8) as! UIImageView
                let nurseName = cell.viewWithTag(9) as! UILabel
                let nursetId = cell.viewWithTag(10) as! UILabel
                
                nurseDbutton.layer.cornerRadius = 3.0
                
                let nursetRating = cell?.viewWithTag(12) as! FloatRatingView
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
                
                
                //Doctor/Nurse Data
                let assignedUserDetail:NSDictionary!
                
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "nurse" && self.profileDictionary.object(forKey: "doctor_detail") != nil{
                    assignedUserDetail = self.profileDictionary.object(forKey: "doctor_detail") as! NSDictionary
                    
                }else{
                    if self.profileDictionary.object(forKey: "nurse_detail") != nil &&  self.profileDictionary.object(forKey: "nurse_detail") is NSDictionary == true{
                        assignedUserDetail = self.profileDictionary.object(forKey: "nurse_detail") as! NSDictionary
                    }else{
                        assignedUserDetail = NSMutableDictionary()
                    }
                }
                
                //Set Nurse or Doctor Image
                if assignedUserDetail.object(forKey: "user_image") != nil && assignedUserDetail.object(forKey: "user_image") is NSNull == false && assignedUserDetail.object(forKey: "user_image") as! String != ""
                {
                    nurseImg.setImageWith(NSURL(string:assignedUserDetail.object(forKey: "user_image") as! String) as! URL, placeholderImage:UIImage(named:"landing_image"))
                }else{
                    nurseImg.image = UIImage(named:"landing_image")
                }
                
                //Set Nurse or Doctor name
                if assignedUserDetail.object(forKey: "first_name") != nil && assignedUserDetail.object(forKey: "first_name") is NSNull == false && assignedUserDetail.object(forKey: "first_name") as! String != "" && assignedUserDetail.object(forKey: "last_name") != nil && assignedUserDetail.object(forKey: "last_name") is NSNull == false && assignedUserDetail.object(forKey: "last_name") as! String != ""
                {
                    let firstName = assignedUserDetail.object(forKey: "first_name") as! String
                    let lastName = assignedUserDetail.object(forKey: "last_name") as! String
                    nurseName.text = firstName+" "+lastName
                }else{
                    nurseName.text = "N/A"
                }
                
                //Set Doctor or nurse ID
                if  assignedUserDetail.object(forKey: "unique_number") != nil && assignedUserDetail.object(forKey: "unique_number") is NSNull == false && assignedUserDetail.object(forKey: "unique_number") as! String != ""{
                    nursetId.text = assignedUserDetail.object(forKey: "unique_number") as? String
                }else{
                    nursetId.text = "N/A"
                }
                
                if  assignedUserDetail.object(forKey: "rating") != nil && assignedUserDetail.object(forKey: "rating") is NSNull == false && assignedUserDetail.object(forKey: "rating") as! String != ""{
                    nursetRating.rating = Float(assignedUserDetail.object(forKey: "rating") as! String)!
                }else{
                    nursetRating.rating = 0.0
                }
                
                
//                if profileDictionary.count>0 && profileDictionary.object(forKey: "doc_rating") != nil && profileDictionary.object(forKey: "rating") is NSNull == false && profileDictionary.object(forKey: "rating") as! String != ""
//                {
//                    nursetRating.rating = Float(profileDictionary.object(forKey: "doc_rating") as! String)!
//                }
//                else
//                {
//                    nursetRating.rating = 2.5
//                }
                nurseDbutton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
                nurseDbutton.layer.borderWidth = 1
                nurseImg.layer.cornerRadius = nurseImg.frame.width/2
                nurseImg.clipsToBounds = true
            }
        }else{
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
                
                let headerLabel = cell.viewWithTag(1) as? UILabel
                headerLabel?.text =  "PRESENT CONDITION "
                
                
            }else if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")
                
                let contentLabel = cell.viewWithTag(1) as? UILabel
                
                if profileDictionary.count>0
                {
                    contentLabel?.text = self.profileDictionary.object(forKey: "purpose") as! String
                }
                
                
            }else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
                
                let headerLabel = cell.viewWithTag(1) as? UILabel
                headerLabel?.text =  "RELATED PHOTOS"
                
            }else if indexPath.row == 3{
                cell = tableView.dequeueReusableCell(withIdentifier: "imgCell")
                let collectionView = cell.viewWithTag(1) as? UICollectionView
                collectionView?.delegate = self
                collectionView?.reloadData()
            }else if indexPath.row == 4{
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
                let headerLabel = cell.viewWithTag(1) as? UILabel
                headerLabel?.text =  "RELATED DOCUMENTS"
            }else if indexPath.row == 5{
                cell = tableView.dequeueReusableCell(withIdentifier: "pdfCell")
                let collectionView = cell.viewWithTag(2) as? UICollectionView
                collectionView?.delegate = self
                collectionView?.reloadData()
            }else  if indexPath.row == 6{
                cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")
                let Label = cell.viewWithTag(111) as! UILabel
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
                {
                    Label.text = "UPLOADED DOCUMENTS"
                }else{
                   Label.text = "UPLOAD DOCUMENTS"
                }
            }else  if indexPath.row == 7{
                cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")
                let Label = cell.viewWithTag(111) as! UILabel
                Label.text = "PHYSICAL STATS"
                
            }
            else  if indexPath.row == 8
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")
                let Label = cell.viewWithTag(111) as! UILabel
                Label.text = "MEDICATION"
                
            }
            else  if indexPath.row == 9
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")
                let Label = cell.viewWithTag(111) as! UILabel
                Label.text = "FAMILY HISTORY"
                
            }
        }
       //cell.backgroundColor = UIColor.clear
        return cell
        
    }
    
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0{
            if indexPath.row == 6
            {
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDocumentsViewController") as! DoctorDocumentsViewController
                    vc.idAppointMent = self.data.object(forKey: "appointment_id") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddDocumentsView") as! AddDocumentsView
                    vc.idAppointMent = self.data.object(forKey: "appointment_id") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if indexPath.row == 7{
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhysicalStatsViewController") as! PhysicalStatsViewController
                    vc.id_appointment = self.data.object(forKey: "appointment_id") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhysicalParameterViewController") as! PhysicalParameterViewController
                    vc.id_appointment = self.data.object(forKey: "appointment_id") as! String
                    vc.dataDict = self.data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if indexPath.row == 8{
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MedicalHistoryView") as! MedicalHistoryView
                    vc.appointmentID = self.data.object(forKey: "appointment_id") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "nurse" {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HealthRecordViewController") as! HealthRecordViewController
                    vc.id_appointment = self.data.object(forKey: "appointment_id") as! String
                    vc.dict = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if indexPath.row == 9{
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyHistoryViewController") as! FamilyHistoryViewController
                    vc.id_appointment = self.data.object(forKey: "appointment_id") as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyHistoryController") as! FamilyHistoryController
                    vc.historyData = data
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "nurse" && self.profileDictionary.object(forKey: "doctor_detail") != nil{
                return 2
            }else if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor" && self.profileDictionary.object(forKey: "nurse_detail") != nil &&  self.profileDictionary.object(forKey: "nurse_detail") is NSDictionary == true{
                return 2
            }
           return 1
        }
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.profileDictionary.count > 0{
          return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
           return UITableViewAutomaticDimension
        }else{
            if indexPath.row == 1
            {
                return UITableViewAutomaticDimension
                
            }
            else if indexPath.row == 3
            {
                if self.imgArray.count > 0{
                    return 115
                }
                return 10
            }
            else if indexPath.row == 5
            {
                if self.pdfArray.count > 0{
                    return 140
                }
                return 10
            }
            else if  indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4
            {
                return 40
                
            }
            else   if indexPath.row == 6  || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9
            {
                return 50
            }
            else
            {
                return 140
            }
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 1
        {
            
            return imgArray.count
            
        }else
        {
            return pdfArray.count
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 96, height: 126)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell:UICollectionViewCell!
        if collectionView.tag == 1
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            let imageView = cell.viewWithTag(122) as! UIImageView
            imageView.isHidden = false
            imageView.layer.cornerRadius = 3.0
            
            if imgArray.count>0 && ((imgArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url")as! String) != ""
            {
                let urlString = ((imgArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url") as! String).replacingOccurrences(of: " ", with: "%20")
                if URL(string: urlString) != nil {
                    imageView.setImageWith(URL(string: urlString)!, placeholderImage: UIImage(named: "img"))
                }else{
                   imageView.image =  UIImage(named: "img")
                }
            }
            return cell
        }
        else
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            let imageView = cell.viewWithTag(122) as! UIImageView
            let nameLabel = cell.viewWithTag(125) as! UILabel
            let sizeLabel = cell.viewWithTag(126) as! UILabel
            imageView.isHidden = false
            imageView.layer.cornerRadius = 3.0
            if pdfArray.count>0 && ((pdfArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url")as! String) != ""
            {
                sizeLabel.text = transformedValue(Double((pdfArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_size")as! NSNumber)) as String
                imageView.image = UIImage(named: "pdf")
                let nameArr = ((pdfArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url")as! String).components(separatedBy: "/")
                nameLabel.text = nameArr.last!
                
            }
            
            return cell
            
        }
    }
    
    
    func transformedValue(_ value: Double) -> NSString {
        var convertedValue = Double(value)
        var multiplyFactor: Int = 0
        let tokens = ["bytes", "kb", "mb", "gb", "tb", "pb", "EB", "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return NSString.localizedStringWithFormat("%4.2f %@",convertedValue, tokens[multiplyFactor])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 1{
            if imgArray.count>0 && ((imgArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url")as! String) != ""{
                
                let zoomImageViewC = ZoomImageViewController(nibName: "ZoomImageViewController", bundle: nil)
                let urlString = ((imgArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url") as! String).replacingOccurrences(of: " ", with: "%20")
                zoomImageViewC.imageArray = NSMutableArray(object: urlString)
                zoomImageViewC.view.frame = self.view.bounds
                self.view.addSubview(zoomImageViewC.view)
                self.addChildViewController(zoomImageViewC)
            }
        }else{
            if pdfArray.count>0 && ((pdfArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url")as! String) != ""{
                let vc = FilePreviewViewController(nibName: "FilePreviewViewController", bundle: nil)
                let urlString = ((pdfArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document_url") as! String).replacingOccurrences(of: " ", with: "%20")
                vc.urlToLoad = URL(string:urlString)
                self.present(vc, animated: true, completion: nil)
            }
        }
       
    }
    
    //MARK:- Buttons Action
    
    @IBAction func detailPatientBtnTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        vc.user_id = (self.profileDictionary.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "id_user") as! String
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func detailDoctorBtnTapped(_ sender: UIButton) {
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        let assignedUserDetail:NSDictionary!
        if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
        {
            assignedUserDetail = self.profileDictionary.object(forKey: "nurse_detail") as! NSDictionary
        }else{
            assignedUserDetail = self.profileDictionary.object(forKey: "doctor_detail") as! NSDictionary
        }
        vc.userId = assignedUserDetail.object(forKey: "id_user") as! String
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    //    MARK:- WebService Inbox Listing
    func appointmentListing() {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        
        dict.setObject(data.object(forKey: "appointment_id") as! String, forKey: "id_appointment" as NSCopying)
        
        if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"
        {
            dict.setObject("doctor", forKey: "account_type" as NSCopying)
        }else{
            dict.setObject("nurse", forKey: "account_type" as NSCopying)
        }
dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
         let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.appointment_detail, dict, { (operation, responseObject) in
            
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                    self.imgArray.removeAllObjects()
                    self.pdfArray.removeAllObjects()
                    
                    self.profileDictionary = ((dataFromServer).object(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary;
                    for i in 0..<(self.profileDictionary.object(forKey: "document") as! NSArray).count
                    {
                        if (((self.profileDictionary.object(forKey: "document") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "type")as! String) == "image"
                        {
                            self.imgArray.add(((self.profileDictionary.object(forKey: "document") as! NSArray).object(at: i) as! NSDictionary))
                        }else
                        {
                            self.pdfArray.add(((self.profileDictionary.object(forKey: "document") as! NSArray).object(at: i) as! NSDictionary))
                        }
                    }
                    
                    print(self.imgArray)
                    print(self.pdfArray)
                    
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
