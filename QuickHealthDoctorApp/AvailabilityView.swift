//
//  AvailabilityView.swift
//  QuickHealthdoctorApp
//
//  Created by SS142 on 22/02/17.
//
//

import UIKit

class AvailabilityView: BaseViewController,UITableViewDelegate,UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var tableView: UITableView!
    var allBookedDateArray = NSMutableArray()
    var  value = ""
    var userInterface = UIDevice.current.userInterfaceIdiom
    
    var selectType = "selectSchedule"
    // var arrDate = String()
    var DateString = ""
    var type = "single_day"
    var isMultipleSelectedOn:Bool = false
    var selectedDate = String()
//    var calendar:FSCalendar!
    //var localSelectedDate:Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        isMultipleSelectedOn = true
        type = "single_day"
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .white
        let button = UIButton()
        button.tag = 10
//        onSlideMenuButtonPressed(button)
//        DateString = ""
        getUserData()
    }
    
    
    //MARK: TableView Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell!
        
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell")
            let calendarHeader = cell.viewWithTag(1)! as UIView
            let calDownHeader = cell.viewWithTag(2)! as UIView
            let calendar = cell.viewWithTag(3)! as! FSCalendar
            
            calendar.bookedDates = self.allBookedDateArray
            calendar.scopeGesture.isEnabled = false
            calendar.scrollEnabled = false
            calendar.dataSource = self
            calendar.delegate = self
            if isMultipleSelectedOn == true
            {
                calendar.allowMultipleSelect = true
            }
            else
            {
                calendar.allowMultipleSelect = false;
            }
            calendar.reloadData()
        }else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")
            let nextBtn = cell?.viewWithTag(6666)! as! UIButton
            nextBtn.layer.cornerRadius = 3.0
            //
            //            if isMultipleSelectedOn == false
            //            {
            //                nextBtn.isHidden = true
            //
            //            }
            //            else
            //            {
            //                nextBtn.isHidden = false
            //            }
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 320
        }else
        {
            return 64
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    /**
     */
    var shouldShowEventDot = false
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    deinit {
        print("\(#function)")
    }
    
    @objc
    func todayItemClicked(sender: AnyObject) {
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        let calendar = cell?.viewWithTag(3)! as! FSCalendar
        calendar.setCurrentPage(Date(), animated: false)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -32)
        let d = NSDate()
        let dStr = formatter.string(from: d as Date)
        let dateStr = formatter.string(from: date)
        if dateStr == dStr  {
            return 1
        }
        else    {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        
        return nil
    }
    
    
    //MARK: @IBAction
    
    @IBAction func multipleSelectionButtonClicked(sender:UIButton)
    {
        if isMultipleSelectedOn == false
        {
            isMultipleSelectedOn = true
            type = "recurring"
        }
        else
        {
            isMultipleSelectedOn = false
            type = "single_day"
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func menuBtnClicked(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender )
        
    }
    
    @IBAction func changeMonthButtonClicked(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        let calendar = cell?.viewWithTag(3)! as! FSCalendar
        
        for subview in calendar.subviews[0].subviews[0].subviews
        {
            if subview is UICollectionView
            {
                let collectionView = subview as! UICollectionView
                if sender.tag == 1
                {
                    
                    if collectionView.contentOffset.x == 0
                    {
                        
                    }else
                    {
                        collectionView.contentOffset.x = collectionView.contentOffset.x - collectionView.frame.size.width
                    }
                }
                else
                {
                    collectionView.contentOffset.x = collectionView.contentOffset.x + collectionView.frame.size.width
                }
            }
        }
        
    }
    
    //MARK:- CALENDAR DELEGATES
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        let dateString = NSDate()
        if dateString == NSDate()
        {
            shouldShowEventDot = true
        }
        return shouldShowEventDot
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        let currentDate = Date()
        return currentDate
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.DateString = ""
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if DateString != ""{
            calendar.deselect(dateFormatter.date(from: self.DateString)!)
        }
        DateString = dateFormatter.string(from: date)
    }
    ///
    
    /*
     
     Next button function for multiple date
     
     */
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookedAvailbilityView") as! BookedAvailbilityView
        if DateString == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please Select date.", delay: 2.0)
            return
        }
        vc.selectedDate = DateString
        self.navigationController?.pushViewController(vc, animated: true)
      }
    
    //MARK:- No of free slots date
    
    func getUserData()
    {
        supportingfuction.hideProgressHudInView(view: self)
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        
        dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "user_id" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.doctor_availability,dict,{ (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                self.allBookedDateArray.removeAllObjects()
                supportingfuction.hideProgressHudInView(view: self)
                if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else if dataFromServer.object(forKey: "status") as! String == "success"
                {
                    let arr = (dataFromServer.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                    for i in 0..<arr.count{
                        self.allBookedDateArray.add(arr.object(at: i))
                    }
                   self.tableView.reloadData()
                }
            }else{
                
            }
        }) { (operation, error) in
            print(error.localizedDescription)
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error, we are unable to proceed with your request.", delay: 2.0)
        }
    }
    
}



