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
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userID: UILabel!
    @IBOutlet var appointmentDate: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var appointmentTime: UILabel!
    
    var userTrackData = TrackNurse(){
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

struct TrackNurse{
    var userImage:String!
    var userName:String!
    var userID:String!
    var appointmentDate:String!
    var address:String!
    var appointmentTime:String!
    var cordinates:CLLocationCoordinate2D!
    init(json:NSDictionary) {
        userImage = ""
        userName = "N/A"
        userID = "N/A"
        appointmentDate = "N/A"
        address = "N/A"
        appointmentTime = "N/A"
        cordinates = CLLocationCoordinate2D(latitude: 26.846694, longitude: 83.946166)

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
