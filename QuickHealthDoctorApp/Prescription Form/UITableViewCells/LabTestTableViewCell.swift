//
//  LabTestTableViewCell.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 20/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class LabTestTableViewCell: UITableViewCell {

    var delegate: DrugPrescriptionActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Lab Test Name
    @IBAction func onClickedLabTestNameButton(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.Lab_Name, indexPath: indexPath)
        }
    }
    
}
