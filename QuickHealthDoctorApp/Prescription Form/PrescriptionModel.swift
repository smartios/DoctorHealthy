//
//  PrescriptionModel.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 21/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import Foundation

class Prescription{
    var prescription:String = ""
    var lab_test_array:[Labtest] = []
    var drug_array:[Drugs] = []
}

class Drugs{
    var drug_name = ""
    var type = ""
    var quantity = ""
    var dosage = ""
    var dosage_value = ""
    var best_time = ""
    var remarks = ""
    var price_per_piece = ""
    var price_per_box = ""
    var drug_list_id = ""
    var days = ""
}

class Labtest{
    var id_lab_test = ""
    var title = ""
    var status = ""
    var price = ""
    var added_on = ""
    var updated_on = ""
    var test_name = ""
    init(json:NSDictionary) {
        self.id_lab_test = json.object(forKey: "id_lab_test") as! String
        self.title = json.object(forKey: "title") as! String
        self.test_name = json.object(forKey: "title") as! String
        self.status = json.object(forKey: "status") as! String
        self.price = json.object(forKey: "price") as! String
        self.added_on = json.object(forKey: "added_on") as! String
        self.updated_on = json.object(forKey: "updated_on") as! String
    }
    
}

class PrescriptionMethods{
    class func getLabTestDictonary(data:Labtest)-> NSDictionary{
        let dict = NSMutableDictionary()
        dict.setObject(data.id_lab_test, forKey: "id_lab_test" as NSCopying)
        dict.setObject(data.title, forKey: "title" as NSCopying)
        dict.setObject(data.status, forKey: "status" as NSCopying)
        dict.setObject(data.price, forKey: "price" as NSCopying)
        dict.setObject(data.added_on, forKey: "added_on" as NSCopying)
        dict.setObject(data.updated_on, forKey: "updated_on" as NSCopying)
        return dict as NSDictionary
    }
    
    class func getDrugsArrary(data:[Drugs])->(data:NSArray,error:Bool){
        var drugsArray:[NSDictionary] = []
        for item in data{
            if item.drug_name != "" || item.quantity != "" || item.dosage != "" || item.best_time != "" || item.remarks != ""{
                if item.drug_name == "" || item.quantity == "" || item.dosage == "" || item.best_time == "" || item.remarks == ""{
                    return (drugsArray as NSArray,true)
                }
            }
            let tempDict = ["drug_name":item.drug_name,
                            "type":item.type,
                            "quantity":item.quantity,
                            "dosage":item.dosage_value,
                            "best_time":item.best_time,
                            "remarks":item.remarks,
                            "price_per_piece":item.price_per_piece,
                            "price_per_box":item.price_per_box,"drug_list_id":item.drug_list_id ,"days":item.days]
            drugsArray.append(tempDict as NSDictionary)
        }
        return (drugsArray as NSArray,false)
    }
    
    
    class func getLabTestArrary(data:[Labtest])->NSArray{
        var labTestArray:[NSDictionary] = []
        for item in data{
            let tempDict = ["test_name":item.test_name,
                            "price":item.price,"id_lab_test":item.id_lab_test ]
            labTestArray.append(tempDict as NSDictionary)
        }
        return labTestArray as NSArray
    }
}
