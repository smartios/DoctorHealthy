//
//  AddDocumentsView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 12/12/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit

class AddDocumentsView: UIViewController,UITableViewDataSource,UITableViewDelegate,UIDocumentPickerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate{
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
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            let button = cell.viewWithTag(999) as! UIButton
            button.layer.cornerRadius = 5.0
        }
        //cell.backgroundColor = UIColor.clear
        return cell
    }
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2{
            return 40
        }else if indexPath.row == 1{
            return 170
        }else if indexPath.row == 3{
            return 140
        }else{
            return 80
        }
    }
    
    @IBAction func imageUploadBtnClicked(_ sender: Any) {
        if imageArray.count < 5{
            typeSelection = true
            let myActionSheet : UIActionSheet  = UIActionSheet()
            myActionSheet.addButton(withTitle: "Use Gallery")
            myActionSheet.addButton(withTitle: "Use Camera")
            myActionSheet.addButton(withTitle: "Use iCloud")
            myActionSheet.addButton(withTitle: "Cancel")
            myActionSheet.delegate=self
            myActionSheet.show(in: self.view)
        }else{
            supportingfuction.showMessageHudWithMessage(message: "You can't upload more than 5 Image.", delay: 2.0)
        }
    }
    
    @IBAction func uploadDocumentTapped(sender: UIButton){
        if icloudArray.count < 5{
            typeSelection = false
            let myActionSheet : UIActionSheet  = UIActionSheet()
            myActionSheet.addButton(withTitle: "Use iCloud")
            myActionSheet.addButton(withTitle: "Cancel")
            myActionSheet.delegate=self
            myActionSheet.show(in: self.view)
        }else{
            supportingfuction.showMessageHudWithMessage(message: "You can't upload more than 5 files.", delay: 2.0)
        }
    }
    
    //MARK:- iCLOUD DELEGATE
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == .import{
            print(url)
            if let fileData = NSData(contentsOf: url){
                if fileData.length>5000000{
                    let alertController = UIAlertController(title: "Error!", message:"File size greater than 5MB.Please select another file.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    let myString = String(describing: url)
                    let dict = NSMutableDictionary()
                    dict.setObject("url", forKey: "type" as NSCopying)
                    dict.setObject(url, forKey: "image_url" as NSCopying)
                    dict.setObject(fileData, forKey: "img_data" as NSCopying)
                    dict.setObject(transformedValue(Double(fileData.length)), forKey: "file_size" as NSCopying)
                    let myStringArr = myString.components(separatedBy: ".")
                    dict.setObject(myStringArr.last!, forKey: "file_type" as NSCopying)
                    let nameArr = myString.components(separatedBy: "/")
                    dict.setObject(nameArr.last!, forKey: "file_name" as NSCopying)
                    if typeSelection == false{
                        if myStringArr.last! == "pdf"{
                            icloudArray.add(dict)
                        }else{
                            supportingfuction.showMessageHudWithMessage(message: "Please upload only PDF.", delay: 2.0)
                        }
                    }else{
                        if myStringArr.last! != "pdf" && myStringArr.last! != "odt"{
                            imageArray.add(dict)
                        }else{
                            supportingfuction.showMessageHudWithMessage(message: "Please upload only Images.", delay: 2.0)
                        }
                    }
                    self.uploadPDFFilesToClass(fileData, fileName: url.lastPathComponent.components(separatedBy: ".").first!)
                    self.tableView?.reloadData()
                }
            }
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
    
    func uploadPDFFilesToClass(_ fileContent: NSData, fileName: String)
    {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 1
        {
            return imageArray.count+1
        }
        else
        {
            return icloudArray.count+1
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 96, height: 126)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell:UICollectionViewCell!
        
        if collectionView.tag == 1
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            let imageView = cell.viewWithTag(122) as! UIImageView
            let delButton = cell.viewWithTag(123) as! UIButton
            let selectButton = cell.viewWithTag(124) as! UIButton
            
            
            selectButton.isHidden = true
            delButton.isHidden = true
            imageView.isHidden = true
            imageView.layer.cornerRadius = 3.0
            
            if indexPath.row < imageArray.count
            {
                
                if (imageArray.object(at: indexPath.row)) != nil
                {
                    delButton.isHidden = false
                    imageView.isHidden = false
                    
                    if  ( (imageArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "type") as! String) == "url"
                    {
                        imageView.setImageWith((imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image_url") as! URL, placeholderImage: UIImage(named: "img"))
                    }
                    else
                    {
                        imageView.image = (imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image_url") as! UIImage?
                    }
                    
                }else
                {
                    selectButton.isHidden = false
                }
            }
            else
            {
                selectButton.isHidden = false
            }
            
        }else
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            let imageView = cell.viewWithTag(122) as! UIImageView
            let delButton = cell.viewWithTag(123) as! UIButton
            let selectButton = cell.viewWithTag(124) as! UIButton
            let nameLabel = cell.viewWithTag(125) as! UILabel
            let sizeLabel = cell.viewWithTag(126) as! UILabel
            sizeLabel.isHidden = true
            nameLabel.isHidden = true
            selectButton.isHidden = true
            delButton.isHidden = true
            imageView.isHidden = true
            imageView.layer.cornerRadius = 3.0
            
            if indexPath.row < icloudArray.count
            {
                
                if (icloudArray.object(at: indexPath.row)) != nil
                {
                    delButton.isHidden = false
                    sizeLabel.isHidden = false
                    nameLabel.isHidden = false
                    imageView.isHidden = false
                    sizeLabel.text = (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_size") as? String
                    nameLabel.text = (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_name") as? String
                    
                    if (icloudArray.count)>0
                    {
                        imageView.image = UIImage(named: "pdf")
                    }
                }else
                {
                    selectButton.isHidden = false
                    
                    
                }
                
                
            }
            else
            {
                selectButton.isHidden = false
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 1{
            let zoomImageViewC = ZoomImageViewController(nibName: "ZoomImageViewController", bundle: nil)
            if imageArray.count>0 && ( (imageArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "type") as! String) == "url"
            {
                let url = (imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image_url") as! URL
                
                zoomImageViewC.imageArray = NSMutableArray(object: url.absoluteString)
                
            }else{
                zoomImageViewC.imageArray = NSMutableArray(object: UIImagePNGRepresentation(((imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image_url") as! UIImage?)!)!)
                
            }
            zoomImageViewC.view.frame = self.view.bounds
            self.view.addSubview(zoomImageViewC.view)
            self.addChildViewController(zoomImageViewC)
        }else{
            if icloudArray.count>0 && ((icloudArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "type")as! String) == "url"{
                let vc = FilePreviewViewController(nibName: "FilePreviewViewController", bundle: nil)
                let url = (imageArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image_url") as! URL
                vc.urlToLoad = URL(string:url.absoluteString)
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelImageBtnClicked(_ sender: Any) {
        let hit = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
        let hitIndex3 = tableView?.indexPathForRow(at: hit)
        let cell = self.tableView!.cellForRow(at: hitIndex3!)
        let collection = cell!.viewWithTag(1) as! UICollectionView
        let hitPoint = (sender as AnyObject).convert(CGPoint.zero, to: collection)
        let hitIndex = collection.indexPathForItem(at: hitPoint)
        imageArray.removeObject(at: (((hitIndex?.row)))!)
        tableView?.reloadData()
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        let hit = sender.convert(CGPoint.zero, to: tableView)
        let hitIndex3 = tableView?.indexPathForRow(at: hit)
        let cell = self.tableView!.cellForRow(at: hitIndex3!)
        let collection = cell!.viewWithTag(2) as! UICollectionView
        let hitPoint = sender.convert(CGPoint.zero, to: collection)
        let hitIndex = collection.indexPathForItem(at: hitPoint)
        icloudArray.removeObject(at: (((hitIndex?.row)))!)
        tableView?.reloadData()
    }
    
    
    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        print(buttonIndex)
        if typeSelection == true
        {
            switch(buttonIndex)
            {
            case 0:
                let  Picker = UIImagePickerController()
                Picker.delegate = self
                Picker.allowsEditing = false
                Picker.sourceType = .photoLibrary
                self.present(Picker, animated: true, completion: nil)
                break
            case 1:
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
                {
                    let Picker = UIImagePickerController()
                    Picker.delegate = self
                    Picker.allowsEditing = false
                    Picker.sourceType = UIImagePickerControllerSourceType.camera
                    present(Picker, animated: true, completion: nil)
                }
                break
            case 2:
                if icloudArray.count<5
                {
                    let documnerPickerVC = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
                    documnerPickerVC.delegate = self
                    documnerPickerVC.modalPresentationStyle = .formSheet
                    self.present(documnerPickerVC, animated: true, completion: nil)
                }
                break
            default:break
            }
        }else{
            switch(buttonIndex)
            {
                
            case 0:
                
                let documnerPickerVC = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
                documnerPickerVC.delegate = self
                documnerPickerVC.modalPresentationStyle = .formSheet
                self.present(documnerPickerVC, animated: true, completion: nil)
                break
                default:break
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = UIImage.scaleAndRotateImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!) {
            
            let dict = NSMutableDictionary()
            dict.setObject("image", forKey: "type" as NSCopying)
            dict.setObject(pickedImage, forKey: "image_url" as NSCopying)
            dict.setObject((UIImageJPEGRepresentation(pickedImage, 0.6)! as NSData), forKey: "img_data" as NSCopying)
            imageArray.add(dict)
            tableView?.reloadData()
        }
        picker.dismiss(animated: true) { () -> Void in
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
       // MARK:- Web Services
    
    @IBAction func documentsSubmitBtn(_ sender: UIButton) {

        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject(idAppointMent, forKey: "id_appointment" as NSCopying)
        dict.setObject(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "id_nurse" as NSCopying)

        let apiSniper = APISniper()
        
        apiSniper.uploadDocuments(WebAPI.upload_document, dict, icloudArray, imageArray: imageArray, completeBlock: { (operation, responseObject) in
            
            
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                //status
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"
                {
                  self.navigationController?.popViewController(animated: true)
                    
                }else
                {
                    if dataFromServer.object(forKey: "message") != nil
                    {
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
                let dict =  NSMutableDictionary()
                let urlString = ((item as! NSDictionary).object(forKey: "document") as! String).replacingOccurrences(of: " ", with: "%20")
                let url = URL(string: urlString)!
                dict.setObject("url", forKey: "type" as NSCopying)
                dict.setObject(url, forKey: "image_url" as NSCopying)
                //                    dict.setObject(fileData, forKey: "img_data" as NSCopying)
                dict.setObject(((item as! NSDictionary).object(forKey: "file_size") as! Int), forKey: "file_size" as NSCopying)
                
                let myStringArr = url.lastPathComponent.components(separatedBy: ".")
                dict.setObject(myStringArr.last!, forKey: "file_type" as NSCopying)
                dict.setObject(url.lastPathComponent, forKey: "file_name" as NSCopying)
                if ((item as! NSDictionary).object(forKey: "type") as! String).lowercased() == "image"{
                    self.imageArray.add(dict)
                }else{
                    self.icloudArray.add(dict)
                }
            }
        }
        self.tableView?.reloadData()
    }
    
}
