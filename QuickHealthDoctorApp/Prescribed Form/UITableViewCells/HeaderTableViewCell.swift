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
            profileImagView.layer.borderWidth = 0
            profileImagView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var detailButton: UIButton!{
        didSet{
            detailButton.layer.borderWidth = 1
            detailButton.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.75).cgColor
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
