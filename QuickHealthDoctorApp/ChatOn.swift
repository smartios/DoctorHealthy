//
//  ChatOn.swift
//  DAWProvider
//
//  Created by SS142 on 26/04/17.
//
//

import UIKit
import OpenTok

class ChatOn: UIViewController ,UITableViewDelegate , UITableViewDataSource , UITextViewDelegate , UIGestureRecognizerDelegate,UINavigationControllerDelegate,OTSessionDelegate {
    
    var session = OTSession ()
    @IBOutlet weak var yourMessage: UILabel!
    @IBOutlet weak var userName: UILabel!
    var page = 1
    var message = String()
    @IBOutlet var bottomConst: NSLayoutConstraint!
    @IBOutlet var fotterview: UIView!
    @IBOutlet var headerView: UIView!
    var refreshControl:UIRefreshControl!
    var chatMessages = [[String: AnyObject]]()
    @IBOutlet var tblChat:UITableView!
    @IBOutlet weak var tvMessageEditor: UITextView!
    var dateFormatter = DateFormatter()
    var message_type = String()
    var tapGesture =  UITapGestureRecognizer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var avatarId = ""
    @IBOutlet var messageLable: UILabel!
    @IBOutlet weak var chatTextViewForColor: UIView!
    var tap =  UITapGestureRecognizer()
    var ImageOpen = false
    
    //MARK:- SYSTEM GENRATED FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTextViewForColor.layer.borderWidth = 1.5
        chatTextViewForColor.layer.borderColor = UIColor(red: 136.0 / 255.0, green: 216.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0).cgColor
        tblChat.rowHeight = UITableViewAutomaticDimension
        tblChat.estimatedRowHeight = 120
        NotificationCenter.default.addObserver(self, selector: #selector(ChatOn.handleKeyboardDidShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatOn.handleKeyboardDidHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
    }
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
    }
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        print(string!)
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tvMessageEditor.text = ""
        if appDelegate.chatmessages.count > 0
        {
            tblChat.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(CGFloat.greatestFiniteMagnitude))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //tblChat.reloadData()
    }
    
    //MARK:- TEXTVIEW DELEGATE AND DATASOURCE
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        messageLable.isHidden = true
        tapGesture =  UITapGestureRecognizer(target: self, action: #selector(ChatOn.dismissKeyboard))
        tblChat.addGestureRecognizer(tapGesture)
        if appDelegate.chatmessages.count > 0
        {
            tblChat.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(CGFloat.greatestFiniteMagnitude))
        }
        return true
    }
    func textViewDidEndEditing( _ textView: UITextView){
        if tvMessageEditor == nil || tvMessageEditor.text == ""
        {
            messageLable.isHidden = false
            scrollToBottom()
        }
        else
        {
            messageLable.isHidden = true
            scrollToBottom()
        }
        tblChat.removeGestureRecognizer(tapGesture)
    }
    
    func handleKeyboardDidShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
                UIView.animate(withDuration: keyboardDuration!, delay: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations:
                    {
                        self.bottomConst.constant = keyboardFrame.size.height-30
                        //self.scrollToBottom()
                }, completion: {
                    (finished: Bool) in
                })
            }
        }
    }
    func handleKeyboardDidHideNotification(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        UIView.animate(withDuration: keyboardDuration!, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations:
            {
                self.bottomConst.constant = 30
                //self.scrollToBottom()
        }, completion: {
            (finished: Bool) in
        })
        
    }
    
    func scrollToBottom() {
        
        if appDelegate.chatmessages.count>0
        {
            let indexPath = IndexPath(row: (appDelegate.chatmessages.count - 1), section: 0)
            tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        messageLable.isHidden = true
        if text == "\n"
        {
            textView.resignFirstResponder()
            sendButtonPressed()
        }
        return true
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func sendButtonPressed() {
        let text: String = tvMessageEditor.text.trimmingCharacters(in: .whitespaces)
        if (text.characters.count ) == 0 {
            return
        }
        tvMessageEditor.text = ""
        var error: OTError?
        messageLable.isHidden = false
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(text, forKey: "data")
        recieverDict.setValue(UserDefaults.standard.object(forKey: "first_name") as! String, forKey: "senderName")
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
        session.signal(withType: "message", string: tempJson as String, connection: nil, retryAfterReconnect: true, error: &error)
        
    }
    
    //MARK:- SINCH CHAT DELEGATE
    
    //MARK:- TABLEVIEW DELEGATE AND DATASOURCE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        var cell: UITableViewCell!
        if   appDelegate.chatmessages.count>0 &&  (appDelegate.chatmessages.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String != UserDefaults.standard.object(forKey: "user_id") as! String
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "otheruser", for: indexPath)
            let messageLbl = cell.viewWithTag(1) as! UILabel
            let imageview = cell.viewWithTag(21) as! UIImageView
            imageview.layer.cornerRadius = 6
            messageLbl.text = (appDelegate.chatmessages.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as? String
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
            let messageLbl = cell.viewWithTag(1) as! UILabel
            let imageview = cell.viewWithTag(21) as! UIImageView
            imageview.layer.cornerRadius = 6
            if appDelegate.chatmessages.count>0
            {
                messageLbl.text = (appDelegate.chatmessages.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as? String
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return appDelegate.chatmessages.count
    }
    
    private func tableView(_tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    }
}


