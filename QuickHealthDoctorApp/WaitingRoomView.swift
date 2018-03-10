//
//  WaitingRoomView.swift
//  DAWProvider
//
//  Created by SS142 on 24/04/17.
//
//

import UIKit
import AVFoundation
import OpenTok



let kWidgetHeight = 240
let kWidgetWidth = 320
//import CoreBluetooth

class WaitingRoomView: UIViewController{
    
    lazy var session: OTSession = {
        return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
    }()
    
    //@IBOutlet weak var joinCall: UIButton!
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        return OTPublisher(delegate: self, settings: settings)!
    }()
    
    var message = ""
    var callConnect = Bool()
    var subscriber: OTSubscriber?
    var subscribeToSelf = false
    @IBOutlet weak var onlineDot: UIImageView!
    @IBOutlet weak var nextApptSecondLabel: UILabel!
    @IBOutlet weak var nextApptMainLabel: UILabel!
    @IBOutlet weak var reportMissedButton: UIButton!
    @IBOutlet var remoteUsername:UILabel!
    @IBOutlet var callStateLabel:UILabel!
    @IBOutlet var remoteVideoView:UIView!
    @IBOutlet var localVideoView:UIView!
    @IBOutlet weak var callId: UILabel!
    var callEstablished = ""
    var fromMissed = ""
    var durationTimer = Timer()
    @IBOutlet weak var profileImageCall: UIImageView!
    
    var callExtend = 10
    var callCut = false
    var  callStatusSending = ""
    var apptType = ""
    
    @IBOutlet weak var hideOverlayButton: UIButton!
    var callEndReason = false
    
    @IBOutlet weak var ImmidiatePermissionView: UIView!
    
    @IBOutlet weak var ImmidiateSlotSuccessView: UIView!
    
    @IBOutlet weak var ImmidiateSlotNotAvailableView: UIView!
    
    @IBOutlet weak var ImmidiateSlotRejectPatientView: UIView!
    
    @IBOutlet weak var nextApptPaymentSuccessView: UIView!
    
   // @IBOutlet weak var headerLabel: UILabel!
    
    //@IBOutlet weak var //tableviewHolderView: UIView!
    var gameTimer: Timer!
    var chatvc : ChatOn!
    var userInterface = UIDevice.current.userInterfaceIdiom
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    var mode = ""
    @IBOutlet weak var tableView: UITableView!
 //   @IBOutlet weak var ////tapToReturnCallLabel: UILabel!
    @IBOutlet weak var tapToReturnCall: UIButton!
    @IBOutlet weak var tapToReturnCalltwo: UIButton!
    @IBOutlet weak var secondButtonView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button3: UIButton!
   // @IBOutlet weak var //waitingLabel: UILabel!
    var viewto = ""
//@IBOutlet weak var //button6: UIButton!
   // @IBOutlet weak var //button5: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var buttonMainView: UIView!
    // var browse = UIViewController()
    var counter = 0
  //  @IBOutlet weak var //callEndView: UIView!
    var callStatus = ""
    var indexCount = 0
    var dropBool = false
    var tappedIndex = -1
    
    
    
    
    @IBOutlet weak var allergyLabel: UILabel!
    var tap =  UITapGestureRecognizer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        onlineDot.isHidden = true
        buttonMainView.isHidden = false
        callStateLabel.isHidden = false
        allergyLabel.isHidden = false
        callId.isHidden = false
      //  remoteUsername.isHidden = false
        tap =  UITapGestureRecognizer(target: self, action: #selector(WaitingRoomView.hideDocInfoView))
        hideOverlayButton?.addGestureRecognizer(tap)
        
        hideOverlayButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(WaitingRoomView.resumeVedioChange), name: NSNotification.Name(rawValue: "resumeVedioChange"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(WaitingRoomView.callStatusSubmit), name: NSNotification.Name(rawValue: "callStatusSubmit"), object: nil)
        
        
        ////tapToReturnCallLabel.isHidden = true
        tapToReturnCall.isHidden = true
        //tableviewHolderView.isHidden = true
        button1.isHidden = true
        button2.isHidden = false
        button3.isHidden = true
        button4.isHidden = true
        //button5.isHidden = true
        //button6.isHidden = true
        //callEndView.isHidden = true
        //waitingLabel.isHidden = true
        secondButtonView.isHidden = true
        //a
        //button2.setBackgroundImage(UIImage(named:""), for: .normal)
       // joinCall.isHidden = false
       // joinCall.isEnabled = true
        //joinCall.backgroundColor =  UIColor(red: 55.0 / 255.0, green: 119.0 / 255.0, blue: 173 / 255.0, alpha: 1.0)
        button2.isEnabled = true
        //button5.setBackgroundImage(UIImage(named:"pauseVideo"), for: .normal)
        // //button6.setBackgroundImage(UIImage(named:"offspeaker"), for: .normal)
        viewto = "waitingView"
    }
    
    func changeCallStatus()
    {
        callCut = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if callStatus == "connected"
        {
            callStateLabel.isHidden = false
        }
        else
        {
            callStateLabel.isHidden = true
        }
        if (UserDefaults.standard.object(forKey: "avatarData")) == nil
        {
            //a
            //joinCall.isEnabled = false
           // joinCall.backgroundColor =  UIColor.lightGray
            // button2.setBackgroundImage(UIImage(named:"greycall"), for: .normal)
            //button2.isEnabled = false
        }
        else  if (UserDefaults.standard.object(forKey: "avatarData")) != nil && ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "appointment_id")) != nil && callStatus == ""
        {
            //a
            //self.button2.setBackgroundImage(UIImage(named:""), for: .normal)
            //joinCall.isEnabled = true
            //joinCall.backgroundColor =  UIColor(red: 55.0 / 255.0, green: 119.0 / 255.0, blue: 173 / 255.0, alpha: 1.0)
           // self.button2.isEnabled = true
        }
        else
        {
            //self.button2.isEnabled = true
        }
//        if headerLabel.text == ""
//        {
//            headerLabel.text = "CURRENT PATIENT"
//        }else
//        {
//        }
        reportMissedButton.isHidden = false
        reportMissedButton.layer.cornerRadius = 3
        if  UserDefaults.standard.object(forKey: "Missed") != nil && UserDefaults.standard.object(forKey: "Missed") as! String != ""
        {
            reportMissedButton.isHidden = false
        }else
        {
            reportMissedButton.isHidden = true
        }
        if  UserDefaults.standard.object(forKey: "avatarData") != nil &&  (UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).count>0  &&  ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "first_name")) != nil
            && ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "first_name")) as! String != ""
            && ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "last_name")) != nil
        {
            
            remoteUsername.text = ((((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "first_name")) as! String)  + " " + (((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "last_name")) as! String)).uppercased()
            
            if ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "allergies_description")) != nil &&
                
                ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "allergies_description"))
                is NSNull == false
                && ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "allergies_description")) as! String != ""
            {
                allergyLabel.text  = "Allergy: " + (((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "allergies_description")) as! String)
            }else
            {
                allergyLabel.text  = "Work Allergy"
            }
            if ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "call_id")) != nil
                && ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "call_id")) as! String != ""
            {
                callId.text = "(" + (((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "call_id")) as! String) + ")"
            }else
            {
                callId.text = ""
            }
        }
        else
        {
            remoteUsername.text = "Erick Richard"
            callId.text  = ""
            allergyLabel.text  = "ID- F134J31212"
        }
        profileImageCall.layer.cornerRadius = profileImageCall.frame.width/2
        profileImageCall.clipsToBounds = true
        if  UserDefaults.standard.object(forKey: "avatarData") != nil &&  (UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).count>0  &&  ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "profile_image")) != nil
        {
            let image1 = ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "profile_image")) as! String
            
            let image_url = ""
            
            profileImageCall.setImageWith(NSURL(string: image_url) as! URL, placeholderImage: UIImage(named: "default_profile"))
        }else
        {
            profileImageCall.image = UIImage(named: "default_profile")
        }
        
        ////tapToReturnCallLabel.isHidden = true
        tapToReturnCall.isHidden = true
        let vc = self.childViewControllers.last
        if vc != nil
        {
            //tapToReturnCallLabel.isHidden = false
            tapToReturnCall.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    //MARK:- FUNCTIONS
    
    @IBAction func reportMissedButtonClicked(_ sender: UIButton) {
        fromMissed = "Missed"
        callStatusSending = "Missed"
        callStatusSend()
    }
    
    @IBAction func callButtonClicked(_ sender: UIButton) {
        if callStatus == "connected"
        {
            callDisconnect()
            callStatusSending = "Incomplete"
        }else
        {
            sendAppointment()

        }
    }
    
    @IBAction func joinCallTapped(_ sender: UIButton) {
        //        if subscriber?.stream != nil
        //        {
        //            cleanupSubscriber()
        //        }
        sendAppointment()
    }
    @IBAction func tapToReturnBtnClicked(_ sender: UIButton) {
        if callStatus == "connected"
        {
            hideOverlayButton.isHidden = false
            hideDocInfoView()
        }
        let vc = self.childViewControllers.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
        if chatvc != nil{
            chatvc.view.removeFromSuperview()
            chatvc.removeFromParentViewController()
        }
        //tapToReturnCallLabel.isHidden = true
        tapToReturnCall.isHidden = true
        self.view.bringSubview(toFront: detailButton)
        if callStatus == "connected"
        {
            publisher.view?.removeFromSuperview()
            subscriber?.view?.removeFromSuperview()
            publisher.view?.frame = CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
            localVideoView.addSubview(publisher.view!)
            //big view
            if let subsView = subscriber?.view {
                subsView.frame = remoteVideoView.frame
                remoteVideoView.addSubview(subsView)
                remoteVideoView.clipsToBounds = true
            }
            
            callId.textColor = UIColor.white
            callStateLabel.textColor = UIColor.white
            remoteUsername.textColor = UIColor.white
        }
    }
    
    func resumeVedioChange()
    {
        if callStatus == "connected"
        {
            callId.textColor = UIColor.white
            callStateLabel.textColor = UIColor.white
            remoteUsername.textColor = UIColor.white
        }
    }
    
    @IBAction func chatBtnClecked(_ sender: UIButton) {
        if callStatus == "connected"
        {
            gameTimer.invalidate()
            hideOverlayButton.isHidden = true
            callStateLabel.isHidden = false
            allergyLabel.isHidden = false
            callId.isHidden = false
            remoteUsername.isHidden = false
            buttonMainView.isHidden = false
        }
        let vc1 = self.childViewControllers.last
        vc1?.view.removeFromSuperview()
        vc1?.removeFromParentViewController()
        callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        //tapToReturnCallLabel.isHidden = false
        tapToReturnCall.isHidden = false
        chatvc = self.storyboard?.instantiateViewController(withIdentifier: "ChatOn") as! ChatOn
        chatvc.view.frame = CGRect(x: 0, y: 212, width: self.view.frame.width, height: self.view.frame.height-(64+197))
        chatvc.session = self.session
        self.addChildViewController(chatvc)
        self.view.addSubview(chatvc.view)
        chatvc.didMove(toParentViewController: self)
        self.view.bringSubview(toFront: detailButton)
        if callStatus == "connected"
        {
            publisher.view?.removeFromSuperview()
            subscriber?.view?.removeFromSuperview()
            if let subsView = subscriber?.view {
                subsView.frame =  CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
                localVideoView.addSubview(subsView)
                localVideoView.clipsToBounds = true
                self.view.bringSubview(toFront: localVideoView)
            }
        }
    }
    //MARK:- CALL FUNCTION
    
    func callEstablish()
    {
        secondButtonView.isHidden = true
        //waitingLabel.isHidden = true
        callStatus = "connected"
        //aa
       // joinCall.isHidden = true
        button2.setBackgroundImage(UIImage(named:"disconnectCall"), for: .normal)
        imageView.isHidden = true
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        //button5.isHidden = true
        //button6.isHidden = false
        self.startCallDurationTimer(with: #selector(self.onDurationTimer))
    }
    
    @IBAction func disconnectCallBtnClicked(_ sender: Any) {
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator:
        UIViewControllerTransitionCoordinator) {
        if   viewto == "waitingView"
        {
            if (size.width / size.height > 1) {
                print("landscape")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                if mode == "portrait"
                {
                    let frame = (tabBarController?.tabBar.frame.width)! / 10
                    detailButton.frame = CGRect(x: ((view.frame.size.height/2) - frame/2) + 3.5 , y: self.view.frame.width-(64 + 20), width: frame, height: 37)
                    imageView.frame = CGRect(x:self.view.frame.height/4 + (self.view.frame.height/4)/2, y:self.view.frame.width/3, width: self.view.frame.height/4 , height: self.view.frame.height/4)
                    //waitingLabel.frame = CGRect(x: imageView.frame.origin.x , y:imageView.frame.origin.y + imageView.frame.height + 20 , width:imageView.frame.width , height: 30)
                }
                else{
                    let frame = (tabBarController?.tabBar.frame.width)! / 10
                    detailButton.frame = CGRect(x: ((view.frame.size.width/2) - frame/2) + 16 , y: self.view.frame.height-(64 + 20), width: 77.8, height: 37)
                    imageView.frame = CGRect(x:self.view.frame.width/4 + (self.view.frame.width/4)/2, y:self.view.frame.height/3, width: self.view.frame.width/4 , height: self.view.frame.height/3)
                    //waitingLabel.frame = CGRect(x: imageView.frame.origin.x , y:imageView.frame.origin.y + imageView.frame.height + 20 , width:imageView.frame.width , height: 30)
                }
                mode = "landscape"
                
            } else {
                print("portrait")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                if mode == "landscape"
                {
                    let frame = (tabBarController?.tabBar.frame.width)! / 10
                    
                    detailButton.frame = CGRect(x: ((view.frame.size.height/2) - frame/2) + 16 , y: self.view.frame.width-(64 + 20), width: 77.8, height: 37)
                    
                    imageView.frame = CGRect(x:self.view.frame.height/3, y:self.view.frame.height/3, width: self.view.frame.width/4 , height: self.view.frame.height/3)
                    
                    //waitingLabel.frame = CGRect(x: imageView.frame.origin.x , y:imageView.frame.origin.y + imageView.frame.height + 20 , width:imageView.frame.width , height: 30)
                }
                else{
                    let frame = (tabBarController?.tabBar.frame.width)! / 10
                    detailButton.frame = CGRect(x: ((view.frame.size.width/2) - frame/2) + 3.5 , y: self.view.frame.height-(64 + 20), width: frame, height: 37)
                    imageView.frame = CGRect(x:self.view.frame.width/3, y:self.view.frame.height/4, width: self.view.frame.width/3 , height: self.view.frame.height/4)
                    //waitingLabel.frame = CGRect(x: imageView.frame.origin.x , y:imageView.frame.origin.y + imageView.frame.height + 20 , width:imageView.frame.width , height: 30)
                }
                mode = "portrait"
            }
        }
    }
    
    @IBAction func detailsButtonClickedforhide(_ sender: UIButton) {
        self.hideMenu()
        if callStatus == "connected"
        {
            hideOverlayButton.isHidden = false
            hideDocInfoView()
        }
    }
    func hideMenu()
    {
        tappedIndex = -1
        detailButton.isHidden = false
        //tableviewHolderView.isHidden = true
    }
    @IBAction func detailsButtonClicked(_ sender: UIButton) {
        
        if callStatus == "connected"
        {
            publisher.view?.removeFromSuperview()
            subscriber?.view?.removeFromSuperview()
            publisher.view?.frame = CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
            localVideoView.addSubview(publisher.view!)
            //big view
            if let subsView = subscriber?.view {
                subsView.frame = remoteVideoView.frame
                remoteVideoView.addSubview(subsView)
                remoteVideoView.clipsToBounds = true
            }
        }
        
        if chatvc != nil{
            chatvc.view.removeFromSuperview()
            chatvc.removeFromParentViewController()
        }
        
        
        let vc = self.childViewControllers.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
        //tapToReturnCallLabel.isHidden = true
        tapToReturnCall.isHidden = true
        
        if UserDefaults.standard.object(forKey: "avatarData") != nil && (UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).count > 0 && ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "appointment_id")) != nil && ((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "appointment_id"))  as! String != ""
                {
        detailButton.isHidden = true
        //tableviewHolderView.isHidden = false
        dropBool = false
        indexCount = 0
        tableView.reloadData()
        if UserDefaults.standard.object(forKey: "called") != nil
        {
        }
        }
    }
    
    //MARK:- TableView Delegate and Datasource

    

    
    func viewchange()
    {
        if callStatus == "connected"
        {
            publisher.view?.removeFromSuperview()
            subscriber?.view?.removeFromSuperview()
            if let subsView = subscriber?.view {
                subsView.frame =  CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
                localVideoView.addSubview(subsView)
                localVideoView.clipsToBounds = true
                self.view.bringSubview(toFront: localVideoView)
            }
        }
    }
    
        
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        //callEndView.isHidden = true
    }
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        gameTimer.invalidate()
        callEndReason = true
        durationTimer.invalidate()
        durationTimer = Timer()
        //a
        //joinCall.isHidden = false
        
        button2.setBackgroundImage(UIImage(named:""), for: .normal)
        button2.isEnabled = true
        imageView.isHidden = false
        button1.isHidden = true
        button2.isHidden = false
        button3.isHidden = true
        button4.isHidden = true
        //button5.isHidden = true
        //button6.isHidden = true
        //callEndView.isHidden = true
        callStatus = ""
        message = "no"
        callDisconnect()
        callStatusSending = "Incomplete"
        hideOverlayButton.isHidden = true
        callStatusSend()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setCallStatusText(text:String)
    {
        if text == "calling..." || text == "ringing"
        {
            self.callStateLabel.text = text;
        }else
        {
            self.callStateLabel.text = "00:" + text;
        }
    }
    func showButtons(buttons:EButtonsBar)
    {
        if (buttons == EButtonsBar.kButtonsAnswerDecline) {
            
        } else if (buttons == EButtonsBar.kButtonsHangup) {
        }
    }
    //MARK:- Buttons
    
    @IBAction func muteButtonPressed(sender:UIButton)
    {
        if publisher.publishAudio == true
        {
            sender.isSelected = true
            publisher.publishAudio = false
        }
        else
        {
            sender.isSelected = false
            publisher.publishAudio = true
        }
    }
    @IBAction func cameraSwitchButtonPressed(sender:UIButton)
    {
        if publisher.cameraPosition == .back
        {
            publisher.cameraPosition = AVCaptureDevicePosition.front // back camera
        }
        else
        {
            publisher.cameraPosition = AVCaptureDevicePosition.back
        }
    }
    @IBAction func accept(sender:UIButton)
    {
        
    }
    
    @IBAction func decline(sender:UIButton)
    {
        callStateLabel.text = "00:00:00"
        durationTimer.invalidate()
        durationTimer = Timer()
        //a
        //joinCall.isHidden = false
        
        button2.setBackgroundImage(UIImage(named:""), for: .normal)
        button2.isEnabled = true
        imageView.isHidden = false
        button1.isHidden = true
        button2.isHidden = false
        button3.isHidden = true
        button4.isHidden = true
        //button5.isHidden = true
        //button6.isHidden = true
        //waitingLabel.isHidden = true
        secondButtonView.isHidden = true
        callStatus = ""
        callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
    }
    
    
    //MARK:- Video Pause play
    
    @IBAction func videoPlayPauseBtnClicked(_ sender: UIButton) {
        if publisher.publishVideo == true
        {
            sender.isSelected = true
            publisher.publishVideo = false
        }
        else
        {
            sender.isSelected = false
            publisher.publishVideo = true
        }
        
    }
    //MARK: -  FOR CALL EXTEND FUNCTIONS AND IBACTIONS
    func extendFuncCall()
    {
        //runTimer()
//        callExtendView.isHidden = false
//        extendOptionView.isHidden = false
//        extendSuccessView.isHidden = true
        ImmidiatePermissionView.isHidden = true
        ImmidiateSlotSuccessView.isHidden = true
        ImmidiateSlotNotAvailableView.isHidden = true
        ImmidiateSlotRejectPatientView.isHidden = true
        nextApptPaymentSuccessView.isHidden = true
//        self.view.bringSubview(toFront: callExtendView)
    }
    
    @IBAction func bookNextImmidiateSlotBtnClicked(_ sender: UIButton) {
        // timernew.invalidate()
//        callExtendView.isHidden = true
        apptType = "immediate"
        apptStatus()
    }
    
    @IBAction func noThanksBtnClicked(_ sender: UIButton) {
        // timernew.invalidate()
        callCut = true
        callEndReason = true
//        callExtendView.isHidden = true
        Timer.scheduledTimer(timeInterval: 110.0, target: self, selector: #selector(self.endCallfunc), userInfo: nil, repeats: false)
    }
    
    func callViewCreated()
    {
        let pv = UIView()
        pv.frame = CGRect(x: 0, y: 0, width: 120, height: 240)
    }
    
    func endCallfunc()
    {
        gameTimer.invalidate()
        callEndReason = true
        durationTimer.invalidate()
        durationTimer = Timer()
        //a
       // joinCall.isHidden = false
        
        button2.setBackgroundImage(UIImage(named:""), for: .normal)
        button2.isEnabled = true
        imageView.isHidden = false
        button1.isHidden = true
        button2.isHidden = false
        button3.isHidden = true
        button4.isHidden = true
        //button5.isHidden = true
        //button6.isHidden = true
        //callEndView.isHidden = true
        callStatus = ""
        UserDefaults.standard.removeObject(forKey: "avatarId")
        callStatusSending = "Incomplete"
        callStatusSend()
    }
    
    //MARK:- Duration
    func onDurationTimer(unused:Timer)
    {
        let reach: Reachability
        do{
            reach = try Reachability.forInternetConnection()
            if reach.isReachable(){
                counter = ((counter+1))
                let value = Int(counter/2)
                self.setDuration((value))
                let timer = callExtend-2
                if ((counter/2)) == (timer*60) && callCut == false
                {
                    extendFuncCall()
                }
            }else
            {
                durationTimer.invalidate()
                durationTimer = Timer()
                //a
                //joinCall.isHidden = false
                button2.setBackgroundImage(UIImage(named:""), for: .normal)
                button2.isEnabled = true
                imageView.isHidden = false
                button1.isHidden = true
                button2.isHidden = false
                button3.isHidden = true
                button4.isHidden = true
                //button5.isHidden = true
                //button6.isHidden = true
                //callEndView.isHidden = true
                callStatus = ""
            }
        }
        catch{
        }
    }
    
    func setDuration(_ seconds: Int) {
        self.setCallStatusText(text: String(format: "%02d:%02d", Int(seconds / 60), Int(seconds % 60)))
    }
    
    func internal_updateDuration(_ timer: Timer) {
        let selector: Selector? = NSSelectorFromString(timer.userInfo as! String)
        if responds(to: selector) {
            perform(selector, with: timer)
        }
    }
    
    func startCallDurationTimer(with sel: Selector) {
        let selectorAsString: String = NSStringFromSelector(sel)
        durationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.internal_updateDuration), userInfo: selectorAsString, repeats: true)
    }
    
    func stopCallDurationTimer(){
        durationTimer.invalidate()
        durationTimer = Timer()
    }
    
    //MARK:- SINCallDelegate
    func callDidEnd(){
        hideOverlayButton.isHidden = true
        callStateLabel.isHidden = false
        allergyLabel.isHidden = false
        callId.isHidden = false
        remoteUsername.isHidden = false
        buttonMainView.isHidden = false
      //  callExtendView.isHidden = true
        callExtend = 10
        callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        localVideoView.isHidden = true
        remoteVideoView.isHidden = true
        callStateLabel.text = "00:00:00"
        durationTimer.invalidate()
        durationTimer = Timer()
        //a
        //joinCall.isHidden = false
        
        button2.setBackgroundImage(UIImage(named:""), for: .normal)
        button2.isEnabled = true
        imageView.isHidden = false
        button1.isHidden = true
        button2.isHidden = false
        button3.isHidden = true
        button4.isHidden = true
        //button5.isHidden = true
        //button6.isHidden = true
        //waitingLabel.isHidden = true
        secondButtonView.isHidden = true
        callStatus = ""
        callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
        //// for call cut
        let vc = self.childViewControllers.last
        if vc?.restorationIdentifier == "ChatOn"
        {
            vc?.view.removeFromSuperview()
            vc?.removeFromParentViewController()
        }
        //tapToReturnCallLabel.isHidden = true
        tapToReturnCall.isHidden = true
        self.view.bringSubview(toFront: detailButton)
        if callEndReason == false && counter != 0
        {
            supportingfuction.showMessageHudWithMessage(message: "Due to some reason call disconnected. Please try again.", delay: 2.0)
            gameTimer.invalidate()
            hideOverlayButton.isHidden = true
            callStateLabel.isHidden = false
            allergyLabel.isHidden = false
            callId.isHidden = false
            remoteUsername.isHidden = false
            buttonMainView.isHidden = false
        }
        else
        {
            if counter == 0
            {
                fromMissed = ""
                callStatusSending = "Missed"
                callStatusSend()
            }
        }
    }
    
    func callDidEstablish(){
        //button5.setBackgroundImage(UIImage(named:"pauseVideo"), for: .normal)
        ////button6.setBackgroundImage(UIImage(named:"offspeaker"), for: .normal)
        tabBarController?.tabBar.items?[0].isEnabled = false
        tabBarController?.tabBar.items?[1].isEnabled = false
        tabBarController?.tabBar.items?[3].isEnabled = false
        tabBarController?.tabBar.items?[4].isEnabled = false
        callEstablish()
        callStatus = "connected"
        UserDefaults.standard.set("connected", forKey: "called")
        self.showButtons(buttons: EButtonsBar.kButtonsHangup)
        callId.textColor = UIColor.white
        callStateLabel.textColor = UIColor.white
        remoteUsername.textColor = UIColor.white
        localVideoView.isHidden = false
        remoteVideoView.isHidden = false
        reportMissedButton.isHidden = true
        UserDefaults.standard.removeObject(forKey: "Missed")
        callEstablished = "establish"
        hideDocInfoView()
        hideOverlayButton.isHidden = false
        buttonMainView.isHidden = false
        // //button6.setBackgroundImage(UIImage(named:"speaker"), for: .normal)
    }
    
    //MARK:- Sounds
    func pathForSound(soundName:String) -> String
    {
        return (Bundle.main.resourcePath?.stringByAppendingPathComponent(pathComponent: soundName))!
    }
    //MARK:- Call Status web service
    
    func  callStatusSubmit()
    {
        let vc = self.childViewControllers.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
        //tapToReturnCallLabel.isHidden = true
        tapToReturnCall.isHidden = true
        callStatusSending = "Completed"
        callEndReason = true
        //  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.callStatusSend), userInfo: nil, repeats: false)
        self.callStatusSend()
    }
    
    func callStatusSend()
    {
        
    }
//    {
//        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
//        let requestData = NSMutableDictionary()
//        requestData.setObject("call_status", forKey: "page" as NSCopying)
//        requestData.setObject(callStatusSending, forKey: "status" as NSCopying)
//        requestData.setObject(String((counter/2)), forKey: "call_duration" as NSCopying)
//        print(callStatusSending)
//        if UserDefaults.standard.object(forKey: "avatarData") != nil
//        {
//            requestData.setObject(((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "appointment_id")) as! String,forKey: "apt_id" as NSCopying)
//        }
//        if UserDefaults.standard.object(forKey: "key_api") != nil
//        {
//            requestData.setObject(UserDefaults.standard.object(forKey: "key_api") as! String, forKey: "key_api" as NSCopying)
//        }
//        let apiSniper = APISniper()
//        apiSniper.getDataFromWebAPI(requestData, {(operation, responseObject) in
//            if let dataFromServer = responseObject as? NSDictionary
//            {
//                if dataFromServer.object(forKey: "status") as! String == "success"
//                {
//                    if self.callStatus == "connected"
//                    {
//                        self.callDisconnect()
//                    }
//                    supportingfuction.hideProgressHudInView(view: self)
//                    if self.callStatusSending == "Completed"
//                    {
//                        kApiKey = ""
//                        kSessionId = ""
//                        kToken = ""
//                        UserDefaults.standard.removeObject(forKey: "Missed")
//                        appDelegate.chatmessages.removeAllObjects()
//                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
//                        let vc = self.childViewControllers.last
//                        vc?.view.removeFromSuperview()
//                        vc?.removeFromParentViewController()
//                        UserDefaults.standard.removeObject(forKey: "avatarData")
//                        self.tabBarController?.tabBar.items?[0].isEnabled = true
//                        self.tabBarController?.tabBar.items?[1].isEnabled = true
//                        self.tabBarController?.tabBar.items?[3].isEnabled = true
//                        self.tabBarController?.tabBar.items?[4].isEnabled = true
//                        UserDefaults.standard.removeObject(forKey : "called")
//                        UserDefaults.standard.removeObject(forKey: "avatarId")
//                        self.tabBarController?.selectedIndex = 1
//                        self.callEstablished = ""
//                    }
//                    else if self.callStatusSending == "Missed" &&  self.fromMissed == "Missed"
//                    {
//                        UserDefaults.standard.removeObject(forKey: "Missed")
//                        self.fromMissed = ""
//                        let msg = "Missed Call Reported."
//                        supportingfuction.showMessageHudWithMessage(message: msg as NSString, delay: 2.0)
//                        UserDefaults.standard.removeObject(forKey: "avatarData")
//                        UserDefaults.standard.removeObject(forKey : "called")
//                        UserDefaults.standard.removeObject(forKey: "avatarId")
//                        self.tabBarController?.selectedIndex = 1
//                    }
//                    else
//                    {
//                    }
//                }
//                else
//                {
//                    supportingfuction.hideProgressHudInView(view: self)
//                }
//            }
//        })
//        { (operation, error) in
//            print(error.localizedDescription)
//            supportingfuction.hideProgressHudInView(view: self)
//            supportingfuction.showMessageHudWithMessage(message: "Due to some error, we are unable to proceed with your request.", delay: 2.0)
//        }
//    }
    
    //for all call status
    func  apptStatus()
    {
        
    }
//    {
//        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
//        let requestData = NSMutableDictionary()
//        requestData.setObject("apptStatusByProvider", forKey: "page" as NSCopying)
//        requestData.setObject(((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "appointment_id")) as! String,forKey: "appointment_id" as NSCopying)
//        if UserDefaults.standard.object(forKey: "key_api") != nil
//        {
//            requestData.setObject(UserDefaults.standard.object(forKey: "key_api") as! String, forKey: "key_api" as NSCopying)
//        }
//        
//        requestData.setObject(apptType,forKey: "type" as NSCopying)
//        print("requestData")
//        let apiSniper = APISniper()
//        apiSniper.getDataFromWebAPI(requestData, {(operation, responseObject) in
//            if let dataFromServer = responseObject as? NSDictionary
//            {
//                print(dataFromServer)
//                supportingfuction.hideProgressHudInView(view: self)
//                if dataFromServer.object(forKey: "status") as! String == "success"
//                {
//                    supportingfuction.hideProgressHudInView(view: self)
//                    if  self.apptType == "extendfreecall"
//                    {
//                        self.callExtend = self.callExtend+5
//                        self.callCut = false
//                    }
//                    else
//                    {
//                        self.callCut = false
//                        self.callExtendView.isHidden = false
//                        self.extendOptionView.isHidden = true
//                        self.extendSuccessView.isHidden = true
//                        self.ImmidiatePermissionView.isHidden = false
//                        self.ImmidiateSlotSuccessView.isHidden = true
//                        self.ImmidiateSlotNotAvailableView.isHidden = true
//                        self.ImmidiateSlotRejectPatientView.isHidden = true
//                        self.nextApptPaymentSuccessView.isHidden = true
//                        self.view.bringSubview(toFront: self.callExtendView)
//                    }
//                }
//                else
//                {
//                    supportingfuction.hideProgressHudInView(view: self)
//                    if  self.apptType == "extendfreecall"
//                    {
//                        let msg:String = dataFromServer.object(forKey: "msg") as! String
//                        supportingfuction.showMessageHudWithMessage(message: msg as NSString, delay: 2.0)
//                        Timer.scheduledTimer(timeInterval: 105.0, target: self, selector: #selector(self.endCallfunc), userInfo: nil, repeats: false)
//                        self.callCut = true
//                    }
//                    else{
//                        Timer.scheduledTimer(timeInterval: 105.0, target: self, selector: #selector(self.endCallfunc), userInfo: nil, repeats: false)
//                        self.callExtendView.isHidden = false
//                        self.extendOptionView.isHidden = true
//                        self.extendSuccessView.isHidden = true
//                        self.ImmidiatePermissionView.isHidden = true
//                        self.ImmidiateSlotSuccessView.isHidden = true
//                        self.ImmidiateSlotNotAvailableView.isHidden = false
//                        self.ImmidiateSlotRejectPatientView.isHidden = true
//                        self.nextApptPaymentSuccessView.isHidden = true
//                        self.view.bringSubview(toFront: self.callExtendView)
//                        self.callCut = true
//                    }
//                }
//            }
//        }) { (operation, error) in
//            print(error.localizedDescription)
//            supportingfuction.hideProgressHudInView(view: self)
//            supportingfuction.showMessageHudWithMessage(message: "Due to some error, we are unable to proceed with your request.", delay: 2.0)
//        }
//    }
    //MARK:-  Notification all func for popup
    
  
    fileprivate func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
//         self.button1.isHidden = false
            self.button2.isHidden = false
//         self.button3.isHidden = false
//         self.button4.isHidden = false
       // self.secondButtonView.isHidden = false
        session.connect(withToken: kToken, error: &error)
        //a
        //joinCall.isHidden = true
        button2.setBackgroundImage(UIImage(named:"disconnectCall"), for: .normal)
    }
    func callDisconnect()
    {
        
        var error: OTError?
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue("endCall", forKey: "data")
        recieverDict.setValue(UserDefaults.standard.object(forKey: "first_name") as! String, forKey: "senderName")
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
        }catch let error as NSError{
            print(error.description)
        }
        session.signal(withType: "endCall", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.calldisconnect), userInfo: nil, repeats: false)
        
    }
    
    
    
    func calldisconnect()
    {
        var error: OTError?
        session.unpublish(publisher, error: &error)
        session.disconnect(&error)
        //a
       // joinCall.isHidden = false
        button2.setBackgroundImage(UIImage(named:""), for: .normal)
        callConnect = false
        callDidEnd()
    }
    
    
    fileprivate func doPublish() {
        var error: OTError?
        defer {
            processError(error)
        }
        session.publish(publisher, error: &error)
        callDidEstablish()
        publisher.view?.frame = CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
        localVideoView.addSubview(publisher.view!)
    }
    /**
     * Instantiates a subscriber for the given stream and asynchronously begins the
     * process to begin receiving A/V content for this stream. Unlike doPublish,
     * this method does not add the subscriber to the view hierarchy. Instead, we
     * add the subscriber only after it has connected and begins receiving data.
     */
    fileprivate func doSubscribe(_ stream: OTStream) {
        remoteVideoView.backgroundColor =  UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 241 / 255.0, alpha: 1.0)
        var error: OTError?
        defer {
            processError(error)
        }
        subscriber = OTSubscriber(stream: stream, delegate: self)
        session.subscribe(subscriber!, error: &error)
    }
    
    fileprivate func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
    }
    
    fileprivate func processError(_ error: OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    //MARK:- For next immidiate
    //MARK:-
   
  
    // to hide the doc view and show in 10 sec duration
    func hideDocInfoView()
    {
        buttonMainView.isHidden = false
        callStateLabel.isHidden = false
        allergyLabel.isHidden = false
        callId.isHidden = false
        remoteUsername.isHidden = false
        gameTimer = Timer.scheduledTimer(timeInterval: 3.00, target: self,selector: #selector(runTimedCode), userInfo: nil, repeats: false)
    }
    func runTimedCode()
    {
        buttonMainView.isHidden = true
        callStateLabel.isHidden = true
        allergyLabel.isHidden = true
        callId.isHidden = true
        remoteUsername.isHidden = true
    }
    /// Web Service for Send Appt id to patient
    func sendAppointment()
    {
//        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "Please Wait", labelText: "Requesting")
//        let requestData = NSMutableDictionary()
//        requestData.setObject("getUserTokenSession", forKey: "page" as NSCopying)
//        requestData.setObject(((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "appointment_id")) as! String,forKey: "appointment_id" as NSCopying)
//        requestData.setObject(UserDefaults.standard.object(forKey: "user_id") as! String,forKey: "user_id" as NSCopying)
//        if UserDefaults.standard.object(forKey: "key_api") != nil
//        {
//            requestData.setObject(UserDefaults.standard.object(forKey: "key_api") as! String, forKey: "key_api" as NSCopying)
//        }
        
//        print(requestData)
//        let apiSniper = APISniper()
//        apiSniper.getDataFromWebAPI(requestData, {(operation, responseObject) in
//            if let dataFromServer = responseObject as? NSDictionary
//            {
//                supportingfuction.hideProgressHudInView(view: self)
//                print(dataFromServer)
//                if dataFromServer.object(forKey: "status") as! String == "success"
//                {
//                    if dataFromServer.object(forKey: "data") != nil && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "tokbox_apiKey") != nil && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "tokbox_apiKey") is NSNull == false && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "tokbox_apiKey") as! String != ""
//                    {
//                        kApiKey = (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "tokbox_apiKey") as! String
//                    }
//                    
//                    if dataFromServer.object(forKey: "data") != nil && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "sessionId") != nil && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "sessionId") is NSNull == false && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "sessionId") as! String != ""
//                    {
//                        kSessionId = (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "sessionId") as! String
//                    }
//                    
//                    if dataFromServer.object(forKey: "data") != nil && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "token") != nil && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "token") is NSNull == false
//                        && (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "token") as! String != ""
//                    {
//                        kToken = (dataFromServer.object(forKey: "data") as! NSDictionary).object(forKey: "token") as! String
//                    }
//                    if kApiKey != nil && kApiKey != "" && kSessionId != nil && kSessionId != "" && kSessionId != nil && kSessionId != ""
//                    {
//                        
                        self.session = {
                            return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
                        }()
                        
                        self.button2.isHidden = true
                       // self.//waitingLabel.isHidden = false
                        self.button2.isHidden = true
                        //self.secondButtonView.isHidden = false
                       // self.secondButtonView.isHidden = false
                        self.counter = 0
                        self.callExtend = 10
                        self.doConnect()
                        
                        
                        //Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.delayCall), userInfo: nil, repeats: false)
//                        
//                    }
//                    else
//                    {
//                        supportingfuction.showMessageHudWithMessage(message: "API KEY, SESSION ID AND TOKEN connot be null.", delay: 2.0)
//                    }
//                    
//                    //                    self.sendNotification()
//                }
//                else
//                {
//                    supportingfuction.hideProgressHudInView(view: self)
//                    let msg:String = dataFromServer.object(forKey: "msg") as! String
//                    supportingfuction.showMessageHudWithMessage(message: msg as NSString, delay: 2.0)
//                }
//            }
//        }) {
//            (operation, error) in
//            print(error.localizedDescription)
//            supportingfuction.hideProgressHudInView(view: self)
//            supportingfuction.showMessageHudWithMessage(message: "Due to some error, we are unable to proceed with your request.", delay: 2.0)
//        }
    }
    
    
    
    /// Web Service for Send Appt id to patient
    func sendNotification()
    {
        
    }
//    {
//        let requestData = NSMutableDictionary()
//        requestData.setObject("notifypatienttojoin", forKey: "page" as NSCopying)
//        requestData.setObject(((UserDefaults.standard.object(forKey: "avatarData") as! NSDictionary).object(forKey: "appointment_id")) as! String,forKey: "appointment_id" as NSCopying)
//        if UserDefaults.standard.object(forKey: "key_api") != nil
//        {
//            requestData.setObject(UserDefaults.standard.object(forKey: "key_api") as! String, forKey: "key_api" as NSCopying)
//        }
//        
//        print(requestData)
//        let apiSniper = APISniper()
//        apiSniper.getDataFromWebAPI(requestData, {(operation, responseObject) in
//            if let dataFromServer = responseObject as? NSDictionary
//            {
//                print(dataFromServer)
//            }
//        }) {
//            (operation, error) in
//            print(error.localizedDescription)
//            
//        }
//    }
    
}

extension String {
    func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}

// MARK: - OTSession delegate callbacks
extension WaitingRoomView: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        remoteVideoView.backgroundColor =  UIColor(red: 131.0 / 255.0, green: 131.0 / 255.0, blue: 131 / 255.0, alpha: 1.0)
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        if subscriber == nil && !subscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        remoteVideoView.backgroundColor =  UIColor(red: 131.0 / 255.0, green: 131.0 / 255.0, blue: 131 / 255.0, alpha: 1.0)
        if message == ""
        {
        }
        else
        {
            message = ""
        }
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        if type! == "endCall"
        {
            
        }
        else
        {
            
            if callStatus == "connected"
            {
                callId.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
                callStateLabel.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
                remoteUsername.textColor = UIColor(red: 4.0 / 255.0, green: 77 / 255.0, blue: 127 / 255.0, alpha: 1.0)
                publisher.view?.removeFromSuperview()
                subscriber?.view?.removeFromSuperview()
                if let subsView = subscriber?.view {
                    subsView.frame =  CGRect(x: 0, y: 0, width: self.localVideoView.frame.size.width, height: self.localVideoView.frame.size.height)
                    localVideoView.addSubview(subsView)
                    localVideoView.clipsToBounds = true
                    self.view.bringSubview(toFront: localVideoView)
                }
                gameTimer.invalidate()
                hideOverlayButton.isHidden = true
                callStateLabel.isHidden = false
                allergyLabel.isHidden = false
                callId.isHidden = false
                remoteUsername.isHidden = false
                buttonMainView.isHidden = false
            }
            let vc1 = self.childViewControllers.last
            vc1?.view.removeFromSuperview()
            vc1?.removeFromParentViewController()
            //tapToReturnCallLabel.isHidden = false
            tapToReturnCall.isHidden = false
            chatvc = self.storyboard?.instantiateViewController(withIdentifier: "ChatOn") as! ChatOn
            chatvc.view.frame = CGRect(x: 0, y: 212, width: self.view.frame.width, height: self.view.frame.height-(64+197))
            chatvc.session = self.session
            self.addChildViewController(chatvc)
            self.view.addSubview(chatvc.view)
            chatvc.didMove(toParentViewController: self)
            self.view.bringSubview(toFront: detailButton)
            print("Received signal \(string)")
            var dict = NSMutableDictionary()
            dict = convertToDictionary(text: string!).mutableCopy() as! NSMutableDictionary
            if dict.count>0
            {
                let recieverDict = NSMutableDictionary()
                recieverDict.setValue(dict.object(forKey: "data") as! String, forKey: "message")
                recieverDict.setValue(dict.object(forKey: "senderName") as! String, forKey: "senderName")
                if dict.object(forKey: "user_id") != nil{
                recieverDict.setValue(dict.object(forKey: "user_id") as! String, forKey: "user_id")
                }else{
                    recieverDict.setValue(dict.object(forKey: "") as! String, forKey: "user_id")
                }
                appDelegate.chatmessages.add(recieverDict)
                print(appDelegate.chatmessages)
            }
            chatvc.tblChat.reloadData()
        }
    }
}

func convertToDictionary(text: String) -> NSDictionary {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as!NSDictionary
        } catch {
            print(error.localizedDescription)
        }
    }
    return NSDictionary()
}

// MARK: - OTPublisher delegate callbacks
extension WaitingRoomView: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        if subscriber == nil && subscribeToSelf{
            doSubscribe(stream)
        }
        
    }
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher failed: \(error.localizedDescription)")
    }
}
// MARK: - OTSubscriber delegate callbacks
extension WaitingRoomView: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        if let subsView = subscriber?.view {
            subsView.frame = remoteVideoView.frame
            remoteVideoView.addSubview(subsView)
            remoteVideoView.clipsToBounds = true
        }
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
}


