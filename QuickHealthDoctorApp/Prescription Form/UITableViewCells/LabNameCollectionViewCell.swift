//
//  LabNameCollectionViewCell.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 21/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class LabNameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgImageView: UIImageView!{
        didSet{
            bgImageView.layer.borderWidth = 1.0
            bgImageView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    var delegate: DrugPrescriptionActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK:- Cross Action
    @IBAction func onClickedCrossLabName(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.Lab_Remove, indexPath: indexPath)
        }
    }
}
