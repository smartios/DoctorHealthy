//
//  SignupView.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 18/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit
import GooglePlaces
class SignupView: UIViewController,UITableViewDataSource,UITableViewDelegate,countryList,UIDocumentPickerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PECropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate{
    var icloudArray = NSMutableArray()

    var galleryImage = UIImage()
    var imageData = NSData()
    var documentBool = false
    var userInterface = UIDevice.current.userInterfaceIdiom

    var dataArray = [" ","","FIRST NAME","LAST NAME","DATE OF BIRTH","GENDER","EMAIL ADDRESS","MOBILE NUMBER","ADDRESS","STREET ADDRESS","CITY","LOCATION/STATE","AREA CODE","COUNTRY","LICENSE NUMBER","YEAR OF EXPERIENCE",""]
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var placesClient: GMSPlacesClient = GMSPlacesClient()
    @IBOutlet weak var tableView: UITableView?
    var Picker:UIImagePickerController!
    var ncode = ""
    var signUpDictionary = NSMutableDictionary()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datepickerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpDictionary.setValue("doctor", forKey: "type")
        signUpDictionary.setValue("male", forKey: "gender")
        placesClient = GMSPlacesClient.shared()

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        //////////for current location////////////////
        
        datepickerView.isHidden = true
        signUpDictionary.setValue("", forKey: "male")
        NotificationCenter.default.addObserver(self, selector: #selector(SignupView.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignupView.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    /**
     *  function to be called on keyboard get invisible
     *
     *  @param notification reference of NSNotification
     */
    
    
    func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let hit = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: hit)
        
        if indexPath?.row == 3 ||  indexPath?.row == 5  ||  indexPath?.row == 6
        {
            textField.resignFirstResponder()
        }
        else {
            // create custom indexpath for same textfield
            let nexCell = (tableView?.cellForRow(at: IndexPath(row: (indexPath?.row)! + 1, section: 0)))! as UITableViewCell
            
            ((nexCell).viewWithTag(2) as! UITextField).becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        if cellIndexPath![1] == 2
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "first_name" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "first_name" as NSCopying)
                
            }
            
        }else if cellIndexPath![1] == 3
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "last_name" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "last_name" as NSCopying)
            }
        }
            
        else if cellIndexPath![1] == 6
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "email" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "email" as NSCopying)
            }
            
        }
        else if cellIndexPath![1] == 7
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "mobile_no" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "mobile_no" as NSCopying)
            }
        }
        else if cellIndexPath![1] == 9
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "street" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "street" as NSCopying)
            }
        }
        else if cellIndexPath![1] == 10
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "city" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "city" as NSCopying)
            }
        }
        else if cellIndexPath![1] == 11
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "state" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "state" as NSCopying)
            }
        }
        else if cellIndexPath![1] == 12
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "area_code" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "area_code" as NSCopying)
            }
        }
        else if cellIndexPath![1] == 13
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "country" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "country" as NSCopying)
            }
        }
        else if cellIndexPath![1] == 14
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "licence_no" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "licence_no" as NSCopying)
            }
        }
        else if cellIndexPath![1] == 15
        {
            if textField.text != ""
            {
                signUpDictionary.setObject(textField.text!.trimmingCharacters(in: .whitespaces), forKey: "year_of_experience" as NSCopying)
            }else
            {
                signUpDictionary.setObject("", forKey: "year_of_experience" as NSCopying)
            }
        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView?.indexPathForRow(at: pointInTable)
        print(cellIndexPath!)
        
        
        let resultString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
         if cellIndexPath![1] == 15
        {
        
        if resultString.characters.count>2
        {
            
            return false
        }
            
        }
        return true
    }
    
    
    //MARK:- TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let profileImg = cell.viewWithTag(999) as! UIImageView
            profileImg.layer.cornerRadius = profileImg.frame.width/2
            profileImg.layer.borderWidth = 1.0
            //profileImg.layer.borderColor = UIColor.darkGray.cgColor
            profileImg.clipsToBounds = true
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell6")
            let button = cell.viewWithTag(31) as? UIButton
            let button2 = cell.viewWithTag(32) as? UIButton
             let label = cell.viewWithTag(43) as? UILabel
            let label1 = cell.viewWithTag(51) as? UILabel
            let label2 = cell.viewWithTag(52) as? UILabel
            let sepLabel = cell.viewWithTag(1111) as? UILabel
            sepLabel?.isHidden = true

            label1?.text = "Doctor"
            label2?.text = "Nurse"
            label?.text = "PROFESSION"
            button2?.isSelected = false
            button?.isSelected = false
            if signUpDictionary.object(forKey: "type") != nil && signUpDictionary.object(forKey: "type") as! String == "doctor"
            {
                button?.isSelected = true
                button2?.isSelected = false
            }
            else  if signUpDictionary.object(forKey: "type") != nil && signUpDictionary.object(forKey: "type") as! String == "nurse"
            {
                button2?.isSelected = true
                button?.isSelected = false
            }
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField.inputAccessoryView = nil
            textField.returnKeyType = .next

            arrow.isHidden = true
            if signUpDictionary.object(forKey: "first_name") != nil &&
                signUpDictionary.object(forKey: "first_name") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "first_name") as! String?
            }else
            {
                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
                textField.text = ""
            }
        }
        else if indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row];            arrow.isHidden = true
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField.inputAccessoryView = nil
            textField.returnKeyType = .default

            if signUpDictionary.object(forKey: "last_name") != nil &&
                signUpDictionary.object(forKey: "last_name") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "last_name") as! String?
            }else
            {
                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
                textField.text = ""

            }
        }
            
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = false
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            arrow.isHidden = false
            arrow.setImage(UIImage(named:"calender"), for: .normal)
            arrow.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
            if signUpDictionary.object(forKey: "dob") != nil &&
                signUpDictionary.object(forKey: "dob") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "dob") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            
            
        }
            
        else if indexPath.row == 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell7")
            let button = cell.viewWithTag(33) as? UIButton
            let button2 = cell.viewWithTag(34) as? UIButton
            let label = cell.viewWithTag(43) as? UILabel
            let label1 = cell.viewWithTag(51) as? UILabel
            let label2 = cell.viewWithTag(52) as? UILabel
            let sepLabel = cell.viewWithTag(1111) as? UILabel
            sepLabel?.isHidden = true
            label1?.text = "Male"
            label2?.text = "Female"
            label?.text = "GENDER"
            button2?.isSelected = false
            button?.isSelected = false
            if signUpDictionary.object(forKey: "gender") != nil && signUpDictionary.object(forKey: "gender") as! String == "male"
            {
                button?.isSelected = true
                button2?.isSelected = false
            }
            else  if signUpDictionary.object(forKey: "gender") != nil && signUpDictionary.object(forKey: "gender") as! String == "female"
            {
                button2?.isSelected = true
                button?.isSelected = false
            }
        }
        else if indexPath.row == 6
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            arrow.isHidden = true
            textField.inputAccessoryView = nil
            textField.returnKeyType = .default

            textField.keyboardType = UIKeyboardType.emailAddress
            if signUpDictionary.object(forKey: "email") != nil &&
                signUpDictionary.object(forKey: "email") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "email") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            
            
            
        }
        else if indexPath.row == 7
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell4")
            
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(3) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(2) as! UIButton
            title.text = dataArray[indexPath.row]
            textField.keyboardType = UIKeyboardType.numberPad
             let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/17))
            //Setting the style for the toolbar
            keyboardDoneButtonShow.barStyle = UIBarStyle .default
            //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.hideKeyboard))
            //Calculating the flexible Space.
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            //Setting the color of the button.
            doneButton.tintColor = UIColor.black
            //Making an object using the button and space for the toolbar
            let toolbarButton = [flexSpace,doneButton]
            //Adding the object for toolbar to the toolbar itself
            keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
            //Now adding the complete thing against the desired textfield
            textField.inputAccessoryView = keyboardDoneButtonShow
            
             if signUpDictionary.object(forKey: "mobile_ext") != nil &&
                signUpDictionary.object(forKey: "mobile_ext") as! String != ""
            {
                arrow.setTitle(signUpDictionary.object(forKey: "mobile_ext") as? String, for: .normal)
            }
            else{
                arrow.setTitle("+65", for: .normal)
                 signUpDictionary.setObject("+65", forKey: "mobile_ext" as NSCopying)
            }
            if signUpDictionary.object(forKey: "mobile_no") != nil &&
                signUpDictionary.object(forKey: "mobile_no") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "mobile_no") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
        if signUpDictionary.object(forKey: "mobile_ext") != nil && signUpDictionary.object(forKey: "mobile_ext") is NSNull == false && signUpDictionary.object(forKey: "mobile_ext") as! String != ""
                {
                
                arrow.setTitle(signUpDictionary.object(forKey: "mobile_ext") as? String, for: .normal)
                }else
                {
                arrow.setTitle("", for: .normal)
            }

            
        }
        else if indexPath.row == 8
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = false
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            arrow.isHidden = false
            arrow.setImage(UIImage(named:"location"), for: .normal)
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.inputAccessoryView = nil

            arrow.addTarget(self, action: #selector(currentLoaction), for: .touchUpInside)
            if signUpDictionary.object(forKey: "address") != nil &&
                signUpDictionary.object(forKey: "address") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "address") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
                
            }
            
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        else if indexPath.row == 9
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            arrow.isHidden = true
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.inputAccessoryView = nil
            textField.returnKeyType = .next

            textField.leftViewMode = UITextFieldViewMode.always
            if signUpDictionary.object(forKey: "street") != nil &&
                signUpDictionary.object(forKey: "street") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "street") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        else if indexPath.row == 10
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            arrow.isHidden = true
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.inputAccessoryView = nil
            textField.returnKeyType = .next

            if signUpDictionary.object(forKey: "city") != nil &&
                signUpDictionary.object(forKey: "city") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "city") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        else if indexPath.row == 11
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            arrow.isHidden = true
            textField.isUserInteractionEnabled = true
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.inputAccessoryView = nil
            textField.returnKeyType = .next

            if signUpDictionary.object(forKey: "state") != nil &&
                signUpDictionary.object(forKey: "state") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "state") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            
            //Setting the style for the toolbar
            
        }
        else if indexPath.row == 12
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            textField.keyboardType = UIKeyboardType.numberPad
            let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/17))
            //Setting the style for the toolbar
            keyboardDoneButtonShow.barStyle = UIBarStyle .default
            //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.hideKeyboard))
            //Calculating the flexible Space.
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            //Setting the color of the button.
            doneButton.tintColor = UIColor.black
            //Making an object using the button and space for the toolbar
            let toolbarButton = [flexSpace,doneButton]
            //Adding the object for toolbar to the toolbar itself
            keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
            //Now adding the complete thing against the desired textfield
            textField.inputAccessoryView = keyboardDoneButtonShow


            arrow.isHidden = true
            textField.isUserInteractionEnabled = true
            if signUpDictionary.object(forKey: "area_code") != nil &&
                signUpDictionary.object(forKey: "area_code") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "area_code") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            //Setting the style for the toolbar
        }
            
        else if indexPath.row == 13
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.inputAccessoryView = nil

            arrow.isHidden = true
            textField.isUserInteractionEnabled = false
            if signUpDictionary.object(forKey: "country") != nil &&
                signUpDictionary.object(forKey: "country") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "country") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            //Setting the style for the toolbar
        }
    
        else if indexPath.row == 14
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            textField.keyboardType = UIKeyboardType.asciiCapable
            textField.inputAccessoryView = nil
            textField.returnKeyType = .next

            arrow.isHidden = true
            textField.isUserInteractionEnabled = true
            if signUpDictionary.object(forKey: "licence_no") != nil &&
                signUpDictionary.object(forKey: "licence_no") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "licence_no") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            //Setting the style for the toolbar
        }
        else if indexPath.row == 15
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            let title = cell.viewWithTag(1) as!  UILabel
            let textField = cell.viewWithTag(2) as! UITextField
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            let arrow = cell.viewWithTag(3) as! UIButton
            title.text = dataArray[indexPath.row]
            arrow.isHidden = true
            textField.isUserInteractionEnabled = true
            textField.keyboardType = UIKeyboardType.numberPad
            let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/17))
            //Setting the style for the toolbar
            keyboardDoneButtonShow.barStyle = UIBarStyle .default
            //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.hideKeyboard))
            //Calculating the flexible Space.
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            //Setting the color of the button.
            doneButton.tintColor = UIColor.black
            //Making an object using the button and space for the toolbar
            let toolbarButton = [flexSpace,doneButton]
            //Adding the object for toolbar to the toolbar itself
            keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
            //Now adding the complete thing against the desired textfield
            textField.inputAccessoryView = keyboardDoneButtonShow

            
            
            
            
            if signUpDictionary.object(forKey: "year_of_experience") != nil &&
                signUpDictionary.object(forKey: "year_of_experience") as! String != ""
            {
                textField.text = signUpDictionary.object(forKey: "year_of_experience") as! String?
            }else
            {
                textField.text = ""

                textField.attributedPlaceholder = NSAttributedString(string: dataArray[indexPath.row],
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            }
            //Setting the style for the toolbar
        }

            
        else if indexPath.row == 16
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell5")
            let collectionView = cell.viewWithTag(133) as!  UICollectionView
            collectionView.reloadData()
            collectionView.delegate = self;
        }
            
        else if indexPath.row == 17
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell3")
            let signupButton = cell.viewWithTag(999) as! UIButton
            let conditionButton = cell.viewWithTag(1000) as! UIButton
            let textView = cell.viewWithTag(222) as! UITextView
            signupButton.layer.cornerRadius =  5
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.navigateToLogin))
            textView.addGestureRecognizer(tap)
            if signUpDictionary.object(forKey: "terms") != nil &&
                signUpDictionary.object(forKey: "terms") as! String == "selected"
            {
               conditionButton.isSelected = true
            }else
            {
                conditionButton.isSelected = false

            }
            
            let atrStr = NSMutableAttributedString(string: "Already a member of QuickHealth? Login.")
            atrStr.addAttribute(NSLinkAttributeName, value: "www.google.com", range: NSRange(location: 33, length: ("Login.").utf16.count))
            
            atrStr.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 33, length: ("Login.").utf16.count))
            atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: ("Already a member of QuickHealth?").utf16.count))
            atrStr.addAttribute(NSFontAttributeName, value:UIFont(name: "Arimo-Regular", size: 15.0)! , range: NSRange(location: 33, length: ("Login.").utf16.count))
            atrStr.addAttribute(NSFontAttributeName, value:UIFont(name: "Arimo-Regular", size: 15.0)! , range: NSRange(location: 0, length: ("Already a member of QuickHealth?").utf16.count))
            textView.attributedText = atrStr
            
        }
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
    
    func navigateToLogin()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 4
        {
            openDatePicker()

        }
        if indexPath.row == 8
        {
        // Present the Autocomplete view controller when the button is pressed.
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        }
        if indexPath.row == 13
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
            vc.delegate = self
            vc.comminfromIndex = "get_country_code"
            vc.from = "country"
            ncode = "get_country_code"
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        if indexPath.row == 6
//        {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
//            vc.delegate = self
//            vc.comminfromIndex = "type_of_services"
//            ncode = "type_of_services"
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            
            if(userInterface == .pad){
                return 500
            }
            else {
                return 300
            }
            
            
        }
        else if indexPath.row == 16
        {
            return 170
        }
        else if indexPath.row == 17
        {
            return 181
            
        }else
        {
            return 55
        }
    }
    
    
    // get country code
    func getCountryCode(code: String, ID: String)
    {
        signUpDictionary.setObject(ID, forKey: "mobile_ext" as NSCopying)
        signUpDictionary.setObject(code, forKey: "country" as NSCopying)
        
        self.tableView?.reloadData()
    }
    
    
      @IBAction func uploadDocumentTapped(sender: UIButton)
    {
        if icloudArray.count < 5
        {
            documentBool = true
            let myActionSheet : UIActionSheet  = UIActionSheet()
            myActionSheet.addButton(withTitle: "Use Gallery")
            myActionSheet.addButton(withTitle: "Use Camera")
            myActionSheet.addButton(withTitle: "Use iCloud")
            myActionSheet.addButton(withTitle: "Cancel")
            myActionSheet.delegate=self
            myActionSheet.show(in: self.view)
        }else
        {
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
                    icloudArray.add(dict)
                    tableView?.reloadData()
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
    
    
    @IBAction func countryBtnTapped(sender: UIButton)
    {
        countryCodewebService()
    }
    
    
    func countryCodewebService()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
        vc.delegate = self
        vc.comminfromIndex = "get_country_code"
        vc.from = "country"
        ncode = "get_country_code"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func SubmitBtnTapped(sender: UIButton){
        self.view.endEditing(true)
        
        if signUpDictionary.object(forKey: "type") == nil ||  signUpDictionary.object(forKey: "type") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select type.", delay: 2.0)
            return
        }
        if signUpDictionary.object(forKey: "first_name") == nil ||  signUpDictionary.object(forKey: "first_name") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterFirstName as NSString, delay: 2.0)
            return
        }
        if signUpDictionary.object(forKey: "last_name") == nil ||  signUpDictionary.object(forKey: "last_name") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterLastName as NSString, delay: 2.0)
            return
        }
       
        if signUpDictionary.object(forKey: "dob") == nil ||  signUpDictionary.object(forKey: "dob") as! String == ""
        {
            
            supportingfuction.showMessageHudWithMessage(message: enterDob as NSString, delay: 2.0)
            return
        }
        if signUpDictionary.object(forKey: "gender") == nil ||  signUpDictionary.object(forKey: "gender") as! String == ""
        {
            
            supportingfuction.showMessageHudWithMessage(message: gender as NSString, delay: 2.0)
            return
        }
        
        if signUpDictionary.object(forKey: "email") == nil ||  signUpDictionary.object(forKey: "email") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterEmail as NSString, delay: 2.0)
            return
        }
        if (CommonValidations.isValidEmail(testStr: signUpDictionary.object(forKey: "email") as! String ) ) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validEmail as NSString, delay: 2.0)
            return
        }

        if signUpDictionary.object(forKey: "mobile_no") == nil || signUpDictionary.object(forKey: "mobile_no") as! String == ""
        {
            
            supportingfuction.showMessageHudWithMessage(message: enterMobileNum as NSString, delay: 2.0)
            return
            
        }
        if  (signUpDictionary.object(forKey: "mobile_no") as! String).characters.count  <= 5 ||   (signUpDictionary.object(forKey: "mobile_no") as! String).characters.count > 15
        {
            
            supportingfuction.showMessageHudWithMessage(message: "Mobile Number field must contain 6 to 15 digits.", delay: 2.0)
            return
        }
        
        
        if signUpDictionary.object(forKey: "address") == nil ||  signUpDictionary.object(forKey: "address") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterAddress as NSString, delay: 2.0)
            return
            
        }
               if signUpDictionary.object(forKey: "street") == nil ||  signUpDictionary.object(forKey: "street") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterStreetAddress as NSString, delay: 2.0)
            return
        }
        
     
        
        if signUpDictionary.object(forKey: "city") == nil ||  signUpDictionary.object(forKey: "city") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterCity as NSString, delay: 2.0)
            return
        }
        
        
        if signUpDictionary.object(forKey: "state") == nil ||  signUpDictionary.object(forKey: "state") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterState as NSString, delay: 2.0)
            return
        }
        
        if signUpDictionary.object(forKey: "area_code") == nil ||  signUpDictionary.object(forKey: "area_code") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterAreaCode as NSString, delay: 2.0)
            return
        }
//        if signUpDictionary.object(forKey: "country") == nil ||  signUpDictionary.object(forKey: "country") as! String == ""
//        {
//            supportingfuction.showMessageHudWithMessage(message: entercountry as NSString, delay: 2.0)
//            return
//        }
        
        if signUpDictionary.object(forKey: "licence_no") == nil ||  signUpDictionary.object(forKey: "licence_no") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: licenceno as NSString, delay: 2.0)
            return
        }

        
                if signUpDictionary.object(forKey: "year_of_experience") == nil ||  signUpDictionary.object(forKey: "year_of_experience") as! String == ""
                {
                    supportingfuction.showMessageHudWithMessage(message:"Please enter year of experience.", delay: 2.0)
                    return
                }

        if icloudArray.count==0
        {
            supportingfuction.showMessageHudWithMessage(message: "Please upload document.", delay: 2.0)
            return
        }
        
               if signUpDictionary.object(forKey: "terms") == nil ||
            signUpDictionary.object(forKey: "terms") as! String == "" 
        {
            supportingfuction.showMessageHudWithMessage(message: "Please acknowledge.", delay: 2.0)
            return
        }
       
        
        
        
        signUpWebService()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        if icloudArray.count < 5
//        {
        return icloudArray.count+1
//        }else
//        {
//           return icloudArray.count
//        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 96, height: 126)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell:UICollectionViewCell!
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
                sizeLabel.text = (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_size") as! String
                 nameLabel.text = (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_name") as! String

                if (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_type") as! String == "pdf"
                {
                    imageView.image = UIImage(named: "pdf")
                }else if ( (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_type") as! String).lowercased() == "png" || ( (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_type") as! String).lowercased() ==  "jpg" || ( (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "file_type") as! String).lowercased() ==  "jpeg"
                {
                    
                    if  ( (icloudArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "type") as! String) == "url"
                    {
                    imageView.setImageWith((icloudArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image_url") as! URL, placeholderImage: UIImage(named: "img"))
                    }
                    else
                    {
                      imageView.image = (icloudArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image_url") as! UIImage?
                    }
                }else
                {
                    imageView.image = UIImage(named: "doc")
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
    
    @IBAction func radioButtonClicked(_ sender: UIButton) {
       
        if sender.tag == 31
        {
        signUpDictionary.setValue("doctor", forKey: "type")
            
        }
        else if sender.tag == 32
        {
            signUpDictionary.setValue("nurse", forKey: "type")
            
        }
        else if sender.tag == 33
        {
            signUpDictionary.setValue("male", forKey: "gender")
            
        }
        else
        {
            signUpDictionary.setValue("female", forKey: "gender")
        }
        tableView?.reloadData()
            }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        let hit = sender.convert(CGPoint.zero, to: tableView)
        let hitIndex3 = tableView?.indexPathForRow(at: hit)
        let cell = self.tableView!.cellForRow(at: hitIndex3!)
        let collection = cell!.viewWithTag(133) as! UICollectionView
        let hitPoint = sender.convert(CGPoint.zero, to: collection)
        let hitIndex = collection.indexPathForItem(at: hitPoint)
        icloudArray.removeObject(at: (((hitIndex?.row)))!)
        tableView?.reloadData()
    }
    
    //
    
   func currentLoaction()
   {
    
    supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
    
    placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
        if let error = error {
            print("Pick Place error: \(error.localizedDescription)")
            supportingfuction.hideProgressHudInView(view: self)
            supportingfuction.showMessageHudWithMessage(message: "Something went wrong.Please try again later.", delay: 2.0)
            return
            
        }
        
        if let placeLikelihoodList = placeLikelihoodList {
            for likelihood in placeLikelihoodList.likelihoods {
                supportingfuction.hideProgressHudInView(view: self)
                let place = likelihood.place
                
                if (place.formattedAddress) != nil
                {
                    self.signUpDictionary.setObject((place.formattedAddress)!, forKey: "address" as NSCopying)
                }
                
                print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                print("Current Place address \(place.formattedAddress)")
                print("Current Place attributions \(place.attributions)")
                print("Current PlaceID \(place.placeID)")
                self.tableView?.reloadData()
            }
            supportingfuction.hideProgressHudInView(view: self)
        }
    })
    }
    
    
    
    
    
    
    //MARK:- DatePicker function
    func openDatePicker()
    {
        datePicker.datePickerMode = UIDatePickerMode.date
        datepickerView.isHidden = false
        self.view.endEditing(true)
    }
    
    
    func setDateFunction()
    {
        
        datePicker.datePickerMode = UIDatePickerMode.date
      
        
        let date: DateFormatter = DateFormatter()
        
        date.dateFormat = "dd-MMM-yyyy"
        let currDate = NSDate() as Date
        if currDate.compare(datePicker.date) == .orderedAscending
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select valid date." as NSString, delay: 2.0)
            return
        }
        else
        {
            signUpDictionary.setObject((date.string(from: datePicker.date) ), forKey: "dob" as NSCopying)
        }
        self.tableView?.reloadData()
        datepickerView.isHidden = true

        
    }
    
    
    
    @IBAction func conditionSelectedBtnClicked(_ sender: UIButton) {
        if sender.isSelected == false
        {
            signUpDictionary.setValue("selected", forKey: "terms")
            
        }
        else
        {
            signUpDictionary.setValue("", forKey: "terms")
        }
        tableView?.reloadData()
    }
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        setDateFunction()
    }
    
    @IBAction func canceldBtnTapped(_ sender: UIButton) {
        datepickerView.isHidden = true
    }
    // MARK: - image picker gallery
    
    
   
    
    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        print(buttonIndex)
        
        if documentBool == false
        {
        switch(buttonIndex)
        {
        case 0:
            self.Picker = UIImagePickerController()
            self.Picker.delegate = self
            Picker.allowsEditing = false
            
            Picker.sourceType = .photoLibrary
            
            self.present(Picker, animated: true, completion: nil)
            
            break
            
        case 1:
            
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
            {
                self.Picker = UIImagePickerController()
                self.Picker.delegate = self
            Picker.allowsEditing = false
            
            Picker.sourceType = UIImagePickerControllerSourceType.camera
            
            present(Picker, animated: true, completion: nil)
            }
            
            break
            
        default:break
        }
        }
        else
        {
            switch(buttonIndex)
            {
            case 0:
                self.Picker = UIImagePickerController()
                self.Picker.delegate = self
                Picker.allowsEditing = false
                
                Picker.sourceType = .photoLibrary
                
                self.present(Picker, animated: true, completion: nil)
                
                break
                
            case 1:
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
                {
                    self.Picker = UIImagePickerController()
                    self.Picker.delegate = self
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
  
        }
    }

    @IBAction func imageButtonTapped(sender: UIButton) {
        documentBool = false
        let myActionSheet : UIActionSheet  = UIActionSheet()
        myActionSheet.addButton(withTitle: "Use Gallery")
        myActionSheet.addButton(withTitle: "Use Camera")
        myActionSheet.addButton(withTitle: "Cancel")
        myActionSheet.delegate=self
        myActionSheet.show(in: self.view)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
                
        if let pickedImage = UIImage.scaleAndRotateImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!) {
            if documentBool == false
            {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.tableView?.cellForRow(at: indexPath)
            let ProfileImage = cell!.viewWithTag(999) as! UIImageView
            ProfileImage.contentMode = .scaleAspectFill
            ProfileImage.image = pickedImage
            galleryImage = pickedImage
                ProfileImage.image = galleryImage


            }else
            {
                galleryImage = pickedImage
                let dict = NSMutableDictionary()
                dict.setObject("image", forKey: "type" as NSCopying)
                dict.setObject(pickedImage, forKey: "image_url" as NSCopying)
                dict.setObject((UIImageJPEGRepresentation(pickedImage, 0.6) as! NSData), forKey: "img_data" as NSCopying)
                dict.setObject(transformedValue(Double((UIImageJPEGRepresentation(pickedImage, 0.6) as! NSData).length)), forKey: "file_size" as NSCopying)
                dict.setObject("JPG", forKey: "file_type" as NSCopying)
                dict.setObject("Image.jpg", forKey: "file_name" as NSCopying)
                icloudArray.add(dict)
                tableView?.reloadData()


            }
        }
        picker.dismiss(animated: true) { () -> Void in
            if self.documentBool == false
            {
                self.openEditor()

            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // croping functionality
    func openEditor()
    {
        let controller=PECropViewController()
        controller.delegate = self;
        controller.image = galleryImage
        let image1 = galleryImage
        let width : CGFloat = (image1.size.width)
        let height : CGFloat = (image1.size.height)
        let length : CGFloat = min(width, height)
        
        controller.imageCropRect = CGRect(x: (width - length) / 2, y: (height - length) / 2, width: length, height: length)
        
        let navigationController=UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func cropViewController(_ controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!, transform: CGAffineTransform, cropRect: CGRect)
    {
        controller.dismiss(animated: true, completion: nil)
        
        if documentBool == false
        {
        //edited = true
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView?.cellForRow(at: indexPath)
        let ProfileImage = cell!.viewWithTag(999) as! UIImageView

       
        
        galleryImage = croppedImage
        ProfileImage.image = galleryImage
        imageData = UIImageJPEGRepresentation(croppedImage, 0.6) as! NSData
        }
        else
        {
        imageData = UIImageJPEGRepresentation(croppedImage, 0.6) as! NSData
        let dict = NSMutableDictionary()
        dict.setObject("image", forKey: "type" as NSCopying)
        dict.setObject(croppedImage, forKey: "image_url" as NSCopying)
        dict.setObject(imageData, forKey: "img_data" as NSCopying)
        dict.setObject(transformedValue(Double(imageData.length)), forKey: "file_size" as NSCopying)
            dict.setObject("JPG", forKey: "file_type" as NSCopying)
             dict.setObject("Image.jpg", forKey: "file_name" as NSCopying)
        icloudArray.add(dict)
        tableView?.reloadData()
        }
        
        
    }
    
    func cropViewControllerDidCancel(_ controller: PECropViewController!)
    {
        
        
        controller.dismiss(animated: true, completion: nil)
    }

    
    
    
}
extension SignupView: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        
        print("Place address: \(place.formattedAddress)")
        
        if (place.formattedAddress) != nil
        {
            self.signUpDictionary.setObject((place.formattedAddress)!, forKey: "address" as NSCopying)
        }
        
        
        
        print("Place attributions: \(place.attributions)")
        print("Place latitude: \(place.coordinate.latitude)")
        print("Place longitude: \(place.coordinate.longitude)")
        
        dismiss(animated: true, completion: nil)
        self.tableView?.reloadData()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //
    
    // api_token
    func signUpWebService()
    {
        print(supportingfuction.self)
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject(signUpDictionary.object(forKey: "type") as! String, forKey: "user_type" as NSCopying)
        
        dict.setObject(signUpDictionary.object(forKey: "first_name") as! String, forKey: "first_name" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "last_name") as! String, forKey: "last_name" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "dob") as! String, forKey: "date_of_birth" as NSCopying)
        
        dict.setObject(signUpDictionary.object(forKey: "gender") as! String, forKey: "gender" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "email") as! String, forKey: "email" as NSCopying)

        dict.setObject(signUpDictionary.object(forKey: "mobile_no") as! String, forKey: "mobile_number" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "address") as! String, forKey: "address" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "street") as! String, forKey: "street_address" as NSCopying)
      
        dict.setObject(signUpDictionary.object(forKey: "city") as! String, forKey: "city" as NSCopying)
        
        dict.setObject(signUpDictionary.object(forKey: "state") as! String, forKey: "state" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "area_code") as! String, forKey: "area_code" as NSCopying)
        dict.setObject("India", forKey: "country" as NSCopying)
         dict.setObject(signUpDictionary.object(forKey: "licence_no") as! String, forKey: "license_number" as NSCopying)
        
         dict.setObject(Int(signUpDictionary.object(forKey: "year_of_experience") as! String)!, forKey: "year_of_experience" as NSCopying)
        dict.setObject(signUpDictionary.object(forKey: "mobile_ext") as! String, forKey: "mobile_ext" as NSCopying)
        print(dict)
        
        let apiSniper = APISniper()
        apiSniper.getDataFromSignup(WebAPI.signUp,dict,imageData,icloudArray,completeBlock: { (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                if dataFromServer.object(forKey: "status") as! String == "success"
                {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                    supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! String as NSString, delay: 2.0)
                    self.navigationController?.popViewController(animated: true)
                }else
                {
                    supportingfuction.hideProgressHudInView(view: self)
                    supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! String as NSString, delay: 2.0)
                    
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    
}
extension SignupView: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    
    
    
}
