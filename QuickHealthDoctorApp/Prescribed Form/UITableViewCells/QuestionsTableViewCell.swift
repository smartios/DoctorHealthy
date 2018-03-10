//
//  QuestionsTableViewCell.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class QuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var thanksButton: UIButton!{
        didSet{
            thanksButton.layer.borderColor = UIColor.gray.cgColor
            thanksButton.layer.borderWidth = 1
            thanksButton.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var sureButton: UIButton!{
        didSet{
            sureButton.layer.cornerRadius = 3
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
    
}
