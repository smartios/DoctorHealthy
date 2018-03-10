//(countryListArray.object(at: 0) as! NSDictionary)
//(lldb) po print(countryListArray.object(at: 0).object(forKey: "iso_code") as! String)
//  CountryCodeViewController.swift
//  QuickHealthdoctorApp
//
//  Created by SS043 on 07/02/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit

//Delegate
protocol countryList {
    func getCountryCode(code: String ,ID: String)
}


class CountryCodeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet var searchbar: UISearchBar!
    var searchActive : Bool = false
    
    
    var filtered:[String] = []
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var headingLabel: UILabel?
    var countryListArray = NSMutableArray()
    var delegate: countryList!
    var comminfromIndex = ""
    var searchcode: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        searchActive = false
        
        
        if from == "country"
        {
            searchBarHeight.constant = 44
             getUserData()
        }else
        {
            searchBarHeight.constant = 0

            listDropDown()
        }
        
       
      
 
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - backBtnTapped
    @IBAction func backBtnTapped(sender: UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - tabelView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            if(searchcode.count == 0)
            {
            }
            return searchcode.count
        }
        else
        {
            return countryListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        let countryName = cell.viewWithTag(1) as! UILabel
        let counrtyCode = cell.viewWithTag(2) as! UILabel
        
        if countryListArray.count > 0
        {
            if from == "country"
            {

                if(searchActive == false || searchbar.text == "" )
                {
                    countryName.text = ((countryListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "country_name")! as? String)?.uppercased()
                    counrtyCode.text = (countryListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "phone_country_code")! as? String
                }else
                {
                    countryName.text = ((searchcode.object(at: indexPath.row) as! NSDictionary) .object(forKey: "country_name")! as? String)?.uppercased()
                    counrtyCode.text = (searchcode.object(at: indexPath.row)as! NSDictionary).object(forKey: "phone_country_code")! as? String
                }
            }
            else
            {
                if countryListArray.count>0
                {
                    countryName.text = ((countryListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title")! as? String)
                    counrtyCode.text = ""
                }
            }
//            "id": "16",
//            "title"
        }
        
            
        
        return cell
    }
    
    @IBOutlet weak var heightForSearchBar: NSLayoutConstraint!
    // serch bar Activated
    
    // MARK: - searchBar
    
  
    
    func searchBar(_ searchBar:UISearchBar,textDidChange searchText:String)
    {
        searchcode.removeAllObjects()
       // let searchPredicate = NSPredicate(format: "country_name contains[c] %@",searchText)
        
        let searchPredicate = NSPredicate(format: " %K contains[cd] %@ OR %K CONTAINS[cd] %@","country_name",searchText,"phone_country_code",searchText)
        
        let tempSearchCategory : NSArray = self.countryListArray.filtered(using: searchPredicate) as NSArray
        searchcode.addObjects(from: tempSearchCategory as [AnyObject])
        if(searchcode.count == 0){
            if(searchText.isEmpty){
                searchActive = false;
            }
            else
            {
                searchActive = true;
            }
        } else {
            searchActive = true;
        }
        //  NSLog("filtered at e search  %d", searchcode.count)
        self.tableView?.reloadData()
        
    }
    
    // MARK: - searchBarTextDidBeginEditing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    // MARK: - searchBarTextDidEndEditing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        searchActive = true;
    }
    // MARK: - searchBarCancelButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        searchActive = false;
    }
    // MARK: - searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchbar.resignFirstResponder()
    }
    
    // MARK: - tableView Delegate methods
    
    //MARK:- Code staticContent Web Method
    func getUserData()
    {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
               
        let apiSniper = APISniper()
         apiSniper.getDataFromWebAPI(WebAPI.Get_country_code,dict, {(operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {

                self.countryListArray = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                supportingfuction.hideProgressHudInView(view: self)
                self.tableView?.reloadData()
            }
        }) { (operation, error) in
            // print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)        }
    }
    
    //for other dropdown
    //MARK:- Code staticContent Web Method
    func listDropDown()
    {
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        dict.setObject(from, forKey: "list_name" as NSCopying)
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.list,dict, {(operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                
                self.countryListArray = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                supportingfuction.hideProgressHudInView(view: self)
                self.tableView?.reloadData()
            }
        }) { (operation, error) in
            // print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)        }
    }

    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if from == "country"
        {
            
        if(searchActive == false || searchbar.text == "")
        {
            delegate.getCountryCode(code: ((countryListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "country_name")! as? String)!,ID: ((countryListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "phone_country_code")! as? String)!)
        }else
        {
            delegate.getCountryCode(code: ((searchcode.object(at: indexPath.row) as! NSDictionary).object(forKey: "country_name")! as? String)!,ID: ((searchcode.object(at: indexPath.row) as! NSDictionary).object(forKey: "phone_country_code")! as? String)!)
        }
        }else
        {
         delegate.getCountryCode(code: ((countryListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title")! as? String)!,ID: ((countryListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id")! as? String)!)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    
}
