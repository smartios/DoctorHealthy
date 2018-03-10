//
//  DoctorDocumentsViewTableViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 14/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class DoctorDocumentsViewController:  UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    var imageArray = NSMutableArray()
    
    var icloudArray = NSMutableArray()
    var typeSelection = false
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var tableView: UITableView?
    var idAppointMent:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.documentListing()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "RELATED PHOTOS"
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "photoCell")
            let collectionView = cell.viewWithTag(1) as!  UICollectionView
            collectionView.reloadData()
            collectionView.delegate = self;
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "RELATED DOCUMENTS"
        }
            
        else if indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "documentCell")
            let collectionView = cell.viewWithTag(2) as!  UICollectionView
            collectionView.reloadData()
            collectionView.delegate = self;
        }
        //cell.backgroundColor = UIColor.clear
        return cell
    }
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2{
            return 40
        }else if indexPath.row == 1{
            if self.imageArray.count > 0{
               return 170
            }
            return 10
        }else if indexPath.row == 3{
            if self.icloudArray.count > 0{
                return 140
            }
            return 10
        }else{
            return 80
        }
    }
    
    func transformedValue(_ value: Double) -> NSString {
        var convertedValue = Double(value)
        var multiplyFactor: Int = 0
        let tokens = ["bytes", "kb", "mb", "gb", "tb", "pb", "EB", "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return NSString.localizedStringWithFormat("%4.2f %@",convertedValue, tokens[multiplyFactor])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView.tag == 1{
            return imageArray.count
        }else{
            return icloudArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize{
        return CGSize(width: 96, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        var cell:UICollectionViewCell!
        if collectionView.tag == 1{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            let imageView = cell.viewWithTag(122) as! UIImageView
            
            let selectButton = cell.viewWithTag(124) as! UIButton
            let nameLabel = cell.viewWithTag(125) as! UILabel
            let sizeLabel = cell.viewWithTag(126) as! UILabel
            sizeLabel.isHidden = false
            nameLabel.isHidden = false
            imageView.isHidden = false
            selectButton.isHidden = true
            
            imageView.layer.cornerRadius = 3.0
            sizeLabel.text = self.transformedValue(Double((imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "file_size") as! Int)) as String//(icloudArray.object(at: indexPath.row) as! NSDictionary)?.object(forKey: "file_size") as! String
            let url = URL(string: (imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document") as! String)
            nameLabel.text = url?.lastPathComponent
            imageView.setImageWith(url!, placeholderImage: UIImage(named: "img"))

        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            let imageView = cell.viewWithTag(122) as! UIImageView
            
            let selectButton = cell.viewWithTag(124) as! UIButton
            let nameLabel = cell.viewWithTag(125) as! UILabel
            let sizeLabel = cell.viewWithTag(126) as! UILabel
            sizeLabel.isHidden = true
            nameLabel.isHidden = true
            selectButton.isHidden = true
            
            imageView.isHidden = true
            imageView.layer.cornerRadius = 3.0
            
            if indexPath.row < icloudArray.count{
                if (icloudArray.object(at: indexPath.row)) != nil{
                    
                    sizeLabel.isHidden = false
                    nameLabel.isHidden = false
                    imageView.isHidden = false
                    sizeLabel.text = self.transformedValue(Double((icloudArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "file_size") as! Int)) as String//(icloudArray.object(at: indexPath.row) as! NSDictionary)?.object(forKey: "file_size") as! String
                    let url = URL(string: (icloudArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document") as! String)!
                    nameLabel.text = url.lastPathComponent
                    if (icloudArray.count)>0{
                        imageView.image = UIImage(named: "pdf")
                    }
                }else{
                    selectButton.isHidden = false
                }
            }else{
                selectButton.isHidden = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 1{
            if imageArray.count>0 && ((imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document")as! String) != ""{
                
                let zoomImageViewC = ZoomImageViewController(nibName: "ZoomImageViewController", bundle: nil)
                let urlString = ((imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document") as! String).replacingOccurrences(of: " ", with: "%20")
                zoomImageViewC.imageArray = NSMutableArray(object: urlString)
                zoomImageViewC.view.frame = self.view.bounds
                self.view.addSubview(zoomImageViewC.view)
                self.addChildViewController(zoomImageViewC)
            }
        }else{
            if icloudArray.count>0 && ((icloudArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document")as! String) != ""{
                let vc = FilePreviewViewController(nibName: "FilePreviewViewController", bundle: nil)
                let urlString = ((icloudArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "document") as! String).replacingOccurrences(of: " ", with: "%20")
                vc.urlToLoad = URL(string:urlString)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Web Services
    func documentListing(){
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        
        dict.setObject(idAppointMent, forKey: "id_appointment" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        
        apiSniper.getDataFromWebAPI(WebAPI.view_nurse_uploads, dict, { (operation, responseObject) in
            
            if let dataFromServer = responseObject as? NSDictionary{
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                    self.sortData(data: dataFromServer.object(forKey: "data") as! NSArray)
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
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
    
    func sortData(data:NSArray){
        for item in data{
            if item is NSDictionary{
                if ((item as! NSDictionary).object(forKey: "type") as! String).lowercased() == "image"{
                    self.imageArray.add(item)
                }else{
                    self.icloudArray.add(item)
                }
            }
        }
        self.tableView?.reloadData()
    }
}

