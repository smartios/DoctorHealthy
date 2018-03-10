//
//  PrescriptionFormViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 20/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

enum Actions {
    case D_Name
    case D_Type
    case D_Quantity
    case D_Dosage
    case D_Time
    case D_AddMore
    case Lab_Name
    case Lab_Remove
}
protocol DrugPrescriptionActionDelegate {
    func getActionForPrescription(_ action: Actions, indexPath: IndexPath)
}

protocol PrescriptionFormDelegate {
    func submitPrescriptionFormData()
}

class PrescriptionFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DrugPrescriptionActionDelegate {

    @IBOutlet weak var prescriptionFormTableView: UITableView!{
        didSet{
            prescriptionFormTableView.estimatedRowHeight = 80
            prescriptionFormTableView.rowHeight = UITableViewAutomaticDimension
            prescriptionFormTableView.register(UINib(nibName: "DiagnosisTableViewCell", bundle: nil), forCellReuseIdentifier: "diagnosisCell")
            prescriptionFormTableView.register(UINib(nibName: "PrescribeDrugTableViewCell", bundle: nil), forCellReuseIdentifier: "prescribeDrugCell")
            prescriptionFormTableView.register(UINib(nibName: "LabTestTableViewCell", bundle: nil), forCellReuseIdentifier: "labTestCell")
        }
    }
    
    @IBOutlet weak var submitButton: UIButton!
    let placeholder = "Please write here..."
    var textViewHeight : CGFloat! = 0
    let drugArray = NSMutableArray()
    let labNameArray = NSMutableArray()
    let prescriptionDictonary = NSMutableDictionary()
    var prescriptionData:Prescription = Prescription()
    var delegate:PrescriptionFormDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.prescriptionData.drug_array.count == 0{
            self.prescriptionData.drug_array.append(Drugs())
        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Keyboard Notification
    @objc func keyboardWillShow(_ notification: NSNotification)
    {
        if let userInfo = (notification as NSNotification).userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                prescriptionFormTableView.contentInset = contentInsets
                prescriptionFormTableView.scrollIndicatorInsets = contentInsets
                
                var rect = self.view.frame as CGRect
                rect.size.height -= keyboardSize.height
                // ...
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        prescriptionFormTableView.contentInset = contentInsets
        prescriptionFormTableView.scrollIndicatorInsets = contentInsets
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Submit Button Action
    @IBAction func onClickedSubmitButton(_ sender: UIButton) {
        self.delegate.submitPrescriptionFormData()
        self.view.endEditing(true)
        self.view.removeFromSuperview()
    }
    
    // MARK: - UITableView DataSource/Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return self.prescriptionData.drug_array.count
        }else{
           return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let label = UILabel()
        header.addSubview(label)
        label.frame = CGRect(x: 20, y: 0, width: header.bounds.width - 40, height: 50)
        if section == 1{
            label.text = "PRESCRIBE DRUG"
        }else{
            label.text = "LAB TEST"
        }
        header.backgroundColor = UIColor.white
        label.font = UIFont(name: "OpenSans-Bold", size: 15)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "diagnosisCell") as! DiagnosisTableViewCell
            self.cellForDiagnosisData(cell, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "prescribeDrugCell") as! PrescribeDrugTableViewCell
            cell.delegate = self
            self.cellForDrugData(cell, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "labTestCell") as! LabTestTableViewCell
            cell.delegate = self
            self.cellForLabTestName(cell, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }

    // MARK:- Diagnosis Cell
    func cellForDiagnosisData(_ cell: DiagnosisTableViewCell, indexPath: IndexPath)
    {
        let headingLabel = cell.viewWithTag(1) as! UILabel
        let contentTextView = cell.viewWithTag(2) as! UITextView
        contentTextView.delegate = self
        contentTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0)
        headingLabel.text = "DIAGNOSIS"
        contentTextView.text =  (prescriptionData.prescription != "") ?  prescriptionData.prescription : placeholder
        
    }
    
    // MARK:- Drug Cell
    func cellForDrugData(_ cell: PrescribeDrugTableViewCell, indexPath: IndexPath)
    {
        let drugNameHeading = cell.viewWithTag(12) as! UILabel
        let drugNameContent = cell.viewWithTag(13) as! UILabel
        
        drugNameHeading.text = "DRUG NAME"
        
        let drugTypeHeading = cell.viewWithTag(18) as! UILabel
        let drugTypeContent = cell.viewWithTag(19) as! UILabel
        
        drugTypeHeading.text = "TYPE"
        
        let drugQuantityHeading = cell.viewWithTag(23) as! UILabel
        let drugQuantityContent = cell.viewWithTag(24) as! UILabel
        
        drugQuantityHeading.text = "QUANTITY"
        
        let drugDosageHeading = cell.viewWithTag(29) as! UILabel
        let drugDosageContent = cell.viewWithTag(30) as! UILabel
        
        drugDosageHeading.text = "DOSAGE"
        
        let drugTimeHeading = cell.viewWithTag(34) as! UILabel
        let drugTimeContent = cell.viewWithTag(35) as! UILabel
        
        drugTimeHeading.text = "BEST TIME"
        
        let drugRemarkHeading = cell.viewWithTag(39) as! UILabel
        let drugRemarkTextView = cell.viewWithTag(40) as! UITextView
        drugRemarkTextView.delegate = self
        drugRemarkHeading.text = "REMARK"
        drugRemarkTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0)
        let addMoreButton = cell.viewWithTag(42) as! UIButton
        
        if let dict = self.prescriptionData.drug_array[indexPath.row] as? Drugs{
            drugNameContent.text = (dict.drug_name != "") ?  dict.drug_name : "N/A"
            
            drugTypeContent.text = (dict.type != "") ?  dict.type : "N/A"
            
            drugQuantityContent.text = (dict.quantity != "") ?  dict.quantity : "N/A"
            
            drugDosageContent.text = (dict.dosage != "") ?  dict.dosage : "N/A"
            
            drugTimeContent.text = (dict.best_time != "") ?  dict.best_time : "N/A"
            
            drugRemarkTextView.text = (dict.remarks != "") ?  dict.remarks : placeholder
        }
        if indexPath.row == self.prescriptionData.drug_array.count - 1{
            addMoreButton.setTitle("+Add More", for: .normal)
        }else{
            addMoreButton.setTitle("Remove", for: .normal)
        }
        
    }
    // MARK:- Lab test Cell
    func cellForLabTestName(_ cell: LabTestTableViewCell, indexPath: IndexPath)
    {
        let headingLabel = cell.viewWithTag(52) as! UILabel
        let contentLabel = cell.viewWithTag(53) as! UILabel
        let labTextNameCollectionView = cell.viewWithTag(56) as! UICollectionView
        labTextNameCollectionView.dataSource = self
        labTextNameCollectionView.delegate = self
        headingLabel.text = "LAB TEST NAME"
        contentLabel.text = "SELECT LAB TEST"
        labTextNameCollectionView.register(UINib(nibName: "LabNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "labNameCell")
        if self.prescriptionData.lab_test_array.count>0{
            for childConst in labTextNameCollectionView.constraints where childConst.identifier == "collectionHeight"{
                childConst.constant = CGFloat(ceilf(Float(self.prescriptionData.lab_test_array.count)/2.0) * 60)
            }
            labTextNameCollectionView.reloadData()
        }else{
            for childConst in labTextNameCollectionView.constraints where childConst.identifier == "collectionHeight"{
                childConst.constant = 0
            }
        }
    }
    
    // MARK:- UICollectionView DataSource/Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prescriptionData.lab_test_array.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 5, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labNameCell", for: indexPath) as! LabNameCollectionViewCell
        cell.delegate = self
        let labNameLabel = cell.viewWithTag(62) as! UILabel
        labNameLabel.text = (self.prescriptionData.lab_test_array[indexPath.item].test_name != "") ?  self.prescriptionData.lab_test_array[indexPath.item].test_name : "N/A"
        return cell
    }
    
    
    // MARK:- UITextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            return textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder{
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = placeholder
        }else{
            if textView.tag == 40{
                let contentView = textView.superview?.superview?.superview
                
                if let cell = contentView?.superview as? UITableViewCell, let hitIndex = prescriptionFormTableView.indexPath(for: cell){
                    if let _ = self.prescriptionData.drug_array[hitIndex.row] as? Drugs{
                        self.prescriptionData.drug_array[hitIndex.row].remarks = textView.text.trimmingCharacters(in: .whitespaces)
                    }
                }
            }else if textView.tag == 2{
                prescriptionDictonary.setObject(textView.text!, forKey: "diagnosis" as NSCopying)
                self.prescriptionData.prescription = textView.text!
            }
        }
        prescriptionFormTableView.reloadData()
    }
    func textViewDidChange(_ textView: UITextView) {
        let newHeight = textView.intrinsicContentSize.height
        if textViewHeight != newHeight{
            textViewHeight = newHeight
            UIView.setAnimationsEnabled(false)
            prescriptionFormTableView.beginUpdates()
            prescriptionFormTableView.endUpdates()
            prescriptionFormTableView.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        }
    }
    // MARK:- Prescription Action Delegate
    func getActionForPrescription(_ action: Actions, indexPath: IndexPath)
    {
        switch action {
        case .D_Name:
            let prescriptionVC = ListingViewController()
            prescriptionVC.list_type = "drug_list"
            prescriptionVC.delegate = self
            self.navigationController?.pushViewController(prescriptionVC, animated: true)

            break
        case .D_Type:

            break
        case .D_Quantity:
            let prescriptionVC = ListingViewController()
            prescriptionVC.list_type = "quantity"
            prescriptionVC.delegate = self
            self.navigationController?.pushViewController(prescriptionVC, animated: true)
            break
        case .D_Dosage:
            let prescriptionVC = ListingViewController()
            prescriptionVC.list_type = "dosage"
            prescriptionVC.delegate = self
            self.navigationController?.pushViewController(prescriptionVC, animated: true)
            break
        case .D_Time:
            let prescriptionVC = ListingViewController()
            prescriptionVC.list_type = "best_time"
            prescriptionVC.delegate = self
            self.navigationController?.pushViewController(prescriptionVC, animated: true)

            break
        case .D_AddMore:
            if indexPath.row != self.prescriptionData.drug_array.count - 1{
                self.prescriptionData.drug_array.remove(at: indexPath.row)
            }else{
                if self.validateDrugData(){
                    self.prescriptionData.drug_array.append(Drugs())
                }else{
                    return
                }
            }
            break
        case .Lab_Name:
            let prescriptionVC = ListingViewController()
            prescriptionVC.list_type = "lab_test"
            prescriptionVC.delegate = self
            let tempArray = NSMutableArray()
            for item in self.prescriptionData.lab_test_array{
                tempArray.add(PrescriptionMethods.getLabTestDictonary(data: item ))
            }
            prescriptionVC.selectedData = tempArray
            self.navigationController?.pushViewController(prescriptionVC, animated: true)
            break
        case .Lab_Remove:
            if self.prescriptionData.lab_test_array.count>indexPath.row{
                self.prescriptionData.lab_test_array.remove(at: indexPath.row)
            }
            
            break
        }
        prescriptionFormTableView.reloadData()
    }
    
    func validateDrugData()->Bool{
        if self.prescriptionData.drug_array.last?.drug_name == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select drug.", delay: 2.0)
            return false
        }else if self.prescriptionData.drug_array.last?.quantity == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select drug quantity.", delay: 2.0)
            return false
        }else if self.prescriptionData.drug_array.last?.dosage == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select drug doses.", delay: 2.0)
            return false
        }else if self.prescriptionData.drug_array.last?.best_time == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please select best time for taking drug.", delay: 2.0)
            return false
        }
        return true
    }
}

extension PrescriptionFormViewController:ListingViewDatasource{
    func getLabTestData(data: NSArray) {
        self.prescriptionData.lab_test_array.removeAll()
        for item in data{
            self.prescriptionData.lab_test_array.append(Labtest(json: item as! NSDictionary))
        }
        self.prescriptionFormTableView.reloadData()
    }
    
    func getDosagesData(data: NSDictionary) {
        self.prescriptionData.drug_array.last?.dosage = data.object(forKey: "title") as! String
        self.prescriptionFormTableView.reloadData()
    }
    
    func getQwantityData(data: String) {
        self.prescriptionData.drug_array.last?.quantity = data
        self.prescriptionFormTableView.reloadData()
    }
    
    func getDrugData(data: NSDictionary) {
        self.prescriptionData.drug_array.last?.drug_name = data.object(forKey: "drug_name") as! String
        self.prescriptionData.drug_array.last?.type = data.object(forKey: "drug_category") as! String
        self.prescriptionFormTableView.reloadData()
    }
    
    func getDrugBestTimeData(data: NSDictionary) {
        self.prescriptionData.drug_array.last?.best_time = data.object(forKey: "title") as! String
        self.prescriptionFormTableView.reloadData()
    }
}

extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}
extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
extension UICollectionViewCell {
    
    var collectionView: UICollectionView? {
        return next(UICollectionView.self)
    }
    
    var indexPath: IndexPath? {
        return collectionView?.indexPath(for: self)
    }
}
