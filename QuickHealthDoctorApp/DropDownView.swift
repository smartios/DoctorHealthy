//
//  DropDownView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 11/12/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class DropDownView: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var saveButton: UIButton!
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var tableView: UITableView?
    var labtest = ["MRI","CT Scan","Ultrasound","Mammograpgh","BMD","X-Ray"]
    var selctionArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        saveButton.layer.cornerRadius =  5
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        //////////for current location////////////////
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
        let statusImage = cell.viewWithTag(1) as! UIImageView
        let labtest = cell.viewWithTag(2) as! UILabel
        labtest.text = self.labtest[indexPath.row]
        if selctionArray.count>0 && selctionArray.contains(self.labtest[indexPath.row])
        {
            statusImage.image = UIImage(named: "checked")
        }else
        {
            statusImage.image = UIImage(named: "uncheck")
 
        }
      
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selctionArray.contains(self.labtest[indexPath.row])
        {
            selctionArray.remove(self.labtest[indexPath.row])
        }
        else
        {
            selctionArray.add(self.labtest[indexPath.row])
        }
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
   
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
     _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
}
