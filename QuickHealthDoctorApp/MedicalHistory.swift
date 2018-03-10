//
//  MedicalHistory.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 02/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import Foundation

class MedicalHistory {
    var id_appointment:String = ""
    var id_medication:String = ""
    var drug_sensitivity_description:String = ""
    var id_nurse:String = ""
    var id_user:String = ""
    var is_drug_sensitivity:String = "no"
    var is_medical_condition:String = "no"
    var is_medication:String = "no"
    var is_surgeries_medical_procedure:String = "no"
    var currentMedications:[CurrentMedication] = []
    var medicalConditions:[MedicalCondition] = []
    var medicalSurgery:[MedicalSurgery] = []
    
    init(json:NSDictionary) {
        self.id_appointment = json.object(forKey: "id_appointment") as! String
        self.id_medication = json.object(forKey: "id_medication") as! String
        self.drug_sensitivity_description = json.object(forKey: "drug_sensitivity_description") as! String
        self.id_nurse = json.object(forKey: "id_nurse") as! String
        self.id_user = json.object(forKey: "id_user") as! String
        
        if json.object(forKey: "is_drug_sensitivity") as! String != ""{
            self.is_drug_sensitivity = json.object(forKey: "is_drug_sensitivity") as! String
        }
        
        if json.object(forKey: "is_medical_condition") as! String != ""{
            self.is_medical_condition = json.object(forKey: "is_medical_condition") as! String
        }
        
        if json.object(forKey: "is_surgeries_medical_procedure") as! String != ""{
            
        self.is_surgeries_medical_procedure = json.object(forKey: "is_surgeries_medical_procedure") as! String
        }
        
        if json.object(forKey: "is_medication") as! String != ""{
            self.is_medication = json.object(forKey: "is_medication") as! String
        }
        
        if self.is_medication != "no"{
            if let x = json.object(forKey: "current_medication") as? NSArray{
                for data in x{
                    
                    self.currentMedications.append(CurrentMedication(json: data as! NSDictionary))
                }
            }
        }
        
        if self.is_medical_condition != "no"{
            if let x = json.object(forKey: "medical_condition_des") as? NSArray{
                for data in x{
                    if (data as! NSDictionary).object(forKey: "when") as! String != ""{
                       self.medicalConditions.append(MedicalCondition(json: data as! NSDictionary))
                    }
                }
            }
        }
        
        if self.is_surgeries_medical_procedure != "no"{
            if let x = json.object(forKey: "surgery__des") as? NSArray{
                for data in x{
                    if (data as! NSDictionary).object(forKey: "when") as! String != ""{
                        self.medicalSurgery.append(MedicalSurgery(json: data as! NSDictionary))
                    }
                }
            }
        }
    }
}

class CurrentMedication {
    var added_on:String = ""
    var id_current_medication:String = ""
    var id_medication:String = ""
    var medicine:String = ""
    var reason_for_taking:String = ""
    var strength:String = ""
    var usage:String = ""
    
    init(json:NSDictionary) {
        if let x = json.object(forKey: "added_on") as? String{
            self.added_on = x
        }
        if let x = json.object(forKey: "id_current_medication") as? String{
            self.id_current_medication = x
        }
        if let x = json.object(forKey: "id_medication") as? String{
            self.id_medication = x
        }
        if let x = json.object(forKey: "medicine") as? String{
            self.medicine = x
        }
        if let x = json.object(forKey: "reason_for_taking") as? String{
           self.reason_for_taking = x
        }
        if let x = json.object(forKey: "strength") as? String{
            self.strength = x
        }
        if let x = json.object(forKey: "usage") as? String{
            self.usage = x
        }
    }
}

class MedicalCondition {
    var added_on:String = ""
    var id:String = ""
    var section:String = ""
    var status:String = ""
    var title:String = ""
    var title_alias:String = ""
    var when:String = ""
    init(json:NSDictionary) {
        if let x = json.object(forKey: "added_on") as? String{
            self.added_on = x
        }
        if let x = json.object(forKey: "id") as? String{
            self.id =  x
        }
        if let x = json.object(forKey: "section") as? String{
            self.section = x
        }
        if let x = json.object(forKey: "status") as? String{
            self.status = x
        }
        if let x = json.object(forKey: "title") as? String{
            self.title = x
        }
        if let x = json.object(forKey: "title_alias") as? String{
            self.title_alias = x
        }
        if let x = json.object(forKey: "when") as? String{
            self.when = x
        }
    }
}

class MedicalSurgery {
    var added_on:String = ""
    var id:String = ""
    var section:String = ""
    var status:String = ""
    var title:String = ""
    var title_alias:String = ""
    var when:String = ""
    init(json:NSDictionary) {
        if let x = json.object(forKey: "added_on") as? String{
            self.added_on = x
        }
        if let x = json.object(forKey: "id") as? String{
            self.id =  x
        }
        if let x = json.object(forKey: "section") as? String{
            self.section = x
        }
        if let x = json.object(forKey: "status") as? String{
            self.status = x
        }
        if let x = json.object(forKey: "title") as? String{
            self.title = x
        }
        if let x = json.object(forKey: "title_alias") as? String{
            self.title_alias = x
        }
        if let x = json.object(forKey: "when") as? String{
            self.when = x
        }
    }
}

struct MedicationHeaders{
    var currentMedicationLabel:String = "Are you taking any medicines currently?"
    var drugSenstivityLabel:String = "Do you have any alergies or drug senstivity?"
    var surgeriesLabel:String = "Have you ever had surgeries or medical procedures?"
    var medicalConditionsLabel:String = "Have you ever had any medical condition?"
    var headers:[String] = []
    init() {
        self.headers = [currentMedicationLabel,drugSenstivityLabel,surgeriesLabel,medicalConditionsLabel]
    }
}
