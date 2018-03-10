//
//  PatientTableViewCell.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {
    
    @IBOutlet var UserImage: UIImageView!{
        didSet{
            UserImage.layer.cornerRadius = UserImage.frame.width/2
            UserImage.clipsToBounds = true
            UserImage.layer.borderWidth = 1
            UserImage.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet var UserName: UILabel!
    @IBOutlet var UserID: UILabel!
    @IBOutlet var AppointmentDate: UILabel!
    @IBOutlet var trackButton: UIButton!{
        didSet{
            trackButton.setTitle("TRACK", for: .normal)
            trackButton.layer.borderWidth = 1
            trackButton.layer.cornerRadius = 3.0
            trackButton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
        }
    }
    @IBOutlet var AppointmentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
