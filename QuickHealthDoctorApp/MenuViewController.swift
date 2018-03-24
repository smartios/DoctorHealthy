//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    var gameTimer: Timer!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
        
        btnCloseMenuOverlay.backgroundColor = UIColor.clear
        gameTimer = Timer.scheduledTimer(timeInterval: 0.40, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        
        
    }
    
    // MARK: - runTimedCode
    func runTimedCode() {
               btnCloseMenuOverlay.backgroundColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.75)
    }
    // MARK: - updateArrayMenuOptions
    func updateArrayMenuOptions()
    {
        arrayMenuOptions.removeAll()
        arrayMenuOptions.append(["title":"ABOUT QUICKHEALTH", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"TERMS & CONDITIONS", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"PRIVACY POLICY", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"CONTACT US", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"FAQ", "icon":"PlayIcon"])
        tblMenuOptions.reloadData()
    }
    // MARK: - @IBAction updateArrayMenuOptions
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnCloseMenuOverlay.backgroundColor = UIColor.clear
        
        btnMenu.tag = 0
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    // MARK: - Table view delegate datasource methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 80
        }else
        {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0
        {
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "closeBtn")!
            return cell
        }
        else
        {
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = UIColor.clear
            let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
            let bgLabel  = cell.viewWithTag(102)
            lblTitle.text = arrayMenuOptions[indexPath.row-1]["title"]!
            let sepLabel : UILabel = cell.contentView.viewWithTag(1111) as! UILabel
            
            sepLabel.isHidden = false
            if (indexPath.row == 5)
            {
                sepLabel.isHidden = true
                
            }
            
            //            if ((indexPath.row == 1) || (indexPath.row == 3) || (indexPath.row == 5))
            //            {
            //                bgLabel?.backgroundColor = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
            //            }
            //            else if ((indexPath.row == 2) || (indexPath.row == 4))
            //            {
            //                bgLabel?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 247.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
            //            }
            return cell
        }
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count+1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
