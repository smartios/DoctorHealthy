//
//  LoginView.swift
//  getAvis
//
//  Created by SS142 on 01/08/16.
//  Copyright © 2016 SS142. All rights reserved.
//

import Foundation



let appDelegate = UIApplication.shared.delegate as! AppDelegate
let access_token = UserDefaults.standard.object(forKey: "access_token") as! String
// Replace with your OpenTok API key
var kApiKey = "46062412"
// Replace with your generated session ID
var kSessionId = "2_MX40NjA2MjQxMn5-MTUxOTI3NjQ0Mzk3MH54a1lhNjY0Sld3bHFRVkYrdUZDRlNQYnR-fg"
// Replace with your generated token
var kToken = "T1==cGFydG5lcl9pZD00NjA2MjQxMiZzZGtfdmVyc2lvbj1kZWJ1Z2dlciZzaWc9YzA2YzI4OGU2ZDU4NjQ2ZGU1N2QzYjkzZWI1MDNiMDA0MTg4N2UzYzpzZXNzaW9uX2lkPTJfTVg0ME5qQTJNalF4TW41LU1UVXhPVEkzTmpRME16azNNSDU0YTFsaE5qWTBTbGQzYkhGUlZrWXJkVVpEUmxOUVluUi1mZyZjcmVhdGVfdGltZT0xNTE5Mjc2NDQzJnJvbGU9bW9kZXJhdG9yJm5vbmNlPTE1MTkyNzY0NDMuOTc2NzEwMTI0MTE5NzEmZXhwaXJlX3RpbWU9MTUyMTg2ODQ0Mw=="

struct WebAPI {
    
    
    
    //Development URL's
//    static let BASE_URL = "https://quickhealth4u.com/develop/webservice/"
//    static let BASE_URLs = "https://quickhealth4u.com/develop/"

    // Staging Server
    
//    static let BASE_URL = "https://quickhealth4u.com/webservice/"
//    static let BASE_URLs = "https://quickhealth4u.com/"
    
//Local host IP
//
    static let BASE_URLs = "http://192.168.5.76/quickhealth/"
    static let BASE_URL = "http://192.168.5.76/quickhealth/webservice/"
    
    let NoInternetConnection = "Please check your internet connection."
    
    static let api_token = "oauth2/token"
    static let signUp = "quick_health_career"
    static let login_webmethod = "login"
    static let forgot_password = "forgot_password"
    static let reset_password = "reset_password"
    static let change_password = "change_password"
    
    static let otp_webmethod = "verify_otp"
    static let resendotp_webmethod = "resend_otp"
    static let contact_us = "contact_us"
    static let FAQ_webMethod = "faq_data"
    static let Get_country_code = "country_code"
    static let list = "list"
    
    static let static_page = "static_page"
    static let slot_list = "slot_list"
    static let doctor_availability = "doctor_availability"
    static let save_availability = "save_availability"
    static let medication = "medication"
    static let edit_medical_history = "edit_medical_history"
    static let upload_document = "upload_document"
    static let inbox_listing = "inbox"
    static let appointment_list = "appointment_list"
    static let appointment_detail = "appointment_detail"
    static let physical_stats = "physical_stats"
    static let physical_stats_edit = "physical_stats_edit"
    static let user_profile = "user_profile"
    static let family_history = "family_history"
    static let family_history_edit = "family_history_edit"
    static let view_family_history = "view_family_history"
    static let COUNTRY_LIST = "getAllCountry"
    static let STATE_LIST = "getState"
    static let CITY_LIST = "getCity"
    static let CUSTOMER_LOGIN = "customer_login"
    static let CUSTOMER_SIGNUP = "customer_registration"
    static let CUSTOMER_OTP = "mobile_verification"
    static let FORGOT_PASSWORD = "forgot_password"
    static let REFRESH_TOKEN = "refresh_token"
    static let RESEND_SMS = "resend_otp"
    static let EDIT_PROFILE = "edit_profile"
    static let ADD_PAYMENT_CARD = "add_payment_card"
    static let VIEW_CUSTOMER_PROFILE = "view_customer_profile"
    static let GET_CUSTOMER_CARD = "get_customer_card"
    static let DELETE_PAYMENT_CARD = "delete_payment_card"
    static let MARK_DEFAULT_CARD = "mark_default_card"
    static let COMMON_DATA = "get_common_data"
    static let GET_STATE_CITY = "getStateCity"
    static let GET_SP_INFO = "provider_info"
    static let GET_FIND_CATEGORY = "find"
    static let EXPLORE = "explore"
    static let POST_COMMENTS = "post_comments"
    static let POST_LIKE = "post_like"
    static let GET_SP_SERVICE_LIST = "get_servicelist"
    static let SERVICE_DETAIL = "service_detail"
    static let AVAILABLE_BOOKING_SLOT = "available_booking_slot"
    static let CASH_DOLLAR_INFO = "cash-dollar-info"
    static let FIND_PROVIDER_LIST = "find-providerlist"
    static let SEARCH_KEYWORD_LIST = "search-keywords-list"
    static let SERVICE_BOOKING = "service-booking"
    static let SEARCH_AVAILABILITY = "service-availability"
    static let REPORT_INAPPROPRIATE = "report-inappropriate"
    static let BOOKING_LIST = "booking-list"
    static let SERVICE_BOOKING_DETAIL = "service-booking-detail"
    static let CREATE_REVIEW = "create-review"
    static let MARK_AS_DEFAULT = "mark-as-default"
    static let RESCHEDULE_BOOKING = "reschedule-booking"
    static let CANCEL_BOOKING = "cancel-booking"
    static let SEND_EMAIL_RECEIPT = "send-email-receipt"
    static let NOTIFICATION_LIST = "notification-list"
    static let NOTIFICATION_ACTION = "notification-action"
    static let FOLLOW = "follow"
    static let LOGOUT = "logout"
    static let GET_GALLERY_DATA = "get-gallery-data"
    static let GET_LIKED_DATA = "get-liked-data"
    static let REVIEWLIST = "reviewslist"
    static let OTHERUSERINFO = "otherUserInfo"
    static let GET_FAVORITE_STORE = "get-favourite-store"
    static let GET_FAVORITE_WORK = "get-favourite-work"
    static let GET_FAVORITE_USERS = "get-favourite-users"
    static let GET_FAVORITE_USERS_REVIEWS = "get-favourite-users-reviews"
    static let GET_UNREAD_CHAT = "getUnreadChat"
    static let REDEEM_COUPON = "redeem-coupon"
    static let GET_REVIEW_GALLERY_DATA = "get-review-gallery-data"
    static let GET_CANCELLATION_REASON = "get_cancellation_reason"
    static let REVIEW_LIST_GRID = "reviewslist-grid"
    static let BOOKING_ACTION = "booking-action"
    static let RESEND_EMAIL_VERIFICATION = "resend_email_verification"
    static let CHECK_RESCHEDULE_BOOKING = "check_reschedule_booking"
    static let CHAT_BOOKING_LIST = "chat-booking-list"
    static let SUBMIT_CONTACT_US = "submit-contact-us"
    static let FAQ = "faq?"
    static let CHANGE_LANGUAGE = "change-language"
    static let GET_USER_LANGUAGE = "get-user-language"
    static let userProfile = "user_profile"
    static let view_nurse_uploads = "view_nurse_uploads"
    static let edit_prescription = "edit_prescription"
    static let update_nurse_location = "update_user_location"
    static let track_user = "track_user"
    static let history = "history_list"
    static let Extend_Call = "extended_call"
    static let End_call = "end-call"
    static let Prescription = "prescription"
}


let validEmail = "Please enter valid email address."
let emptyPassword = "Please enter valid password.Passwords must contain at least 8 characters."
let validPassword = "Please enter valid password.Passwords must contain at least 8 characters."
let validIdentity = "Only 9 characters are allowed. First letter should be S/T/F/G, followed by 7 digit number and last letter should be A-Z."
let PleaseWait = "Please Wait"
let Requesting = "Requesting..."
// signup msg
let enterFirstName = "Please enter first name."
let enterLastName = "Please enter last name."
let gender = "Please select gender."

let typeofProffesion = "Please select profession."
let typeofServices = "Please select services."
let licenceno = "Please enter license number."
let enterAddress = "Please enter address."
let martial = "Please enter martial status."

let lang = "Please enter language proficiency."

let entertitle = "Please enter enter title."

let shortDescription = "Please enter Short Description."

let enterDob = "Please select date of birth."
let enterCity = "Please enter city."
let enterState = "Please enter location."
let enterAreaCode = "Please enter area code."
let entercountry = "Please enter country."




let enterGender = "Please select gender."
let enterEmail = "Please enter email address."
let enterStreetAddress = "Please enter street address."
let enterIdentity = "Please enter Personal Identity Number."
let enterMobileNum = "Please enter mobile number."
let entercountryCode = "Please select country code."
let enterPassword = "Please enter Password."
let enterConfirmPass = "Please enter confirm password."
let reenterConfirmPass = "Please enter re-type password."

let selecttc = "You must accept our Terms & Conditions."
let passwordMatch = "Password and Confirm Password does not match."
let invalidDob = "Invalid date of birth."

let LicNo = "Only 7 characters are allowed. First letter should be M, followed by 5 digit number and last letter should be A-Z."

//let PleaseWait = "Please Wait"

//let Loading = "Loading..."
//
//let Requesting = "Requesting..."
//
//let Submit = "Submitting..."

//let RequestFail = "Request failed. Please try again later"

enum EButtonsBar : Int {
    case kButtonsAnswerDecline
    case kButtonsHangup
    case Incoming
    case Outgoing
}

func isvalidIdentity(IdentityStr: String) -> Bool
{
    let identityRegEx = "^[M]{1}[0-9]{5}[A-Z]{1}?$"
    
    let identityTest = NSPredicate(format:"SELF MATCHES %@", identityRegEx)
    
    return identityTest.evaluate(with: IdentityStr)
}

func isvalidPersonalIdentityNo(IdentityStr: String) -> Bool
{
    let identityRegEx = "^[STFG]{1}[0-9]{7}[A-Z]{1}?$"
    
    let identityTest = NSPredicate(format:"SELF MATCHES %@", identityRegEx)
    
    return identityTest.evaluate(with: IdentityStr)
    
    
}

func logoutUser(){
    UserDefaults.standard.set("", forKey: "user_detail")
    UserDefaults.standard.set("", forKey: "user_id")
    UserDefaults.standard.set("", forKey: "is_firstTime")
    SocketIOManager.sharedInstance.closeConnection()
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
    let navigationController = UINavigationController(rootViewController:initialViewController)
    navigationController.setNavigationBarHidden(true, animated: false)
    appDelegate.window?.rootViewController = navigationController
}

class CommonValidations: NSObject{
    
    //MARK: Validate Email
    
    class func isValidEmail(testStr:String) -> Bool{
        // println("validate calendar: \(testStr)")
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPassword(testStr:String) -> Bool
    {
        // println("validate calendar: \(testStr)")
        let passwordRegEx = "^.*(?=.{8}).*$"
        
        let passTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        return passTest.evaluate(with: testStr)
    }
    
    
    class func isValidNRIC(testStr:String) -> Bool
    {
        let nricRegEx = "^[A-Z]{1}[0-9]{7}[A-Z]{1}"
        let nrictest = NSPredicate(format: "SELF MATCHES %@", nricRegEx)
        return nrictest.evaluate(with: testStr)
    }
    
    
    //MARK: Get The Color From RGB
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
     }
    
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
    
    class func createAttributedString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor) -> NSMutableAttributedString
    {
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: fullStringColor, range: NSRange(location: 0, length: fullString.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: subStringColor, range: range)
        return attributedString
    }
    
    class func getDateStringFromDateString(date: String, fromDateString: String, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateString
        let getDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toDateString
        return dateFormatter.string(from: getDate!)
    }
    
    class func getDateStringFromDate(date: Date, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toDateString
        return dateFormatter.string(from: date)
    }
    
    class func convertToDictionary(text: String) -> NSDictionary {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as!NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return NSDictionary()
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor{
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
class StoredUserData{
    var email:NSString = NSString()
    var name: NSString = NSString()
}
extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        //
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(slide.mainViewController)
        //        }
        return viewController
    }
}
