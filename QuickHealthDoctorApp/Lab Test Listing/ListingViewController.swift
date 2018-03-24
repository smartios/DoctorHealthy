//
//  LabTestListingViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 21/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

protocol ListingViewDatasource{
    func getLabTestData(data:NSArray)
    func getDosagesData(data:NSDictionary)
    func getQwantityData(data:String)
    func getDaysData(data:String)
    func getDrugData(data:NSDictionary)
    func getDrugBestTimeData(data:NSDictionary)
    
}


class ListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var labTestTableView: UITableView!{
        didSet{
            labTestTableView.estimatedRowHeight = 80
            labTestTableView.rowHeight = UITableViewAutomaticDimension
            labTestTableView.register(UINib(nibName: "TestListingTableViewCell", bundle: nil), forCellReuseIdentifier: "labTestCell")
            labTestTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        }
    }
    @IBOutlet weak var headerTitle:UILabel!
    var dataArray = NSMutableArray()
    var delegate:ListingViewDatasource?
    var list_type = "lab_test"
    var selectedData:NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHeaderTitle()
        if self.list_type != "quantity" && self.list_type != "no_days" {
            self.labTestListing()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHeaderTitle(){
        if self.list_type == "lab_test"{
            headerTitle.text = "LAB TEST"
        }else if self.list_type == "drug_list" {
            headerTitle.text = "DRUGS"
        }else if self.list_type == "best_time" {
            headerTitle.text = "BEST TIME"
        }else if self.list_type == "quantity" {
            headerTitle.text = "DRUG QUANTITY"
        }else if self.list_type == "no_days" {
            headerTitle.text = "DAYS"
        }else  {
            headerTitle.text = "DOSAGES"
        }
    }
    
    // MARK:- Back Action
    @IBAction func onClickedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        if self.list_type == "lab_test"{
            self.delegate?.getLabTestData(data: self.selectedData)
        }else if self.list_type == "drug_list" {
            self.delegate?.getDrugData(data: self.selectedData.object(at: 0) as! NSDictionary)
        }else if self.list_type == "best_time" {
            self.delegate?.getDrugBestTimeData(data: self.selectedData.object(at: 0) as! NSDictionary)
        }else if self.list_type == "quantity" {
            self.delegate?.getQwantityData(data: self.selectedData.object(at: 0) as! String)
        }else if self.list_type == "no_days" {
            self.delegate?.getDaysData(data: self.selectedData.object(at: 0) as! String)
        }else  {
            self.delegate?.getDosagesData(data: self.selectedData.object(at: 0) as! NSDictionary)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- UITableView DataSource/Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.list_type == "quantity" || self.list_type == "no_days" {
            return 20
        }else{
           return self.dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.list_type == "lab_test"{
            return self.getLabtestTableViewCell(tableView: tableView, indexPath: indexPath)
        }else if self.list_type == "drug_list" {
            return self.getDruglistTableViewCell(tableView: tableView, indexPath: indexPath)
        }else if self.list_type == "best_time" {
            return self.getBestTimelistTableViewCell(tableView: tableView, indexPath: indexPath)
        }else if self.list_type == "quantity" || self.list_type == "no_days"{
            return self.getQuantitylistTableViewCell(tableView: tableView, indexPath: indexPath)
        }else  {
            return self.getDosagelistTableViewCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func getLabtestTableViewCell(tableView:UITableView,indexPath:IndexPath)->TestListingTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "labTestCell") as! TestListingTableViewCell
        let contentLabel = cell.viewWithTag(1) as! UILabel
        let contentSelectionButton = cell.viewWithTag(2) as! UIButton
        
        if self.selectedData.contains(self.dataArray.object(at: indexPath.row)){
            contentSelectionButton.isSelected = true
        }else{
            contentSelectionButton.isSelected = false
        }
//        if ((self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "isSelected") as! String).lowercased() == "yes"{
//            contentSelectionButton.isSelected = true
//        }else{
//            contentSelectionButton.isSelected = false
//        }
        contentLabel.text = ((self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String)
        cell.selectionStyle = .none
        return cell
    }
    
    func getDruglistTableViewCell(tableView:UITableView,indexPath:IndexPath)->ListTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
        let contentLabel = cell.viewWithTag(1) as! UILabel
        let contentSelectionButton = cell.viewWithTag(2) as! UIButton
        if self.selectedData.contains(self.dataArray.object(at: indexPath.row)){
            contentSelectionButton.isSelected = true
        }else{
            contentSelectionButton.isSelected = false
        }
        contentLabel.text = ((self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "drug_name") as! String)
        cell.selectionStyle = .none
        return cell
    }
    
    func getQuantitylistTableViewCell(tableView:UITableView,indexPath:IndexPath)->ListTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
        let contentLabel = cell.viewWithTag(1) as! UILabel
        let contentSelectionButton = cell.viewWithTag(2) as! UIButton
        if self.selectedData.contains("\(indexPath.row + 1)"){
            contentSelectionButton.isSelected = true
        }else{
            contentSelectionButton.isSelected = false
        }
        contentLabel.text = "\(indexPath.row + 1)"
        cell.selectionStyle = .none
        return cell
    }
    
    func getDosagelistTableViewCell(tableView:UITableView,indexPath:IndexPath)->ListTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
        let contentLabel = cell.viewWithTag(1) as! UILabel
        let contentSelectionButton = cell.viewWithTag(2) as! UIButton
        if self.selectedData.contains(self.dataArray.object(at: indexPath.row)){
            contentSelectionButton.isSelected = true
        }else{
            contentSelectionButton.isSelected = false
        }
        contentLabel.text = ((self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String)
        cell.selectionStyle = .none
        return cell
    }
    
    func getBestTimelistTableViewCell(tableView:UITableView,indexPath:IndexPath)->ListTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
        let contentLabel = cell.viewWithTag(1) as! UILabel
        let contentSelectionButton = cell.viewWithTag(2) as! UIButton
        if self.selectedData.contains(self.dataArray.object(at: indexPath.row)){
            contentSelectionButton.isSelected = true
        }else{
            contentSelectionButton.isSelected = false
        }
        contentLabel.text = ((self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.list_type == "lab_test"{
            if self.selectedData.contains(self.dataArray.object(at: indexPath.row)){
                self.selectedData.remove(self.dataArray.object(at: indexPath.row))
            }else{
                self.selectedData.add(self.dataArray.object(at: indexPath.row))
            }
        }else if self.list_type == "drug_list" {
            self.selectedData.removeAllObjects()
            self.selectedData.add(self.dataArray.object(at: indexPath.row))
        }else if self.list_type == "best_time" {
            self.selectedData.removeAllObjects()
            self.selectedData.add(self.dataArray.object(at: indexPath.row))
        }else if self.list_type == "quantity" || self.list_type == "no_days"{
            self.selectedData.removeAllObjects()
            self.selectedData.add("\(indexPath.row + 1)")
        }else  {
            self.selectedData.removeAllObjects()
            self.selectedData.add(self.dataArray.object(at: indexPath.row))
        }
        self.labTestTableView.reloadData()
    }

    //    MARK:- WebService Inbox Listing
    func labTestListing() {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject(list_type, forKey: "list_name" as NSCopying)
       dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.list, dict, { (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary{
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                    self.dataArray.addObjects(from: dataFromServer.object(forKey: "data") as! [Any])
                    self.labTestTableView.reloadData()
                }else{
                    if dataFromServer.object(forKey: "message") != nil{
                        supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                    }
                }
                
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
}
extension NSMutableArray{
    func addExtraObject(_ key : String, value : String){
        for index in 0..<self.count{
            let tempDict = NSMutableDictionary()
            tempDict.addEntries(from: self.object(at: index) as! NSDictionary as! [AnyHashable: Any])
            tempDict.setObject(value, forKey: key as NSCopying)
            self.replaceObject(at: index, with: tempDict)
        }
    }
}

