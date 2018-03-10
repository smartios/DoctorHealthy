//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    internal private(set) var status = SocketIOClientStatus.notConnected
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://quickhealth4u.com:9042")! as URL, config:[.reconnects(true), .reconnectAttempts(5), .reconnectWait(20), .log(false), .forcePolling(false), .forceWebsockets(false),.forceNew(false),.secure(false),.selfSigned(false)]);
//    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://192.168.45.67:3212/")! as URL, config:[.reconnects(true), .reconnectAttempts(5), .reconnectWait(20), .log(false), .forcePolling(false), .forceWebsockets(false),.forceNew(false),.secure(false),.selfSigned(false)]);
    
    
    var isApplicationInBackground = false
    var isConnectedWithSocket = SocketIOClientStatus.notConnected
    
    
    override init() {
        super.init()
    }
    
    
    func establishConnection(){
        self.closeConnection()
        print("establishing connection...")
        socket.connect()
    }
    
    func closeConnection()
    {
        print("closing connection...")
        socket.disconnect()
    }
    
    
    func connectToServerWithNickname(nickname: String, completionHandler: (_ userList: [[String: AnyObject]]?) -> Void)
    {
        let params = NSMutableDictionary()
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "first_name")!)", forKey: "first_name")
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "last_name")!)", forKey: "last_name")
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "id_user")!)", forKey: "user_id")
        params.setValue("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "access_token")!)", forKey: "access_token")
        params.setValue("\(WebAPI.BASE_URLs)connect-doctor", forKey: "patient_redirect_url")
        if(params.count > 0){
            socket.emitWithAck("join", params).timingOut(after: 6, callback: { (data) in
                print(data)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getTokBoxToken"), object: nil)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "call_cancelled_Socket_NotConnected"), object: nil)
                
                if (data as NSArray).object(at: 0) is NSString == true{
                    SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: "", completionHandler: { (userList) -> Void in  })
                    print("=====Socket Reconnected....")
                    return
                }
                print("=====Socket Connected....")
            })
        }
    }
    
    //MARK:- Function to send videocall request
    
    func sendVideoCallRequest(id_appointment:String,completionHandler:@escaping (_ data:Any) -> Void)
    {
        let dataDict = NSMutableDictionary()
        dataDict.setObject(id_appointment, forKey: "id_appointment" as NSCopying)
        dataDict.setObject("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "access_token")!)", forKey: "access_token" as NSCopying)
        print("====get tock box token request sent")
        socket.emitWithAck("doctor_initiate_call",dataDict).timingOut(after: 0, callback: { (data) in
            print("====get tock box token request callback received")
            completionHandler(data)
        })
    }
    
    func sendExtendPaidCallRequest(id_appointment:String,completionHandler:@escaping (_ data:Any) -> Void){
        let dataDict = NSMutableDictionary()
        dataDict.setObject(id_appointment, forKey: "id_appointment" as NSCopying)
        dataDict.setObject("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "access_token")!)", forKey: "access_token" as NSCopying)
        print("====get tock box token request sent")
        socket.emitWithAck("doctor_initiate_extend_call",dataDict).timingOut(after: 0, callback: { (data) in
            print("====get tock box token request callback received")
            completionHandler(data)
        })
    }
    
    func sendCancelCallRequest(id_appointment:String,id_patient:String,completionHandler:@escaping (_ data:Any) -> Void){
        let dataDict = NSMutableDictionary()
        dataDict.setObject(id_appointment, forKey: "id_appointment" as NSCopying)
        dataDict.setObject(id_patient, forKey: "id_patient" as NSCopying)
        dataDict.setObject("\((UserDefaults.standard.value(forKey: "user_detail") as! NSDictionary).value(forKey: "access_token")!)", forKey: "access_token" as NSCopying)
        print("====Cancel call request sent")
        socket.emitWithAck("call_cancelled",dataDict).timingOut(after: 0, callback: { (data) in
            print("====Cancel call request callback received")
            completionHandler(data)
        })
    }
    
    //Add custom listeners
    func getCallStatusFromPatient(){
        socket.on("confirm_call_accepted") { (response, SocketAckEmitter) -> Void in
            print(response)
            if let tempDict = (response as NSArray)[0] as? NSDictionary{
                CallNotification.callAcceptReject(tempDict)
            }
        }
    }
}
