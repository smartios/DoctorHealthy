//
//  VedioCallViewController.swift
//  QuickHealthDoctorApp
//
//  Created by Bhoopendra on 19/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import OpenTok
import AVFoundation

class VideoCallViewController: UIViewController,PulsingCallDelegate {
    
    var session: OTSession! //epresents an OpenTok session and includes methods for interacting with the session.
    var publisher: OTPublisher? //uses the device's camera and microphone, to publish a stream OpenTok session.
    var subscriber: OTSubscriber? //uses the device's camera and microphone, to subscribe a stream OpenTok session.
    var subscriberView:UIView!
    var publisherView:UIView!
    
    //Local variables
    @IBOutlet var videoBtnView: VideoActionButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var callDuration: UILabel!
    @IBOutlet var patientID: UILabel!
    @IBOutlet var patientName: UILabel!
    @IBOutlet var cornerVedioView: UIView!
    @IBOutlet var prescriptionBtnView: PrescriptionBtnView!
    
    var apointmentDict:NSDictionary!
    var chatMessages = ChatMessageGroup()
    var prescriptionData = Prescription()
    var callDurationTimer:Timer!
    var timeRemaining = 0
    var totalCallDuration = 20 * 60
    var id_call = ""
    var isPaidAvailable:Bool = false
    var amount = "0"
    
    //MARK:- Viewcontrller life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.videoBtnView.isCallConnected = false
        self.videoBtnView.isHidden = true
        self.videoBtnView.delegate = self
       
        self.prescriptionBtnView.isHidden = true
        self.prescriptionBtnView.delegate = self
        
        timeRemaining = totalCallDuration
        
        if SocketIOManager.sharedInstance.isConnectedWithSocket == SocketIOClientStatus.notConnected{
            SocketIOManager.sharedInstance.isApplicationInBackground = false
            if UserDefaults.standard.object(forKey: "user_detail") != nil && UserDefaults.standard.object(forKey: "user_detail") is NSDictionary{
                SocketIOManager.sharedInstance.establishConnection()
            }
        }else{
            //Get Tokbox API token and session id
            self.getTokboxApiSessionID()
        }
        
        //set patient detial on view
        self.setPatientDetail()
        
        //Present pulsing screen from superview
        self.addCallingScreenToView()
        
//        //Connect to the tocbox server
//        self.connectToAnOpenTokSession()
        
        
        //Add tap gesture on self to get if user tapped on the screen
        self.addTapGestureOnScreen()
        
        self.addNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        if self.timeRemaining == 0{
            self.disablebuttonOnViewExceptPrescription()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func addNotifications(){
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(getTokboxApiSessionID), name:NSNotification.Name(rawValue: "getTokBoxToken"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectToAnOpenTokSession), name:NSNotification.Name(rawValue: "callAccepted"), object: nil)
    }
    
    func removeNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getTokBoxToken"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "callAccepted"), object: nil)
    }
    
    //MARK:- Setup Tokbox token and session
    //MARK- Get tokbox token form socket
    func getTokboxApiSessionID(){
        if self.subscriber == nil && apointmentDict != nil{
            SocketIOManager.sharedInstance.sendVideoCallRequest(id_appointment: apointmentDict.object(forKey: "id_appointment") as! String, completionHandler: { (data) in
                print(data)
                if let tempDict = (data as! NSArray)[0] as? NSDictionary{
                    self.setTokboxSessionIdAndToken(data: tempDict)
                }
                
            })
        }else{
            //Connect to the tocbox server
            self.connectToAnOpenTokSession()
        }
    }
    //MARK-
    func setTokboxSessionIdAndToken(data:NSDictionary){
        if self.session == nil{
            kApiKey = data.object(forKey: "tokbox_api_key") as! String
            kSessionId = data.object(forKey: "session_id") as! String
            kToken = data.object(forKey: "token") as! String
            id_call  = data.object(forKey: "id_call") as! String
//            //Connect to the tocbox server
        }
    }
    
    func setPatientDetail(){
        if apointmentDict != nil{
            patientName.text = (apointmentDict.object(forKey: "patient_name") as! String)
            patientID.text = (apointmentDict.object(forKey: "patient_unique_number") as! String)
        }
    }
    
    //Present pulsing screen in superview
    func addCallingScreenToView(){
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let callingView = tabStoryboard.instantiateViewController(withIdentifier: "WaitingRoomViewController") as! WaitingRoomViewController
        callingView.delegate = self
        callingView.patientDetail = self.apointmentDict
        self.present(callingView, animated: false, completion: nil)
    }
    
    //Dismiss pulsing screen from superview after call connect
    func removeCallingScreenFromView(){
        
        self.removeNotifications()
        
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    //remove chat screen if openedon tap
    func removeChildController(){
        var isChildPresent = false
        for vc in self.childViewControllers{
            if vc is WaitingChatRoomViewController || vc is PrescriptionFormViewController{
                isChildPresent = true
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    vc.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
                }) { _  in
                    vc.view.removeFromSuperview()
                    vc.removeFromParentViewController()
                }
             }
        }
        if isChildPresent && self.errorLabel.text != "Opps, looks like the patient is experiencing technical difficulties. \n Please wait for them to rejoin the call..." && self.timeRemaining != 0{
           self.switchVideoStreamView(smallView: self.publisherView, largeView:self.subscriberView , isLargeNeeded: true)
        }
    }
    
    func addTapGestureOnScreen(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showHideButtonViewAddSelector))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func showHideButtonViewAddSelector(){
        self.removeChildController()
        //Set the buttonview isHidden property to false when user tapped on the screen
        if self.timeRemaining != 0{
            self.videoBtnView.isHidden = false
            self.startHideTimer()
        }
    }
    
    func startHideTimer(){
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(self.setisHiddenForVideoBtnView), with: self, afterDelay: 5.0)
    }
    
    func setisHiddenForVideoBtnView(){
        self.videoBtnView.isHidden = true
    }
    
    func connectToAnOpenTokSession() {
        if self.subscriber == nil{
            session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
            var error: OTError?
            session.connect(withToken: kToken, error: &error)
            if error != nil {
                print(error!)
            }
        }
    }
    
    func endCallClicked() {
        var error: OTError?
        if self.publisher != nil{
            self.session.unpublish(self.publisher!, error: &error)
        }
        if self.session != nil{
            self.session.disconnect(&error)
        }
        
        self.removeNotifications()
        
        if SocketIOManager.sharedInstance.isConnectedWithSocket == SocketIOClientStatus.notConnected{
            SocketIOManager.sharedInstance.isApplicationInBackground = false
            if UserDefaults.standard.object(forKey: "user_detail") != nil && UserDefaults.standard.object(forKey: "user_detail") is NSDictionary{
                SocketIOManager.sharedInstance.establishConnection()
                
                supportingfuction.hideProgressHudInView(view: self)
                
                supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please wait...", labelText: "Cancelling")
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.endCallClicked), name:NSNotification.Name(rawValue: "call_cancelled_Socket_NotConnected"), object: nil)
            }
        }else{
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "call_cancelled_Socket_NotConnected"), object: nil)
            
            supportingfuction.hideProgressHudInView(view: self)
            
            SocketIOManager.sharedInstance.sendCancelCallRequest(id_appointment: apointmentDict.object(forKey: "id_appointment") as! String, id_patient: apointmentDict.object(forKey: "id_patient") as! String) { (data) in
                print(data)
            }
           self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func endCallAfterCallConnect(){
        var error: OTError?
        if self.publisher != nil{
            self.session.unpublish(self.publisher!, error: &error)
        }
        self.session.disconnect(&error)
        
        self.endCallWebService()
        
        self.removeNotifications()
        
        self.disablebuttonOnViewExceptPrescription()
    }
    
    func showExtendTimerPopup(){
        let extendVideoCallVC = ExtendVideoCallViewController()
        
        self.view.addSubview(extendVideoCallVC.view)
        
        extendVideoCallVC.delegate = self
        
        extendVideoCallVC.isPaidAvailable = self.isPaidAvailable
        
        extendVideoCallVC.view.frame = CGRect.zero
        
        extendVideoCallVC.view.center = self.view.center
        
        extendVideoCallVC.popCotainerView.isHidden = true
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
            
            extendVideoCallVC.view.frame = self.view.bounds
            
        }) { _  in
            
            extendVideoCallVC.popCotainerView.isHidden = false
            
        }
        
        self.addChildViewController(extendVideoCallVC)
    }
    
    /// Switch stream display destination in view
    ///
    /// - Parameters:
    ///   - smallView: the stream view need to display in corner of the screen in small view
    ///   - largeView: stream to be displayed in whole the screen
    ///   - isLargeNeeded: if need large screen the pass true other wiese false
    func switchVideoStreamView(smallView:UIView,largeView:UIView,isLargeNeeded:Bool){
        smallView.removeFromSuperview()
        largeView.removeFromSuperview()
        //set view on corner view
        smallView.frame = CGRect(x: 0, y: 0, width: self.cornerVedioView.frame.size.width, height: self.cornerVedioView.frame.size.height)
        self.cornerVedioView.addSubview(smallView)
        if isLargeNeeded{
            largeView.frame = UIScreen.main.bounds
            self.view.insertSubview(largeView, at: 1)
        }
    }
    
    //Start the duration timer after call connect
    func startCallDurationTimer(){
        if callDurationTimer == nil{
            callDurationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
            timeRemaining = totalCallDuration
        }
    }
    
    func timerRunning() {
        
        timeRemaining -= 1
        
        callDuration.text = self.timeString(time: TimeInterval(timeRemaining))
        
        if timeRemaining == 6*60{
            
            self.Check_Next_Slot_Webservice()
            
        }else if timeRemaining == 5*60{
            
            self.removeChildController()
            
            self.showExtendTimerPopup()
            
        }else if timeRemaining == 0{
            
            callDurationTimer.invalidate()
            
            callDurationTimer = nil
            
            self.sendEndCallMessage()
            
            self.perform(#selector(self.endCallAfterCallConnect), with: self, afterDelay: 1.0)
        }
    }
    
    /// Get time string with hours,minutes and seconds
    ///
    /// - Parameter time: Timeinterval in seconds
    /// - Returns: time string
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours,minutes,seconds)
    }
    
    @IBAction func infoBtnClicked(_ sender: UIButton) {
//        self.endCallClicked()
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabbarStoryboard", bundle: nil)
        let vc = tabStoryboard.instantiateViewController(withIdentifier: "PatientDetailView") as! PatientDetailView
        vc.data = self.apointmentDict.mutableCopy() as! NSMutableDictionary
        vc.data.setObject(self.apointmentDict.object(forKey: "id_appointment")!, forKey: "appointment_id" as NSCopying)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - OTSessionDelegate callbacks
extension VideoCallViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")
        
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        guard let publish = OTPublisher(delegate: self, settings: settings) else {
            return
        }
        self.publisher = publish
        self.publisher?.publishVideo = !(self.videoBtnView.stopStreamBtn.isSelected)
        var error: OTError?
        session.publish(self.publisher!, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let publisherV = self.publisher?.view else {
            return
        }
        self.publisherView = publisherV
        self.publisherView.frame = CGRect(x: 0, y: 0, width: self.cornerVedioView.frame.size.width, height: self.cornerVedioView.frame.size.height)
        self.cornerVedioView.addSubview(publisherView)
        
        self.errorLabel.isHidden = false
        
        self.errorLabel.text = "Waiting for patient to join the call..."
        
        //Remove pulsing halo screen
        self.removeCallingScreenFromView()
        //Start the call timer after the patient connected to call
        self.startCallDurationTimer()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
        print(error.code == 1022)
        if error.code == 1022{
            supportingfuction.showMessageHudWithMessage(message: "Due to some technical difficulty call can not be connected. Please try again.", delay: 2.0)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("A stream was created in the session.")
        
        subscriber = OTSubscriber(stream: stream, delegate: self)
        
        guard let subscriber = subscriber else {
            return
        }
        var error: OTError?
        session.subscribe(subscriber, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        if self.subscriberView != nil{
            self.errorLabel.text = "Opps, looks like the patient is experiencing technical difficulties. \n Please wait for them to rejoin the call..."
            self.subscriberView.removeFromSuperview()
        }else{
            self.errorLabel.text = "Patient joined the call. Patient vedio feed will present shortly..."
        }
        
        guard let subscriberV = subscriber.view else {
            return
        }
        self.subscriberView = subscriberV
        
        self.subscriberView.frame = UIScreen.main.bounds
        
        self.videoBtnView.isCallConnected =  true
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        
        if self.subscriberView != nil{
         self.subscriberView.removeFromSuperview()
        }
        
        print("A stream was destroyed in the session.")
        self.errorLabel.isHidden = false
        self.errorLabel.text = "Opps, looks like the patient is experiencing technical difficulties. \n Please wait for them to rejoin the call..."
        self.removeChildController()
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        print("receivedSignalType ===== \(type ?? "")")
        print("receivedSignalstring ===== \(string ?? "")")
        var dict = NSMutableDictionary()
        dict = CommonValidations.convertToDictionary(text: string!).mutableCopy() as! NSMutableDictionary
        if type! == "endCall"{
            if dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                let alertContoller = UIAlertController(title: "Alert!", message: "Call is diconnected from patient end.", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                    self.endCallAfterCallConnect()
                }
                alertContoller.addAction(yesAction)
                self.present(alertContoller, animated: true, completion: nil)
            }
        }else if  type! == "streamStopped"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil && dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("Patient Stop the stream")
                    self.switchVideoStreamView(smallView: self.publisherView, largeView: self.subscriberView, isLargeNeeded: false)
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Patient stopped sharing the video."
                }
            }
        }else if  type! == "streamReconnected"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("Patient resume the stream")
                    self.errorLabel.isHidden = true
                    self.errorLabel.text = ""
                    self.switchVideoStreamView(smallView: self.publisherView, largeView: self.subscriberView, isLargeNeeded: true)
                }
            }
        }else if  type! == "ismuted_true"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("Patient stop the audio")
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Patient  muted this call."
                }
            }
        }else if  type! == "ismuted_false"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    print("Patient resume the audio")
                    self.errorLabel.isHidden = true
                    self.errorLabel.text = ""
                }
            }
        }else if  type! == "paidCallExtended"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    
                }
            }
        }else if  type! == "paidCallNotExtended"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    
                }
            }
        }else if  type! == "extendPaidCall"{
            if dict.count > 0 {
                if dict.object(forKey: "user_id") != nil &&  dict.object(forKey: "user_id") as! String != (UserDefaults.standard.object(forKey: "user_id") as! String){
                    
                }
            }
        }else{
            if dict.count>0{
                self.chatMessages.messages.append(Message(json: dict))
                
                //Add chat controller on the view on message group
                if let vc = self.childViewControllers.last as? WaitingChatRoomViewController{
                    vc.messagesData = self.chatMessages
                }else{
                    self.removeChildController()
                    self.chatBtnClicked()
                }
            }
        }
    }
}

// MARK: - OTPublisherDelegate callbacks
extension VideoCallViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("The publisher failed: \(error)")
    }
}

// MARK: - OTSubscriberDelegate callbacks
extension VideoCallViewController: OTSubscriberDelegate {
    
    public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber did connect to the stream.")
        self.errorLabel.isHidden = true
        self.errorLabel.text = ""
        //Insert the patient view in screen
        view.insertSubview(self.subscriberView, at: 1)
    }
    
    public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("The subscriber failed to connect to the stream.")
    }
    
    func subscriberDidReconnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber reconnectconnect to the stream.")
    }
    
    func subscriberDidDisconnect(fromStream subscriber: OTSubscriberKit) {
        print("The subscriber disconnect to the stream.")
        self.subscriberView.removeFromSuperview()
    }
}

// MARK: - VideoActionButtonDelegate callbacks
extension VideoCallViewController: VideoActionButtonDelegate {
    
    //Mute or Unmute microphone
    func muteUnmutebtnClicked(value:Bool) {
        self.startHideTimer()
        var error:OTError?
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        if value == true{
            self.session.signal(withType: "ismuted_true", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            print("is_mute_true")
        }else{
            self.session.signal(withType: "ismuted_false", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            print("is_mute_false")
        }
        self.publisher?.publishAudio = !value
    }
    
    //Toggle betwen front and back camera
    func switchCameraBtnClicked() {
        self.startHideTimer()
        if publisher?.cameraPosition == .back{
            publisher?.cameraPosition = AVCaptureDevicePosition.front // back camera
        }else{
            publisher?.cameraPosition = AVCaptureDevicePosition.back
        }
    }
    
    //Stop to send video stream
    func stopSendingStreamBtnClicked(value:Bool) {
        self.startHideTimer()
        var error:OTError?
        
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        
        if value == true{
            self.session.signal(withType: "streamStopped", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            print("streamStopped")
        }else{
            self.session.signal(withType: "streamReconnected", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
            print("streamReconnected")
        }
        publisher?.publishVideo = !value
    }
    
    //Disconnect the call from server
    func disconnectCallBtnClicked() {
        
        let alertContoller = UIAlertController(title: "Alert!", message: "Are you sure to disconnect call?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            self.sendEndCallMessage()
            if self.subscriber != nil{
                self.perform(#selector(self.endCallAfterCallConnect), with: self, afterDelay: 1.0)
            }else{
                self.perform(#selector(self.endCallClicked), with: self, afterDelay: 1.0)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertContoller.addAction(yesAction)
        alertContoller.addAction(cancelAction)
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    //Add the chat view on screen
    func chatBtnClicked() {
        let waitingChatRoomVC = WaitingChatRoomViewController()
        waitingChatRoomVC.view.tag = -786
        waitingChatRoomVC.messagesData = self.chatMessages
        waitingChatRoomVC.delegate = self
        self.view.addSubview(waitingChatRoomVC.view)
        
        waitingChatRoomVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            waitingChatRoomVC.view.frame = CGRect(x: 0, y: 162, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 162)
            
        }) { _  in
            if self.timeRemaining != 0{
                self.switchVideoStreamView(smallView: self.subscriberView, largeView: self.publisherView, isLargeNeeded: false)
            }else{
                self.switchVideoStreamView(smallView: self.publisherView, largeView: self.subscriberView, isLargeNeeded: false)
            }
        }
        self.addChildViewController(waitingChatRoomVC)
    }
    
    //Add prescription form on screen
    func prescriptionBtnClicked() {
        let prescriptionVC = PrescriptionFormViewController()
        prescriptionVC.prescriptionData = self.prescriptionData
        prescriptionVC.delegate = self
        self.view.addSubview(prescriptionVC.view)
        
        prescriptionVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            prescriptionVC.view.frame = CGRect(x: 0, y: 162, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 162)
            
        }) { _  in
            if self.timeRemaining != 0{
                self.switchVideoStreamView(smallView: self.subscriberView, largeView: self.publisherView, isLargeNeeded: false)
            }else{
//                self.switchVideoStreamView(smallView: self.publisherView, largeView: self.subscriberView, isLargeNeeded: false)
            }
        }
        self.addChildViewController(prescriptionVC)
        
    }
    
    //Diable the buttons after end call
    func disablebuttonOnViewExceptPrescription(){
        self.removeChildController()
        self.errorLabel.isHidden = false
        self.errorLabel.text = "Call ended. Please submit the prescription form."
        self.videoBtnView.isHidden = true
        self.prescriptionBtnView.isHidden = false
        self.cornerVedioView.isHidden = true
        if self.callDurationTimer != nil{
            self.callDurationTimer.invalidate()
            callDurationTimer = nil
        }
        
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
        
        if self.subscriberView != nil{
          self.subscriberView.removeFromSuperview()
        }
        if self.publisherView != nil{
            self.publisherView.removeFromSuperview()
        }
        
    }
    
}
// MARK: - WaitingChatRoomDelegate callbacks
extension VideoCallViewController: WaitingChatRoomDelegate,ExtendVideoDelegate,PrescriptionFormDelegate {
    
    //Submit prescription data on web
    func submitPrescriptionFormData() {
        if self.callDurationTimer != nil{
            let alertContoller = UIAlertController(title: "Alert!", message: "Submitting the prescription will result in call end. Are you sure you want to submit?", preferredStyle: .alert)
            let proceedAction = UIAlertAction(title: "Proceed", style: .default) { (alertAction) in
                
                self.submitPrescriptionDataOnServer()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertContoller.addAction(cancelAction)
            alertContoller.addAction(proceedAction)
            self.present(alertContoller, animated: true, completion: nil)
        }else{
            self.submitPrescriptionDataOnServer()
        }
    }
    
    //Send message to patien on ongoing Call
    func messageToSend(jsonString: String) {
        var error: OTError?
        session.signal(withType: "message", string: jsonString, connection: nil, retryAfterReconnect: true, error: &error)
    }
    
    //Extend call feature
    func didSelectOnExtendVideoAction(_ action: ExtendVideoAction){
        var error: OTError?
        if action == .Free{
            self.session.signal(withType: "extendFreeCall", string: "extendFreeCall", connection: nil, retryAfterReconnect: true, error: &error)
            self.timeRemaining = self.timeRemaining + 5*60
            self.totalCallDuration = totalCallDuration + 5*60
        }else if action == .Paid{
            self.sendExtedPaidCallRequest(self.amount)
        }else{
            //No thanks action handling
        }
    }
    
   
    func sendEndCallMessage(){
        var error: OTError?
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
            self.session.signal(withType: "endCall", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
        }catch let error as NSError{
            print(error.description)
        }
    }
    
    func sendExtedPaidCallRequest(_ amount:String){
        var error: OTError?
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
        recieverDict.setValue(amount, forKey: "paidCallCharge")
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
            self.session.signal(withType: "extendPaidCall", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
        }catch let error as NSError{
            print(error.description)
        }
    }
    
}

