//
//  AppDateFormat.swift
//  BZR
//
//  Created by SS-113 on 06/12/16.
//  Copyright © 2016 singsys. All rights reserved.
//

import Foundation

struct AppDateFormat {
    static func getDateStringFromDateString2(date: String, fromDateString: String, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateString
        let getDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toDateString
        return dateFormatter.string(from: getDate!)
    }
    
    static func getDateStringFromDateString(date: String, fromDateString: String, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateString
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let getDate = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toDateString
        return dateFormatter.string(from: getDate!)
    }
    
    static func getDateStringFromDate(date: Date, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toDateString
        return dateFormatter.string(from: date)
    }
    
    static func getDateFromString(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:dateString)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        
        return finalDate!
    }
    
    static func getDateWithTimeFromString(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:dateString)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        
        return finalDate!
    }

}
