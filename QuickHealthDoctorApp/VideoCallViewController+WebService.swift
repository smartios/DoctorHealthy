//
//  VideoCallViewWebServices.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 22/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import Foundation
// MARK: - Web services
extension VideoCallViewController{
    
    func submitPrescriptionDataOnServer(){
        
        let drugresult = PrescriptionMethods.getDrugsArrary(data: self.prescriptionData.drug_array)
        
        if drugresult.error{
            supportingfuction.showMessageHudWithMessage(message: "Please enter the complete details of your prescribed medication.", delay: 2.0)
            return
        }else if self.prescriptionData.prescription.trimmingCharacters(in: .whitespaces) == ""{
            supportingfuction.showMessageHudWithMessage(message: "Please enter the diagnosis detail.", delay: 2.0)
            return
        }
            else{
            supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Submitting...")
            let dict = NSMutableDictionary()
            
            do {
 
                dict.setObject(self.prescriptionData.prescription, forKey: "prescription" as NSCopying)
                
                dict.setObject(self.apointmentDict.object(forKey: "id_appointment") as! String, forKey: "id_appointment" as NSCopying)
                
                dict.setObject("completed", forKey: "call_status" as NSCopying)
                
                dict.setObject(self.id_call, forKey: "id_call" as NSCopying)
                
                dict.setObject("\(self.totalCallDuration - self.timeRemaining)", forKey: "call_duration" as NSCopying)
                
                dict.setObject(PrescriptionMethods.getLabTestArrary(data: self.prescriptionData.lab_test_array), forKey: "lab_test_array" as NSCopying)
                
                dict.setObject(drugresult.data, forKey: "drug_array" as NSCopying)
                dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
                let apiSniper = APISniper()
                
                apiSniper.getDataFromWebAPI(WebAPI.edit_prescription, dict, { (operation, responseObject) in
                    
                    if let dataFromServer = responseObject as? NSDictionary{
                        print(dataFromServer)
                        
                        //status
                        if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                            if self.callDurationTimer == nil{
                                self.popView()
                            }else{
                                self.callDurationTimer.invalidate()
                                self.callDurationTimer = nil
                                self.sendEndCallMessage()
                                self.perform(#selector(self.endCallAfterCallConnect), with: self, afterDelay: 1.0)
                                self.perform(#selector(self.popView), with: self, afterDelay: 2.0)
//                                self.removeChildController()
                                
                            }
                        }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                        {
                            supportingfuction.hideProgressHudInView(view: self)
                            logoutUser()
                        }else{
                            supportingfuction.hideProgressHudInView(view: self)
                            if dataFromServer.object(forKey: "message") != nil{
                               supportingfuction.showMessageHudWithMessage(message: dataFromServer.object(forKey: "message") as! NSString, delay: 2.0)
                            }
                        }
                    }
                }){ (operation, error) in
                    supportingfuction.hideProgressHudInView(view: self)
                    print(error.localizedDescription)
                    
                    supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
                }
            }catch let error as NSError{
                print(error.description)
            }
        }
        
    }
    
    func popView(){
        supportingfuction.hideProgressHudInView(view: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    //Check Slot availability web service
    func Check_Next_Slot_Webservice(){
        
        let dict = NSMutableDictionary()
        dict.setObject(apointmentDict.object(forKey: "id_appointment") as! String, forKey: "id_appointment" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.Extend_Call, dict, { (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary{
                print("Check_Next_Slot_Webservice====\(dataFromServer)")
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                    
                    self.isPaidAvailable = true
                    self.amount = dataFromServer.object(forKey: "amount") as! String
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else{
                   
                }
            }
            
        }) { (operation, error) in
//            supportingfuction.hideProgressHudInView(view: self)
//            print(error.localizedDescription)
//            
//            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
        }
    }
    
    //End Call web service
    func endCallWebService(){
        
        supportingfuction.hideProgressHudInView(view: self)
        
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        let dict = NSMutableDictionary()
        dict.setObject(apointmentDict.object(forKey: "id_appointment") as! String, forKey: "id_appointment" as NSCopying)
        dict.setObject("\(self.totalCallDuration - self.timeRemaining)", forKey: "exact_call_duration" as NSCopying)
        dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPI(WebAPI.End_call, dict, { (operation, responseObject) in
            
            supportingfuction.hideProgressHudInView(view: self)
            
            if let dataFromServer = responseObject as? NSDictionary{
                print(dataFromServer)
                if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                    
                }else if (dataFromServer.object(forKey: "error_code") != nil && "\(dataFromServer.object(forKey: "error_code")!)" != "" && "\(dataFromServer.object(forKey: "error_code")!)"  == "306")
                {
                    logoutUser()
                }else{
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
}
