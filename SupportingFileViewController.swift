//
//  LoginView.swift
//  getAvis
//
//  Created by SS142 on 01/08/16.
//  Copyright © 2016 SS142. All rights reserved.
//

import Foundation


let ApplicationDelegate = UIApplication.shared.delegate as! AppDelegate
var hud: MBProgressHUD!


class supportingfuction: NSObject
{
   class func fbDidlogout() {
//        var session: FBSession = FBSession.activeSession()
//        session.closeAndClearTokenInformation()
//        session.close()
//        FBSession.activeSession = nil
    }
//    @IBAction func btnlogOutClicked(sender: AnyObject) {
//        appDelegate.fbDidlogout()


    
   class func showProgressHudForViewMy (view:AnyObject, withDetailsLabel:NSString, labelText:NSString)
    {
        hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.detailsLabelText = withDetailsLabel as String
        hud.labelText = labelText as String
        
    }
   class func showMessageHudWithMessage(message:NSString, delay:CGFloat)
    {
        
        hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabelText = message as String
        let delay = TimeInterval(delay)
        [hud .hide(true, afterDelay: delay)]
        
    }
  class func hideProgressHudInView(view:AnyObject)
    {
        if hud != nil
        {
            [hud .hide(true)]
           // hud = nil
        }
    }
 
    
    
    
//    class func isValidPassword(testStr:String) -> Bool
//    {
//        
//        let validCharacters = NSCharacterSet(charactersIn: "(?=.*[a-z])(?=.*[A-Z])(?=.*?[0-9])(?=.*[$@$!%*?&])[?=.*?[#?!@$%^&*-]].{8,15}").inverted
//        
//        
//        if let range = testStr.rangeOfCharacterFromSet(validCharacters, options: [], range:Range<String.Index>(start: testStr.startIndex, end: testStr.endIndex))
//        {
//            return true
//        }
//        
//        
//        return false
//    }
    
    class func isValidDate(from: String, until: String) -> Bool
    {
        switch from.compare(until)
        {
        case .orderedAscending     :
            return true
            
        case .orderedDescending    :
            return false
            
        case .orderedSame          :
            return true
            
        }
    }

    
    class commonValidations: NSObject
    {
        
        class func isValidEmail(testStr:String) -> Bool {
            // println("validate calendar: \(testStr)")
            let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: testStr)
        }
        
        class func isValidNRIC(testStr:String) -> Bool
        {
            let nricRegEx = "(^[A-Z]{1}[0-9]{8}[A-Z]{1})"
            let nrictest = NSPredicate(format: "SELF MATCH %@", nricRegEx)
            return nrictest.evaluate(with: testStr)
        }
        
        
    }
}

