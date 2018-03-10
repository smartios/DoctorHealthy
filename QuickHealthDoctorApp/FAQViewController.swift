

//
//  FAQViewController.swift
//  QuickHealthdoctorApp
//
//  Created by SS21 on 15/02/17.
//  Copyright © 2017 SS043. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var indexArr = NSMutableArray()
    var dataArray = NSMutableArray()
    var category = ""
    var search = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FAQViewController.popView), name: NSNotification.Name(rawValue: "popAllStaticPages"), object: nil)
        
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = true
        if(!appDelegate.hasConnectivity())
        {
           
    supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
        }
        else
        {
            getUserData()
        }
    }
    func popView()
    {
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexArr.contains(section)
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            
            let view = cell.viewWithTag(4)! as! UIImageView
            let plusBtn = cell.viewWithTag(5)! as! UIButton
            
            plusBtn.isUserInteractionEnabled = false
            
            if indexArr.contains(indexPath.section)
            {
                plusBtn.isSelected = true
            }
            else
            {
                plusBtn.isSelected = false
            }
            if indexPath.section == 0 {
                view.isHidden = false
            }
            else
            {
                view.isHidden = false
            }
            let label1 = cell.viewWithTag(2) as! UILabel
            label1.text = (dataArray.object(at: indexPath.section) as AnyObject).object(forKey: "question") as! String?
            label1.font = UIFont(name: "Ubuntu-Regular", size: 15)
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")
            let label = cell.viewWithTag(1) as! UILabel
            let htmlDocTypeMessg = (dataArray.object(at: indexPath.section) as AnyObject).object(forKey: "answer") as! String?
            //from(html:htmlDocTypeMessg!)
            let messg = htmlDocTypeMessg?.html2String
            label.text = messg
            label.font = UIFont(name: "Ubuntu-Regular", size: 15)
            label.setLineHeightfaq(1.00)
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    //let label : UILable! = String.stringFromHTML("html String")
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexArr.contains(indexPath.section)
        {
            indexArr.remove(indexPath.section)
        }
        else{
            indexArr.removeAllObjects()
            indexArr.add(indexPath.section)
        }
        tableView.reloadData()
    }
    
    ///textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if resultString.characters.count > 0
        {
            search = resultString
        }
        return true
    }
    
    @IBAction func searchBtn(_ sender: UIButton) {
        if(!appDelegate.hasConnectivity())
        {
            supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
        }
        else
        {
            getUserData()
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        //        self.view.endEditing(true)
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    @IBAction func selectBtn(_ sender: UIButton) {
//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
//        viewController.fromVC = "FAQSection"
//        viewController.delegate = self
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getUserData()
    {
       supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.FAQ_webMethod,dict, {(operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                 supportingfuction.hideProgressHudInView(view: self)
                
                print(dataFromServer)

                if dataFromServer.object(forKey: "status") as! String == "success"
                {
                    self.tableView.isHidden = false
                    self.dataArray.removeAllObjects()
                  
                    self.dataArray = ((dataFromServer.object(forKey: "data")as! NSArray).mutableCopy() as! NSMutableArray)

                    self.tableView.reloadData()
                }
            }
        }) { (operation, error) in
            //print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    

}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
          //  print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}



extension UILabel {
    func setLineHeightfaq(_ lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

