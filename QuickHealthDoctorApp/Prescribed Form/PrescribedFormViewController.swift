//
//  PrescribedFormViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class PrescribedFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var prescribedTableView: UITableView!{
        didSet{
            prescribedTableView.estimatedRowHeight = 80
            prescribedTableView.rowHeight = UITableViewAutomaticDimension
            
            prescribedTableView.estimatedSectionHeaderHeight = 50
            prescribedTableView.sectionHeaderHeight = UITableViewAutomaticDimension
            prescribedTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "headerCell")
            prescribedTableView.register(UINib(nibName: "PrescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "prescriptionDescriptionCell")
            prescribedTableView.register(UINib(nibName: "PrescribedDrugTableViewCell", bundle: nil), forCellReuseIdentifier: "prescribedCell")
            prescribedTableView.register(UINib(nibName: "TotalAmountTableViewCell", bundle: nil), forCellReuseIdentifier: "totalAmountCell")
            prescribedTableView.register(UINib(nibName: "PrescribedLabTestTableViewCell", bundle: nil), forCellReuseIdentifier: "labTestCell")
            prescribedTableView.register(UINib(nibName: "QuestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Back Action
    @IBAction func onClickedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK:- Proceed to Payment
    @IBAction func onClickedMakePayment(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK:- UITableView DataSource/Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 2
        }else if section == 3{
            return 2
        }else if section == 4{
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeader = TableViewHeader()
        let tableHeaderContent = tableHeader.viewWithTag(191) as! UILabel
        if section == 0{
            tableHeaderContent.text = ""
        }else if section == 1{
            tableHeaderContent.text = "PRESCRIPTION"
        }else if section == 2{
            tableHeaderContent.text = "PRESCRIBED DRUGS"
        }else if section == 3{
            tableHeaderContent.text = "LAB TEST"
        }else if section == 4{
            tableHeaderContent.text = ""
        }
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else if section == 1 || section == 2 || section == 3{
            return UITableViewAutomaticDimension
        }else if section == 4{
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
            return self.cellForHeaderContent(cell, indexPath: indexPath)
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "prescriptionDescriptionCell") as! PrescriptionTableViewCell
            return self.cellForPrescriptionDescription(cell, indexPath: indexPath)
        }else if indexPath.section == 2{
            if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionsTableViewCell
                return self.cellForQuestionAsking(cell, indexPath: indexPath)
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "prescribedCell") as! PrescribedDrugTableViewCell
                return self.cellForPrescribedDrugs(cell, indexPath: indexPath)
            }
        }else if indexPath.section == 3{
            if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionsTableViewCell
                return self.cellForQuestionAsking(cell, indexPath: indexPath)
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "labTestCell") as! PrescribedLabTestTableViewCell
                return self.cellLabTestName(cell, indexPath: indexPath)
            }
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalAmountCell") as! TotalAmountTableViewCell
            return self.cellForTotalAmount(cell, indexPath: indexPath)
        }
    }

    // MARK:- Header Cell
    func cellForHeaderContent(_ cell: HeaderTableViewCell, indexPath: IndexPath) -> UITableViewCell{
        let nameLabel = cell.viewWithTag(104) as! UILabel
        let iDLabel = cell.viewWithTag(105) as! UILabel
        let dateLabel = cell.viewWithTag(108) as! UILabel
        let timeLabel = cell.viewWithTag(110) as! UILabel
        let specializationLabel = cell.viewWithTag(111) as! UILabel
        nameLabel.text = "Jacob Francis"
        dateLabel.text = "27 Jul, 2018"
        timeLabel.text = "11:24 AM"
        iDLabel.text = "ID-123-47822773"
        specializationLabel.text = "GENERAL PHYSICIAN"
        cell.selectionStyle = .none
        return cell
    }
    // MARK:- Prescription Detail cell
    func cellForPrescriptionDescription(_ cell: PrescriptionTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let descriptionLabel = cell.viewWithTag(151) as! UILabel
        descriptionLabel.text = "JHGHJ GFHJSGDFSHJGF SAJGHJG FJSGJFHS GHJ gdhjeh rktehkjter khtekj"
        cell.selectionStyle = .none
        return cell
    }
    // MARK:- Prescribed drugs
    func cellForPrescribedDrugs(_ cell: PrescribedDrugTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let drugNameLabel = cell.viewWithTag(122) as! UILabel
        let drugPriceLabel = cell.viewWithTag(123) as! UILabel
        let drugQuantityLabel = cell.viewWithTag(125) as! UILabel
        let drugTimeLabel = cell.viewWithTag(127) as! UILabel
        let drugDosageLabel = cell.viewWithTag(129) as! UILabel
        let remarkLabel = cell.viewWithTag(130) as! UILabel
        drugNameLabel.text = "Panadol-0Z-500mg"
        drugPriceLabel.text = "$62"
        drugQuantityLabel.text = "4 Tablets"
        drugTimeLabel.text = "After Meal"
        drugDosageLabel.text = "thrice a day"
        if indexPath.row == 0{
            remarkLabel.text = ""
        }else{
            remarkLabel.text = "jhdfgs jdfgshgf jsgfjhs fghjsf s"
        }
        cell.selectionStyle = .none
        return cell
    }
    // MARK:- Question Cell
    func cellForQuestionAsking(_ cell: QuestionsTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let questionLabel = cell.viewWithTag(162) as! UILabel
        if indexPath.section == 2{
            questionLabel.text = "DO YOU WANT US TO ARRABGE THE MEDICNINE"
        }else{
            questionLabel.text = "DO YOU WANT US TO ARRABGE THE LAB TEST"
        }
        cell.selectionStyle = .none
        return cell
    }
    // MARK:- Lab test name cell
    func cellLabTestName(_ cell: PrescribedLabTestTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let labTestNameLabel = cell.viewWithTag(172) as! UILabel
        let labTestPriceLabel = cell.viewWithTag(173) as! UILabel
        labTestNameLabel.text = "Ultrasound"
        labTestPriceLabel.text = "$24"
        cell.selectionStyle = .none
        return cell
    }
    // MARK:- Total Amount Cell
    func cellForTotalAmount(_ cell: TotalAmountTableViewCell, indexPath: IndexPath) -> UITableViewCell
    {
        let labTestNameLabel = cell.viewWithTag(182) as! UILabel
        let labTestPriceLabel = cell.viewWithTag(183) as! UILabel
        labTestNameLabel.text = "TOTAL"
        labTestPriceLabel.text = "$232"
        cell.selectionStyle = .none
        return cell
    }
}
