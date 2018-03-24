//
//  HeaderTableViewCell.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImagView: UIImageView!{
        didSet{
            profileImagView.layer.borderWidth = 1
            profileImagView.layer.borderColor = UIColor.gray.cgColor
            profileImagView.layer.cornerRadius = profileImagView.frame.size.width/2
            profileImagView.clipsToBounds = true
        }
    }
    @IBOutlet weak var detailButton: UIButton!{
        didSet{
            detailButton.layer.borderWidth = 1
            detailButton.layer.cornerRadius = 3.0
            detailButton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0).cgColor

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickedDetailButton(_ sender: UIButton) {
    }
    
}
