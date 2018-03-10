//
//  VideoConfrenceViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SL159 on 03/01/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class VideoConfrenceViewController: UIViewController {

    //MARK: -
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -
    //MARK: Private Variables
    var x = 4{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    //MARK: -
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        
        tableView.reloadData()
        
    }
    
    //MARK: -
    //MARK: Private Functions
    
    
    //MARK: -
    //MARK: Methods
    @IBAction func addMoreButton(_ sender: UIButton) {
        x += 4
    }
    
}

extension VideoConfrenceViewController: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: -
    //MARK: UITableView DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
                return 1
        }else if section == 1{
                return x
        }
        else if section == 2{
                return 1
        }
        else{
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        var label: UILabel?
        
        if indexPath.section == 0{
            
             cell = tableView.dequeueReusableCell(withIdentifier: "DiagnosisCell", for: indexPath)
            
            let textView = cell?.viewWithTag(2) as? UITextView
            textView?.delegate = self
            label = cell?.viewWithTag(1) as? UILabel
            
            if indexPath.row == 0{
            textView?.text = "The patient is currently suffering from"
            label?.text = "DIAGNOSIS"
            }
            else{
                textView?.text = ""
                label?.text = ""
            }
            
        }
        else if indexPath.section == 1{
            
            if (indexPath.row % 4) == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "RemarkCell", for: indexPath)
                let drugNamelabel = cell?.viewWithTag(1) as? UILabel
                drugNamelabel?.text = "DRUGNAME"
                
                let drugLabel = cell?.viewWithTag(2) as? UILabel
                drugLabel?.text = "Livomin-05-5000"
                
                let drugButton = cell?.viewWithTag(3) as? UIButton
                //drugButton?.setBackgroundImage()
               // drugButton?.setBackgroundImage(#imageLiteral(resourceName: "da"), for: .normal)
                drugButton?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                drugButton?.imageEdgeInsets = UIEdgeInsets(top: 2.0, left: -100.0, bottom: 2.0, right: 4)
                drugButton?.setImage(#imageLiteral(resourceName: "da"), for: UIControlState.normal)
                
            }
            
            if (indexPath.row % 4) == 1{
                
                cell = tableView.dequeueReusableCell(withIdentifier: "typeQtyCell", for: indexPath)
                
                let typeLabel = cell?.viewWithTag(1) as? UILabel
                typeLabel?.text = "TYPE"
                
                let typeSelectionLabel = cell?.viewWithTag(2) as? UILabel
                typeSelectionLabel?.text = "Capsule"
                
                let qtyLabel = cell?.viewWithTag(3) as? UILabel
                qtyLabel?.text = "QUANTITY"
                
                let qtySelectionLabel = cell?.viewWithTag(4) as? UILabel
                qtySelectionLabel?.text = "1"
                
                let typeSelectionBtn = cell?.viewWithTag(5) as? UIButton
                
                //let typeSelectionBtn = cell?.viewWithTag(5) as? UIButton
                typeSelectionBtn?.imageEdgeInsets = UIEdgeInsets(top: 2.0, left: 100, bottom: 2.0, right: 4)
                typeSelectionBtn?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                typeSelectionBtn?.setImage(#imageLiteral(resourceName: "da"), for: .normal)
            }
            
            if (indexPath.row % 4) == 2{
                
                cell = tableView.dequeueReusableCell(withIdentifier: "typeQtyCell", for: indexPath)
                
                let dosageLabel = cell?.viewWithTag(1) as? UILabel
                dosageLabel?.text = "DOSAGE"
                
                let dosageSelectionLabel = cell?.viewWithTag(2) as? UILabel
                dosageSelectionLabel?.text = "Twice a day"
                
                let bestTimeLabel = cell?.viewWithTag(3) as? UILabel
                bestTimeLabel?.text = "BEST TIME"
                
                let bestTimeSelectionLabel = cell?.viewWithTag(4) as? UILabel
                bestTimeSelectionLabel?.text = "After Meal"
                
            }
            
            if (indexPath.row % 4) == 3{
                
                cell = tableView.dequeueReusableCell(withIdentifier: "DiagnosisCell", for: indexPath)
                
                let label = cell?.viewWithTag(1) as? UILabel
                label?.text = "REMARK"
                
                let textView = cell?.viewWithTag(2) as? UITextView
                textView?.delegate = self
                textView?.text = "Excess of medicine could effect"
                
            }
        
        }
        else if indexPath.section == 2
        {
                cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell", for: indexPath)
        }
        
        else{
            
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "RemarkCell", for: indexPath)
                
                let label1 = cell?.viewWithTag(1) as? UILabel
                label1?.text = "LAB TEST NAME"
                
                let label = cell?.viewWithTag(2) as? UILabel
                label?.text = "Select Lab Test"
            }
            if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "selectOptionCell", for: indexPath)
            
                let collectionView = cell?.viewWithTag(1) as? UICollectionView
                collectionView?.delegate = self
                collectionView?.dataSource = self
            }
            
        
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell: UITableViewCell?
        
        if section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "headerTitleCell")
            
            let label = cell?.viewWithTag(1) as! UILabel
            label.text = ""
        }

        if section == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "headerTitleCell")
            
            cell?.backgroundColor = UIColor.white

            let label = cell?.viewWithTag(1) as! UILabel
            label.text = "PRESCRIBE DRUG"
        }
        if section == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "headerTitleCell")

            cell?.backgroundColor = UIColor.white
            
            let label = cell?.viewWithTag(1) as! UILabel
            label.text = ""
        }
        
        if section == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: "headerTitleCell")
            
            cell?.backgroundColor = UIColor.white
            
            let label = cell?.viewWithTag(1) as! UILabel
            label.text = "LAB TEST"
        }


        return cell!
    }
    
}

extension VideoConfrenceViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    //MARK: -
    //MARK: - CollectionView Delegate and DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectOption", for: indexPath)
        
        return cell
    }
    
}

extension VideoConfrenceViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let hardCodedPadding: CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2*hardCodedPadding)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

extension VideoConfrenceViewController: UITextViewDelegate{
    
    //MARK: -
    //MARK: UITextViewDelegate Methods

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        return true
    }
}


