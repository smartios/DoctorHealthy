//
//  TrackNurseView.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 23/01/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import CoreLocation

class TrackNurseView: UIView {
    
    @IBOutlet var userImage: UIImageView!{
        didSet{
            userImage.layer.cornerRadius = userImage.frame.width/2
            userImage.clipsToBounds = true
            userImage.layer.borderWidth = 1
            userImage.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet var userName: UILabel!
    @IBOutlet var userID: UILabel!
    @IBOutlet var appointmentDate: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var appointmentTime: UILabel!
    @IBOutlet var detailButton: UIButton!{
        didSet{
            detailButton.setTitle("Detail", for: .normal)
            detailButton.layer.borderWidth = 1
            detailButton.layer.cornerRadius = 3.0
            detailButton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
        }
    }
    
    var userTrackData = TrackPatient(){
        didSet{
            self.refreshData()
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func refreshData(){
        if userTrackData.userImage != ""{
            self.userImage.setImageWith(URL(string: userTrackData.userImage)!, placeholderImage: UIImage(named:""))
        }
        self.address.text = userTrackData.address
        self.appointmentDate.text = userTrackData.appointmentDate
        self.appointmentTime.text = userTrackData.appointmentTime
        self.userName.text = userTrackData.userName
        self.userID.text = userTrackData.userID
    }
    
    @IBAction func detailBtnClicked(_ sender: UIButton) {
    }
    
}

struct TrackPatient{
    var userImage:String!
    var userName:String!
    var userID:String!
    var appointmentDate:String!
    var address:String!
    var appointmentTime:String!
    var cordinates:CLLocationCoordinate2D!
    init(json:NSDictionary) {
        userImage = (json.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "user_image") as! String
        userName = "\((json.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "first_name") as! String) \((json.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "last_name") as! String)"
        userID = (json.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "unique_number") as! String
        appointmentDate = AppDateFormat.getDateStringFromDateString(date: json.object(forKey: "available_date") as! String, fromDateString: "yyyy-MM-dd", toDateString: "dd MMM, yyyy")
        
        address = "N/A"
        
        appointmentTime = AppDateFormat.getDateStringFromDateString(date: json.object(forKey: "start_time") as! String, fromDateString: "HH:mm:ss", toDateString: "hh:mm a")
        var latitude:Double = 0.0
        var longitude:Double = 0.0
        if let patient_location = (json.object(forKey: "patient_detail") as! NSDictionary).object(forKey: "patient_location") as? NSDictionary,patient_location.count>0{
            if let lat = patient_location.object(forKey: "latitude") as? String{
                latitude = Double(lat) != nil ? Double(lat)! : 0.0
            }
            if let long = patient_location.object(forKey: "longitude") as? String{
                longitude = Double(long) != nil ? Double(long)! : 0.0
            }
            address = patient_location.object(forKey: "address") as! String
        }
        cordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

    }
    init() {
        userImage = ""
        userName = "N/A"
        userID = "N/A"
        appointmentDate = "N/A"
        address = "N/A"
        appointmentTime = "N/A"
        cordinates = CLLocationCoordinate2D(latitude: 26.846694, longitude: 83.946166)
    }
}
