//
//  CallNotification.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 28/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import Foundation
class CallNotification{
    class func callAcceptReject(_ data:NSDictionary){
        print("Call Accept Reject=====\n \(data)")
        if (data.object(forKey: "call_accepted") as! String).lowercased() == "false"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callRejected"), object: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callAccepted"), object: nil)
        }
    }
    
    class func callReminder(_ data:NSDictionary){
        print("Call Reminder=====\n \(data)")
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = tabStoryboard.instantiateViewController(withIdentifier: "PatientListView") as! PatientListView
    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

class AppointmentNotification {
    class func newAppointmentBooking(_ data:NSDictionary){
        print("New appointment =====\n \(data)")
        let tempDict = NSMutableDictionary()
        tempDict.setObject(data.object(forKey: "id_appointment") as! String, forKey: "appointment_id" as NSCopying)
        tempDict.setObject(data.object(forKey: "from_user") as! String, forKey: "user_id" as NSCopying)
        tempDict.setObject("", forKey: "nurse_id" as NSCopying)
        
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = tabStoryboard.instantiateViewController(withIdentifier: "PatientDetailView") as! PatientDetailView
        vc.data = tempDict
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func NurseAlloted(_ data:NSDictionary){
        print("Nurse alloted to appointment =====\n \(data)")
        let tempDict = NSMutableDictionary()
        tempDict.setObject(data.object(forKey: "id_appointment") as! String, forKey: "appointment_id" as NSCopying)
        tempDict.setObject(data.object(forKey: "id_patient") as! String, forKey: "user_id" as NSCopying)
        tempDict.setObject(data.object(forKey: "id_nurse") as! String, forKey: "nurse_id" as NSCopying)
        
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = tabStoryboard.instantiateViewController(withIdentifier: "PatientDetailView") as! PatientDetailView
        vc.data = tempDict 
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
