//
//  BookedAvailbilityView.swift
//  QuickHealthdoctorApp
//
//  Created by SS142 on 23/03/17.
//
//

import UIKit
import Foundation

protocol BookedAvailbilityViewDelegate
{
    func changeValue(name: String)
}

class BookedAvailbilityView: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selcetAll: UIButton!
    var  minute = ["00-20\n(Minutes)","20-40\n(Minutes)","40-60\n(Minutes)"]
    
    var timeDic = NSMutableDictionary()
    var minuteArray = NSArray()
    var hoursArray = NSArray()
    var type = ""
    var selectedIndexPath = NSMutableArray()
    var scheduleValue = 0
    var delegate: BookedAvailbilityViewDelegate?
    var scheduleArray = ["EARLY MORNING","MORNING","AFTERNOON","EVENING"]
    var selectedDate = String()
    var userInterface = UIDevice.current.userInterfaceIdiom
    var bookSlot = NSMutableArray()
    var deleteSlot = NSMutableArray()
    
    //New Variables
    var slotArrayForDisplay = NSMutableDictionary()
    var availableSlots = NSMutableArray()
    var showDate = ""
    var selectType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let formatter = DateFormatter()
        let currentDate = NSDate()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: selectedDate)
        
        formatter.dateFormat = "dd MMM, yyyy"
        let cD  = formatter.string(from: currentDate as Date)
        let cD2  = formatter.string(from: date! as Date)
        
        showDate = cD2
        
        if cD2 == cD
        {
            let hour = Calendar.current.component(.hour, from: Date())
            
            if hour >= 6 && hour < 12 {
                print("Good Morning")
                scheduleValue = 0
            } else if hour >= 12 && hour < 16 {
                scheduleValue = 1
                print("Good Afternoon")
            } else if hour >= 16 && hour < 24 {
                scheduleValue = 2
                print("Good Evening")
            }
            else
            {
                scheduleValue = 3
                print("Good EARLY MORNING")
            }
        }
        let reach: Reachability
        do{
            reach = try Reachability.forInternetConnection()
            if reach.isReachable(){
                self.slotArrayForDisplay.removeAllObjects()
                getUserData()
            }else
            {
                supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            }
        }
        catch{
            
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func createAttributedString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor) -> NSMutableAttributedString{
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: fullStringColor, range: NSRange(location: 0, length: fullString.characters.count))

        attributedString.addAttribute(NSForegroundColorAttributeName, value: subStringColor, range: range)
        return attributedString
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func updateBookingButton(_ sender: UIButton) {
        
        let reach: Reachability
        do{
            reach = try Reachability.forInternetConnection()
            if reach.isReachable(){
                self.setBookAndRemoveSlot()
            }else{
                supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            }
        }catch{
            
        }
    }
    
    @IBAction func changeScheduleButtonClicked(_ sender: UIButton) {
        if sender.tag == 1{
            if scheduleValue < 3{
                scheduleValue = scheduleValue+1
            }
        }else{
            if scheduleValue > 0{
                scheduleValue = scheduleValue-1
            }
        }
        if self.scheduleValue == 0{
            //MORNING
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "early_morning")   as! NSArray)
        }else  if self.scheduleValue == 1{
            //AFTERNOON
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "morning")   as! NSArray)
        }else  if self.scheduleValue == 2{
            //EVENING
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "noon")   as! NSArray)
        }else{
            //EARLY MORNING
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "evening")   as! NSArray)
        }
        tableView.reloadData()
    }
    
    
    @IBAction func selectAllButtonPressed(sender:UIButton){
        var checkedStatus = "false"
        if sender.isSelected == false
        {
            sender.isSelected = true
            checkedStatus = "true"
        }else{
            checkedStatus = "false"
            sender.isSelected = false
        }
        
        if self.scheduleValue == 0{
            //MORNING
            self.slotArrayForDisplay.setObject(self.setCheckedStatusOnSlots(dayIntervalArray: self.slotArrayForDisplay.object(forKey: "early_morning") as! NSArray, value: checkedStatus), forKey: "early_morning" as NSCopying)
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "early_morning")   as! NSArray)
        }else  if self.scheduleValue == 1{
            //AFTERNOON
            self.slotArrayForDisplay.setObject(self.setCheckedStatusOnSlots(dayIntervalArray: self.slotArrayForDisplay.object(forKey: "morning") as! NSArray, value: checkedStatus), forKey: "morning" as NSCopying)
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "morning")   as! NSArray)
            
        }else  if self.scheduleValue == 2{
            //EVENING
            self.slotArrayForDisplay.setObject(self.setCheckedStatusOnSlots(dayIntervalArray: self.slotArrayForDisplay.object(forKey: "noon") as! NSArray, value: checkedStatus), forKey: "noon" as NSCopying)
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "noon")   as! NSArray)
        }else{
            //EARLY MORNING
            self.slotArrayForDisplay.setObject(self.setCheckedStatusOnSlots(dayIntervalArray: self.slotArrayForDisplay.object(forKey: "evening") as! NSArray, value: checkedStatus), forKey: "evening" as NSCopying)
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "evening")   as! NSArray)
        }
        tableView.reloadData()
    }
    
    //Function to set select all button selected or unselected
    func checkIfAllSelected(dayIntervalArray:NSArray){
        var selectedSlots = 0
        var slotsCount = 0
        var isBooked = false
        for item in dayIntervalArray{
            for data in (item as! NSArray){
                if (data as! NSDictionary).object(forKey: "checked") as! String == "true"{
                    selectedSlots = selectedSlots + 1
                }else if (data as! NSDictionary).object(forKey: "checked") as! String == "booked"{
                    isBooked = true
                    break
                }
                slotsCount = slotsCount + 1
            }
        }
        if isBooked{
            self.selcetAll.isSelected = false
            self.selcetAll.isHidden =  true
            return
        }
        self.selcetAll.isHidden =  false
        if selectedSlots == slotsCount{
            self.selcetAll.isSelected = true
        }else{
            self.selcetAll.isSelected = false
        }
    }
    
    //MARk:- Set checked status on click of select all button and retun array
    func setCheckedStatusOnSlots(dayIntervalArray:NSArray,value:String)->NSMutableArray{
        let dayIntervalMutableArray = dayIntervalArray.mutableCopy() as! NSMutableArray
        for j in 0..<dayIntervalArray.count{
            let tempArray = (dayIntervalArray.object(at: j) as! NSArray).mutableCopy()  as! NSMutableArray
            for i in 0..<tempArray.count{
                let tempDict = (tempArray.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if tempDict.object(forKey: "checked") as! String != "booked"{
                    tempDict.setObject(value, forKey: "checked" as NSCopying)
                }
                tempArray.replaceObject(at: i, with: tempDict)
            }
            dayIntervalMutableArray.replaceObject(at: j, with: tempArray)
        }
        return dayIntervalMutableArray
    }
    
    
    //MARK: TableView Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell!
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            let dateLabel = cell?.viewWithTag(131)! as! UILabel
            dateLabel.text = showDate
        }
        else  if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell")
            let calendarHeader = cell.viewWithTag(5)! as UIView
            let collectionView = cell.viewWithTag(3) as! UICollectionView
            let scheduleTitle = cell?.viewWithTag(21) as! UILabel
            collectionView.isScrollEnabled = false
            let leftBtn = cell?.viewWithTag(2)! as! UIButton
            let rightBtn = cell?.viewWithTag(1)! as! UIButton
            leftBtn.isHidden = false
            rightBtn.isHidden = false
            collectionView.reloadData()
            calendarHeader.layer.borderColor = UIColor(red: 137.0/255, green: 217.0/255, blue: 210.0/255, alpha: 1.0).cgColor
            
            if selectedDate != ""{
                scheduleTitle.text =    (scheduleArray[scheduleValue]).uppercased()
            }else{
                scheduleTitle.text =    ("MULTIPLE DATES " + ",  " + scheduleArray[scheduleValue]).uppercased()
            }
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            let bckbtn = cell?.viewWithTag(555) as! UIButton
            bckbtn.layer.cornerRadius = 3.0
            self.checkIfAllSelected(dayIntervalArray: self.hoursArray)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 64
        }else  if indexPath.row == 1{
            var height:CGFloat = 0
            if(userInterface == .pad){
                if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
                    print("portrait")
                    height = CGFloat(90 * ( 7 + 1) + 61 + 1)
                }else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
                    
                    height = CGFloat(110 * ( 7 + 1) + 61 + 1)
                }else{
                    height = CGFloat(90 * ( 7 + 1) + 61 + 1)
                }
                //iPad
            }else {
                //iPhone
                height = CGFloat((((UIScreen.main.bounds.size.width - 56)/4)-25) * 8)
            }
            return height
        }else{
            return 115
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator:
        UIViewControllerTransitionCoordinator) {
        
        if (size.width / size.height > 1) {
            print("landscape")
            tableView.reloadData()
        } else {
            print("portrait")
            tableView.reloadData()
        }
    }
    
    //MARK:-   Collection view delegate and datasources
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // your code here
        if(userInterface == .pad){
            
            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
                print("portrait")
                return CGSize(width: 80, height:80)
            }else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
                return CGSize(width: 100, height:100)
            }else{
                return CGSize(width: 80, height:80)
            }
            //iPad
        }else {
            //iPhone
            let width = (UIScreen.main.bounds.size.width - 56)/4
            return CGSize(width: width, height: width - 35)
          }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if hoursArray.count > 0{
            return 7
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var cell:UICollectionViewCell!
        if  indexPath.section == 0{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
            let label = cell.viewWithTag(2) as! UILabel
            
            if indexPath.row == 0{
                label.text = "Hours"
                label.textColor = UIColor.lightGray
            }else{
                let fullNameArr = minute[indexPath.row-1].components(separatedBy: "\n")
                let lastName: String = fullNameArr[1]
                let str = createAttributedString(fullString: minute[indexPath.row-1], fullStringColor: UIColor.black, subString: lastName, subStringColor: UIColor.lightGray)
                label.attributedText = str
             }
         }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            
            imageView.image = UIImage(named: "")
            let label = cell.viewWithTag(2) as! UILabel
            
            label.textColor = UIColor.black
            if indexPath.row == 0{
                
                if hoursArray.count>0{
                    var str = (((hoursArray.object(at: indexPath.section-1) as! NSArray).object(at: 0)as! NSDictionary).object(forKey: "name") as! String).components(separatedBy: ":")
                    if str.count>0{
                        label.text = String(str[0])
                    }else{
                        label.text = ""
                    }
                }
                imageView.backgroundColor = UIColor.white
                imageView.layer.borderWidth = 0
                imageView.layer.borderWidth = 0
            }else{
                label.text = ""
                imageView.layer.borderWidth = 1.0
                imageView.layer.borderColor = UIColor(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0).cgColor
                
                if ((hoursArray.object(at: indexPath.section-1) as! NSArray).object(at: indexPath.row-1)as! NSDictionary).object(forKey: "checked") as! String == "true"{
                    imageView.backgroundColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0)
                    imageView.layer.borderWidth = 1.0
                    imageView.image = UIImage(named: "")
                }else if  ((hoursArray.object(at: indexPath.section-1) as! NSArray).object(at: indexPath.row-1)as! NSDictionary).object(forKey: "checked") as! String == "false"{
                    imageView.backgroundColor = UIColor.white
                    imageView.layer.borderWidth = 1
                    imageView.image = UIImage(named: "")
                }else{
                    imageView.image = UIImage(named: "15")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if  indexPath.section != 0{
            if indexPath.row == 0{
            }else{
                let tempDict = ((hoursArray.object(at: indexPath.section-1) as! NSArray).object(at: indexPath.row-1)as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                if tempDict.object(forKey: "checked") as! String == "true"{
                    tempDict.setObject("false", forKey: "checked" as NSCopying)
                }else if tempDict.object(forKey: "checked") as! String == "false"{
                    tempDict.setObject("true", forKey: "checked" as NSCopying)
                }else{
                    return
                }
                let tempArray = (hoursArray.object(at: indexPath.section-1) as! NSArray).mutableCopy() as! NSMutableArray
                tempArray.replaceObject(at: indexPath.row-1, with: tempDict)
                
                let hoursMutableArray = hoursArray.mutableCopy() as! NSMutableArray
                hoursMutableArray.replaceObject(at: indexPath.section-1, with: tempArray)
                self.hoursArray = hoursMutableArray
                if self.scheduleValue == 0{
                    //MORNING
                    self.slotArrayForDisplay.setObject(self.hoursArray, forKey: "early_morning" as NSCopying)
                }else  if self.scheduleValue == 1{
                    //AFTERNOON
                    self.slotArrayForDisplay.setObject(self.hoursArray, forKey: "morning" as NSCopying)
                }else  if self.scheduleValue == 2{
                    //EVENING
                    self.slotArrayForDisplay.setObject(self.hoursArray, forKey: "noon" as NSCopying)
                }else{
                    //EARLY MORNING
                    self.slotArrayForDisplay.setObject(self.hoursArray, forKey: "evening" as NSCopying)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    //MARK:- Web service for getting all the slots
    func getUserData(){
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "user_id" as NSCopying)
        dict.setObject(selectedDate, forKey: "date" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.slot_list,dict,{ (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") as! String == "success"
                {
                    if (dataFromServer["data"] as! NSDictionary).count > 0
                    {
                        self.slotArrayForDisplay.removeAllObjects()
                        self.hoursArray = NSArray()
                        self.minuteArray = NSArray()
                        let dict = (dataFromServer["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        self.markSlotsCheckedUnchecked(dict: dict)
                       
                    }
                }else{
                    
                }
            }
        }){ (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    //Set checked key on every slot to 'true' if it is 'free'  & 'booked' if it is 'booked or pending' on "Availability" array
    func markSlotsCheckedUnchecked(dict:NSDictionary){
        if (dict.object(forKey: "available_slots")) != nil{
            self.availableSlots = ((dict.object(forKey: "available_slots")) as! NSArray).mutableCopy() as! NSMutableArray
        }
        if (dict.object(forKey: "early_morning")) != nil{
            //MORNING
            self.hoursArray = (dict.object(forKey: "early_morning")   as! NSArray)
            self.minuteArray = self.hoursArray
            let tempArray =  NSMutableArray()
            if  self.hoursArray.count>0{
                var i = 0
                while i < self.hoursArray.count{
                    var j = i
                    let tempArray2 =  NSMutableArray()
                    while j < i+3{
                        let tempDict  = (self.hoursArray.object(at: j) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        let searchPredicate1 = NSPredicate(format: "id_slot = %@",tempDict.object(forKey: "id_slot") as! String)
                        let tempArr : NSArray = self.availableSlots.filtered(using: searchPredicate1) as NSArray
                        if tempArr.count>0{
                            if (tempArr.object(at: 0) as! NSDictionary).object(forKey: "slot_status") as! String == "free"{
                                tempDict.setObject("true", forKey: "checked" as NSCopying)
                            }else{
                                tempDict.setObject("booked", forKey: "checked" as NSCopying)
                            }
                            tempArray2.add(tempDict)
                        }else{
                            tempDict.setObject("false", forKey: "checked" as NSCopying)
                            tempArray2.add(tempDict)
                        }
                        j = j+1
                    }
                    tempArray.add(tempArray2)
                    i = i + 3
                }
                self.slotArrayForDisplay.setObject(tempArray, forKey: "early_morning" as NSCopying)
            }
        }
        //2nd
        if (dict.object(forKey: "morning")) != nil{
            //AFTERNOON
            self.hoursArray = (dict.object(forKey: "morning")   as! NSArray)
            self.minuteArray = self.hoursArray
            let tempArray =  NSMutableArray()
            
            if  self.hoursArray.count>0{
                var i = 0
                while i < self.hoursArray.count{
                    var j = i
                    let tempArray2 =  NSMutableArray()
                    while j < i+3{
                        let tempDict  = (self.hoursArray.object(at: j) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        let searchPredicate1 = NSPredicate(format: "id_slot = %@",tempDict.object(forKey: "id_slot") as! String)
                        let tempArr : NSArray = self.availableSlots.filtered(using: searchPredicate1) as NSArray
                        if tempArr.count>0{
                            if (tempArr.object(at: 0) as! NSDictionary).object(forKey: "slot_status") as! String == "free"{
                                tempDict.setObject("true", forKey: "checked" as NSCopying)
                            }else{
                                tempDict.setObject("booked", forKey: "checked" as NSCopying)
                            }
                            tempArray2.add(tempDict)
                        }else{
                            tempDict.setObject("false", forKey: "checked" as NSCopying)
                            tempArray2.add(tempDict)
                        }
                        j = j+1
                    }
                    tempArray.add(tempArray2)
                    i = i + 3
                }
                self.slotArrayForDisplay.setObject(tempArray, forKey: "morning" as NSCopying)
            }
        }
        //3rd
        if (dict.object(forKey: "noon")) != nil{
            //EVENING
            self.hoursArray = (dict.object(forKey: "noon")   as! NSArray)
            self.minuteArray = self.hoursArray
            let tempArray =  NSMutableArray()
            
            if  self.hoursArray.count>0
            {
                var i = 0
                
                while i < self.hoursArray.count{
                    var j = i
                    let tempArray2 =  NSMutableArray()
                    while j < i+3{
                        let tempDict  = (self.hoursArray.object(at: j) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        let searchPredicate1 = NSPredicate(format: "id_slot = %@",tempDict.object(forKey: "id_slot") as! String)
                        let tempArr : NSArray = self.availableSlots.filtered(using: searchPredicate1) as NSArray
                        if tempArr.count>0{
                            if (tempArr.object(at: 0) as! NSDictionary).object(forKey: "slot_status") as! String == "free"{
                                tempDict.setObject("true", forKey: "checked" as NSCopying)
                            }else{
                                tempDict.setObject("booked", forKey: "checked" as NSCopying)
                            }
                            tempArray2.add(tempDict)
                        }else{
                            tempDict.setObject("false", forKey: "checked" as NSCopying)
                            tempArray2.add(tempDict)
                        }
                        j = j+1
                    }
                    tempArray.add(tempArray2)
                    i = i + 3
                }
                self.slotArrayForDisplay.setObject(tempArray, forKey: "noon" as NSCopying)
            }
        }
        //4rd
        if (dict.object(forKey: "evening")) != nil{
            //EARLY MORNING
            self.hoursArray = (dict.object(forKey: "evening")   as! NSArray)
            self.minuteArray = self.hoursArray
            let tempArray =  NSMutableArray()
            
            if  self.hoursArray.count>0{
                var i = 0
                while i < self.hoursArray.count{
                    var j = i
                    let tempArray2 =  NSMutableArray()
                    while j < i+3{
                        let tempDict  = (self.hoursArray.object(at: j) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        let searchPredicate1 = NSPredicate(format: "id_slot = %@",tempDict.object(forKey: "id_slot") as! String)
                        let tempArr : NSArray = self.availableSlots.filtered(using: searchPredicate1) as NSArray
                        if tempArr.count>0{
                            if (tempArr.object(at: 0) as! NSDictionary).object(forKey: "slot_status") as! String == "free"{
                                tempDict.setObject("true", forKey: "checked" as NSCopying)
                            }else{
                                tempDict.setObject("booked", forKey: "checked" as NSCopying)
                            }
                            tempArray2.add(tempDict)
                        }else{
                            tempDict.setObject("false", forKey: "checked" as NSCopying)
                            tempArray2.add(tempDict)
                        }
                        j = j+1
                    }
                    tempArray.add(tempArray2)
                    i = i + 3
                }
                self.slotArrayForDisplay.setObject(tempArray, forKey: "evening" as NSCopying)
            }
        }
        if self.scheduleValue == 0{
            //MORNING
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "early_morning")   as! NSArray)
            self.minuteArray = self.hoursArray.object(at: 0) as! NSArray
        }else  if self.scheduleValue == 1{
            //AFTERNOON
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "morning")   as! NSArray)
            self.minuteArray = self.hoursArray.object(at: 0) as! NSArray
        }else  if self.scheduleValue == 2{
            //EVENING
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "noon")   as! NSArray)
            self.minuteArray = self.hoursArray.object(at: 0) as! NSArray
        }else{
            //EARLY MORNING
            self.hoursArray = (self.slotArrayForDisplay.object(forKey: "evening")   as! NSArray)
            self.minuteArray = self.hoursArray.object(at: 0) as! NSArray
        }
        self.tableView.reloadData()
    }
    
    func setBookAndRemoveSlot(){
        print(self.slotArrayForDisplay)
        let earlyMornigArray = self.slotArrayForDisplay.object(forKey: "early_morning") as! NSArray
        self.setDaysIntervalBookAndDeleteSlots(dayIntervalArray: earlyMornigArray)
        
        let eveningArray = self.slotArrayForDisplay.object(forKey: "evening") as! NSArray
        self.setDaysIntervalBookAndDeleteSlots(dayIntervalArray: eveningArray)
        
        let morningArray = self.slotArrayForDisplay.object(forKey: "morning") as! NSArray
        self.setDaysIntervalBookAndDeleteSlots(dayIntervalArray: morningArray)
        
        let noonArray = self.slotArrayForDisplay.object(forKey: "noon") as! NSArray
        self.setDaysIntervalBookAndDeleteSlots(dayIntervalArray: noonArray)
        
        if bookSlot.count>0 || deleteSlot.count>0{
            bookedSlots()
        }else{
            supportingfuction.showMessageHudWithMessage(message: "Please select slots for update.", delay: 2.0)
        }
    }
    
    func setDaysIntervalBookAndDeleteSlots(dayIntervalArray:NSArray){
        for item in dayIntervalArray{
            for data in (item as! NSArray){
                let searchPredicate1 = NSPredicate(format: "id_slot = %@",(data as! NSDictionary).object(forKey: "id_slot") as! String)
                let tempArr : NSArray = self.availableSlots.filtered(using: searchPredicate1) as NSArray
                if tempArr.count > 0{
                    if (data as! NSDictionary).object(forKey: "checked") as! String == "false"{
                        self.deleteSlot.add(["slot_id":(data as! NSDictionary).object(forKey: "id_slot") as! String])
                    }
                }else if (data as! NSDictionary).object(forKey: "checked") as! String == "true"{
                    self.bookSlot.add(["slot_id":(data as! NSDictionary).object(forKey: "id_slot") as! String])
                }
            }
        }
    }
    
    
    /**
     Booked availbility web service
     */
    func bookedSlots()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let requestData = NSMutableDictionary()
        requestData.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "user_id" as NSCopying)
        requestData.setObject(selectedDate, forKey: "date" as NSCopying)
        var tempJson : NSString = ""
        do {
            if  bookSlot.count > 0
            {
                
                let arrJson = try JSONSerialization.data(withJSONObject: bookSlot, options: JSONSerialization.WritingOptions.prettyPrinted)
                let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
                tempJson = string! as NSString
                print(tempJson)
                requestData.setObject(tempJson, forKey: "slot" as NSCopying)
                
            }
            else
            {
                requestData.setObject("", forKey: "slot" as NSCopying)
                
            }
        }catch let error as NSError{
            print(error.description)
        }
        
        var tempJson1 : NSString = ""
        do {
            if  deleteSlot.count > 0{
                let arrJson = try JSONSerialization.data(withJSONObject: deleteSlot, options: JSONSerialization.WritingOptions.prettyPrinted)
                let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
                tempJson1 = string! as NSString
                print(tempJson1)
                requestData.setObject(tempJson1, forKey: "remove" as NSCopying)
            }else{
                requestData.setObject("", forKey: "remove" as NSCopying)
            }
        }catch _ as NSError{
        }
        requestData.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        print(requestData)
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.save_availability,requestData,{ (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") as! String == "success"
                {
                    supportingfuction.hideProgressHudInView(view: self)
                    let msg:String = dataFromServer.object(forKey: "message") as! String
                    supportingfuction.showMessageHudWithMessage(message: msg as NSString, delay: 2.0)
                    Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.back), userInfo: nil, repeats: false)
                }
                else
                {
                    supportingfuction.hideProgressHudInView(view: self)
                }
            }
            
        })
        { (operation, error) in
            print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error, we are unable to proceed with your request.", delay: 2.0)
        }
    }
    
    func back()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}






