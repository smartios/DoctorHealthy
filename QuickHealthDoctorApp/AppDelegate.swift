//
//  AppDelegate.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 18/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import CoreData
import Fabric
import Crashlytics
import UserNotifications

enum ShortcutIdentifier: String {
    case OpenSignUp
    init?(identifier: String) {
        guard let shortIdentifier = identifier.components(separatedBy: ".").last else {
            return nil
        }
        self.init(rawValue: shortIdentifier)
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    var staticpage = ""
    var chatmessages  = NSMutableArray()
    
    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation:CLLocation!
    private var reachability:Reachability!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        // Override point for customization after application launch.
        getApiToken(completionHandler: {(data) in
            
        })
        GMSServices.provideAPIKey("AIzaSyBBVXutvuWZ9s2Y42Q__PnWvx5JPmxdWzw")
        GMSPlacesClient.provideAPIKey("AIzaSyBBVXutvuWZ9s2Y42Q__PnWvx5JPmxdWzw")
        
        
       
        
        if UserDefaults.standard.object(forKey: "access_token") == nil{
            UserDefaults.standard.set("", forKey: "access_token")
        }
        //Register for remote notification
        self.registerForPushNotifications()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        
        // Check if launched from notification
        // 1
//        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
//            // 2
//            let aps = notification["aps"] as! [String: AnyObject]
//            print("=== Notification Data after launch ==== \(aps))")
//        }
        if UserDefaults.standard.object(forKey: "is_firstTime") == nil
        {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "LandngScreen") as! LandngScreen
            let rootViewController = self.window!.rootViewController as! UINavigationController
            rootViewController.isNavigationBarHidden = true
            rootViewController.setViewControllers([pushVC], animated: false)
            appDelegate.window!.rootViewController!.removeFromParentViewController()
            appDelegate.window!.rootViewController!.view.removeFromSuperview()
            appDelegate.window!.rootViewController = nil
            appDelegate.window!.rootViewController = rootViewController
        }else{
            if UserDefaults.standard.object(forKey: "user_id") != nil && UserDefaults.standard.object(forKey: "user_id")! as! String != ""
            {
//                let tempDict = (UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
//                tempDict.setObject("", forKey: "user_api_key" as! NSCopying)
//                UserDefaults.standard.set(tempDict, forKey: "user_detail")
//                UserDefaults.standard.synchronize()
//
                if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() != "doctor"
                {
                    self.locationManager.startUpdatingLocation()
                }else{
                    self.locationManager.stopUpdatingLocation()
                }
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
                let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.isNavigationBarHidden = true
                rootViewController.setViewControllers([pushVC], animated: false)
                appDelegate.window!.rootViewController!.removeFromParentViewController()
                appDelegate.window!.rootViewController!.view.removeFromSuperview()
                appDelegate.window!.rootViewController = nil
                appDelegate.window!.rootViewController = rootViewController
                pushVC.selectedIndex = 3
            }
            
        }
        return true
    }
    
    
    //MARK: <-- Check for Internet Connection -->
    func hasConnectivity() -> Bool
    {
        let reachability: Reachability = Reachability(hostName:"www.google.com")
        let networkStatus: NetworkStatus = reachability.currentReachabilityStatus()
        return networkStatus != NetworkStatus.NotReachable
    }
    
    // api_token
    func getApiToken (completionHandler:@escaping (_ data:Bool) -> Void){
        if !self.hasConnectivity(){
            supportingfuction.showMessageHudWithMessage(message: "Please check your internet connection.", delay: 2.0)
            return
        }
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
        
        let dict = NSMutableDictionary()
        dict.setObject("api@quickhealth.com", forKey: "client_id" as NSCopying)
        dict.setObject("b37201a0a2bc7bcbc69e454afa56f2e60b054e9711b855725c1daec15223aaa5", forKey: "client_secret" as NSCopying)
        dict.setObject("client_credentials", forKey: "grant_type" as NSCopying)
        dict.setObject("doctor", forKey: "scope" as NSCopying)
        
        let apiSniper = APISniper()
        apiSniper.getDataFromWebAPItoken(WebAPI.api_token,dict,{ (operation, responseObject) in
            if let dataFromServer = responseObject as? NSDictionary
            {
                print(dataFromServer)
                supportingfuction.hideProgressHudInView(view: self)
                if dataFromServer.object(forKey: "access_token") != nil && dataFromServer.object(forKey: "access_token") as! String != ""
                {
                    UserDefaults.standard.set((dataFromServer.object(forKey: "access_token") as! String), forKey: "access_token")
                    completionHandler(true)
                }
            }
        }) { (operation, error) in
            supportingfuction.hideProgressHudInView(view: self)
            print(error.localizedDescription)
            supportingfuction.showMessageHudWithMessage(message: "Due to some error we can not proceed your request.", delay: 2.0)
            completionHandler(false)
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SocketIOManager.sharedInstance.isApplicationInBackground = true
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        SocketIOManager.sharedInstance.isApplicationInBackground = false
        if UserDefaults.standard.object(forKey: "user_detail") != nil && UserDefaults.standard.object(forKey: "user_detail") is NSDictionary{
            if ((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "user_type") as! String).lowercased() == "doctor"{
                SocketIOManager.sharedInstance.establishConnection()
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        if self.currentLocation == nil{
            self.currentLocation = location
            self.updateLocationOnServer()
        }else{
           let distance = location.distance(from: self.currentLocation)
            if distance > 50{
                self.updateLocationOnServer()
            }
        }
     }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(shouldPerformActionFor(shortcutItem: shortcutItem))
    }
    
    @available(iOS 9.0, *)
    func shouldPerformActionFor(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(identifier: shortcutType) else {
            return false
        }
        return selectTabBarItemFor(shortcutIdentifier: shortcutIdentifier)
    }
    
    private func selectTabBarItemFor(shortcutIdentifier: ShortcutIdentifier) -> Bool {
        guard let myTabBar = self.window?.rootViewController as? UINavigationController else {
            return false
        }
        switch shortcutIdentifier {
        case .OpenSignUp:
            self.navigateToSignup()
            return true
        }
    }
    
    func navigateToSignup(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignupView") as! SignupView
        let topView  = UIApplication.topViewController()
        topView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        //Deeplinking used for frogot password
        if (url.scheme == "quickhealthprovider")
        {
            let mathString: String = url.absoluteString
            let numbers = mathString.components(separatedBy: ["=", "?", ","])
            print(numbers)
            if numbers[2] == "1"
            {
                presentChangePassword(user_id: numbers[3])
            }else
            {
                supportingfuction.showMessageHudWithMessage(message: "invalid Link.", delay: 2.0)
                return false
            }
            if numbers[3] != ""
            {
                UserDefaults.standard.set(numbers[3], forKey: "user_id_frgtpass")
            }
            return true
        }
        
        return true
    }
    
    func presentChangePassword(user_id:String){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let changePassVC = mainStoryboard.instantiateViewController(withIdentifier: "ResetPasswordView") as! ResetPasswordView
        let rootViewController = self.window!.rootViewController as! UINavigationController
        changePassVC.user_id = user_id
        rootViewController.pushViewController(changePassVC, animated: true)
    }
    
    
    //Function to update location
    func updateLocationOnServer(){
            let dict = NSMutableDictionary()
            dict.setObject(UserDefaults.standard.object(forKey: "user_id")! as! String, forKey: "id_user" as NSCopying)
            dict.setObject("\(self.currentLocation.coordinate.longitude)", forKey: "longitude" as NSCopying)
            dict.setObject("\(self.currentLocation.coordinate.latitude)", forKey: "latitude" as NSCopying)
            dict.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "user_api_key")!)", forKey: "user_api_key")
            let apiSniper = APISniper()
            
            apiSniper.getDataFromWebAPI(WebAPI.update_nurse_location, dict, { (operation, responseObject) in
                if let dataFromServer = responseObject as? NSDictionary{
                    print(dataFromServer)
                    
                    //status
                    if dataFromServer.object(forKey: "status") != nil && dataFromServer.object(forKey: "status") as! String != "" && dataFromServer.object(forKey: "status") as! String == "success"{
                        
                    }
                }
            }){ (operation, error) in
                
            }
    }
    

}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}



