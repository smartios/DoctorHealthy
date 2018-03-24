//
//  Appdelegate+Notification.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 28/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationType:String {
    case Appointment_Booking = "appointment_booking_notification"
    case Nurse_Alloted = "nurse_allotment_notifications"
    case Call_Rejected = "call_rejected"
    case Call_Accepted = "call_accepted"
    case Call_Reminder = "call_reminder"
    case Extend_Payment = "extend_payment_notification"
}

extension AppDelegate{
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let deviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        print("Device Token: \(deviceToken)")
        UserDefaults.standard.set("\(deviceToken)", forKey: "device_token")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        UserDefaults.standard.set("", forKey: "device_token")
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        self.handleNotifiaction(notificationData: aps as NSDictionary)
    }
    
    //Handle Notifiaction
    func handleNotifiaction(notificationData:NSDictionary){
        print("notificationData=====\(notificationData)")
        if notificationData.object(forKey: "notification_type") as! String == NotificationType.Appointment_Booking.rawValue{
            AppointmentNotification.newAppointmentBooking(notificationData)
        }else if notificationData.object(forKey: "notification_type") as! String == NotificationType.Nurse_Alloted.rawValue{
            AppointmentNotification.newAppointmentBooking(notificationData)
        }else if notificationData.object(forKey: "notification_type") as! String == NotificationType.Call_Rejected.rawValue{
            let tempDict = NSMutableDictionary(dictionary: notificationData)
            tempDict.setObject("false", forKey: "call_accepted" as NSCopying)
            CallNotification.callAcceptReject(tempDict)
        }else if notificationData.object(forKey: "notification_type") as! String == NotificationType.Call_Accepted.rawValue{
            let tempDict = NSMutableDictionary(dictionary: notificationData)
            tempDict.setObject("true", forKey: "call_accepted" as NSCopying)
            CallNotification.callAcceptReject(tempDict)
        }else if notificationData.object(forKey: "notification_type") as! String == NotificationType.Call_Reminder.rawValue{
            CallNotification.callReminder(notificationData)
        }else if notificationData.object(forKey: "notification_type") as! String == NotificationType.Extend_Payment.rawValue{
            CallNotification.callExtendPaymetReceived(notificationData)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 1
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as! [String: AnyObject]
        self.handleNotifiaction(notificationData: aps as NSDictionary)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert,.badge,.sound])
        
    }
}
