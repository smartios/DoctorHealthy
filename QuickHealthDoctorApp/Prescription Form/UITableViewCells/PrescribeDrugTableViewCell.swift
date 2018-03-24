//
//  PrescribeDrugTableViewCell.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 20/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class PrescribeDrugTableViewCell: UITableViewCell {

    var delegate: DrugPrescriptionActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Drug Name
    @IBAction func onClickedDrugNameButton(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.D_Name, indexPath: indexPath)
        }
        
    }
    // MARK:- Drug Type
    @IBAction func onClickedDrugTypeButton(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.D_Type, indexPath: indexPath)
        }
    }
    // MARK:- Drug Quantity
    @IBAction func onClickedDrugQuantityButton(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.D_Quantity, indexPath: indexPath)
        }
    }
    // MARK:- Drug Dosage
    @IBAction func onClickedDrugDosageButton(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.D_Dosage, indexPath: indexPath)
        }
    }
    // MARK:- Drug Best Time
    @IBAction func onClickedDrugTimingButton(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.D_Time, indexPath: indexPath)
        }
    }
    // MARK:- Add More
    @IBAction func onClickedDrugAddMoreButton(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.D_AddMore, indexPath: indexPath)
        }
    }
    
    @IBAction func onClickedNumberOfDays(_ sender: UIButton) {
        if let indexPath = self.indexPath{
            delegate?.getActionForPrescription(.D_Days, indexPath: indexPath)
        }
    }
    
}
