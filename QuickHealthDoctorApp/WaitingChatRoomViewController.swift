//
//  WaitingChatRoomViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 20/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class ChatMessageGroup{
    var messageCount = 0
    var messages:[Message] = []{
        didSet{
            self.messageCount = messages.count
        }
    }
}

class Message {
    var message:String = ""
    var senderName:String = ""
    var user_id:String = ""
    var time:String = ""
    init(json:NSDictionary) {
        self.message = json.object(forKey: "data") as! String
        self.senderName = json.object(forKey: "senderName") as! String
        if json.object(forKey: "user_id") != nil{
            self.user_id = json.object(forKey: "user_id") as! String
        }
    }
    init() {
    }
}

protocol WaitingChatRoomDelegate {
    func messageToSend(jsonString:String)
}

class WaitingChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var chatTableView: UITableView!{
        didSet{
            chatTableView.estimatedRowHeight = 80
            chatTableView.rowHeight = UITableViewAutomaticDimension
            chatTableView.register(UINib(nibName: "OwnMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ownMessageCell")
            chatTableView.register(UINib(nibName: "PartnerMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "partnerTextCell")
        }
    }
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
   
    @IBOutlet var messageTextView: UITextView!{
        didSet{
            messageTextView.text = "Write a reply..."
        }
    }
    var placeholder: String{
        get{
            return "Write a reply..."
        }
    }
    
    @IBOutlet weak var sendButton: UIButton!
    
    var delegate:WaitingChatRoomDelegate!
    
    var messagesData = ChatMessageGroup(){
        didSet{
            self.chatTableView.reloadData()
            self.scrollToBottom()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTapGestureOnScreen(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func removeTapGesture(){
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func scrollToBottom() {
        
        if messagesData.messageCount>0{
            let indexPath = IndexPath(row: (messagesData.messageCount - 1), section: 0)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK:- Send button Action
    @IBAction func onClickedSendButton(_ sender: UIButton) {
        
        if self.messageTextView.text == "Write a reply..."
        {
            return
        }else if self.messageTextView.text.trimmingCharacters(in: .whitespaces).count == 0{
            self.messageTextView.text = ""
            return
        }
        let recieverDict = NSMutableDictionary()
        recieverDict.setValue(self.messageTextView.text.trimmingCharacters(in: .whitespaces), forKey: "data")
        recieverDict.setValue((UserDefaults.standard.object(forKey: "user_detail") as! NSDictionary).object(forKey: "first_name") as! String, forKey: "senderName")
        recieverDict.setValue(UserDefaults.standard.object(forKey: "user_id") as! String, forKey: "user_id")
        
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: recieverDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
            print(tempJson)
            self.delegate.messageToSend(jsonString: tempJson as String)
        }catch let error as NSError{
            print(error.description)
        }
        self.view.endEditing(true)
        self.messageTextView.text = placeholder
    }
    
    // MARK: - Keyboard Notification
    @objc func keyboardWillShow(_ notification: NSNotification)
    {
        if let userInfo = (notification as NSNotification).userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double{
                    self.bottomConstraints.constant = keyboardSize.height
                    UIView.animate(withDuration: keyboardDuration, animations: {
                        self.view.layoutIfNeeded()
                    })
                }else{
                    self.bottomConstraints.constant = keyboardSize.height
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
                
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        
    }
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        
        if let userInfo = (notification as NSNotification).userInfo
        {
            if let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double{
                self.bottomConstraints.constant = 0
                UIView.animate(withDuration: keyboardDuration, animations: {
                    self.view.layoutIfNeeded()
                })
            }else{
                self.bottomConstraints.constant = 0
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }else{
            bottomConstraints.constant = 0
        }
        
    }
    // MARK: - UITableView DataSource/Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesData.messageCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if   self.messagesData.messages[indexPath.row].user_id  != UserDefaults.standard.object(forKey: "user_id") as! String{
            cell = tableView.dequeueReusableCell(withIdentifier: "partnerTextCell") as! PartnerMessageTableViewCell
            self.cellForPartnerMessage(cell, indexPath: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "ownMessageCell") as! OwnMessageTableViewCell
            self.cellForOwnMessage(cell, indexPath: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Partner Cell
    func cellForPartnerMessage(_ cell: UITableViewCell, indexPath: IndexPath)
    {
        let messageLabel = cell.viewWithTag(2) as! UILabel
        let messageTimeLabel = cell.viewWithTag(3) as! UILabel
        messageLabel.text = self.messagesData.messages[indexPath.row].message
        messageTimeLabel.text = self.messagesData.messages[indexPath.row].time
    }
    
    // MARK: - Own Cell
    func cellForOwnMessage(_ cell: UITableViewCell, indexPath: IndexPath)
    {
        let messageLabel = cell.viewWithTag(12) as! UILabel
        let messageTimeLabel = cell.viewWithTag(13) as! UILabel
        messageLabel.text = self.messagesData.messages[indexPath.row].message
        messageTimeLabel.text = self.messagesData.messages[indexPath.row].time
    }

    // MARK: - UITextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.text == placeholder{
            messageTextView.text = ""
        }
        self.addTapGestureOnScreen()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if messageTextView.intrinsicContentSize.height>200 && messageTextView.isScrollEnabled == false{
            messageTextView.isScrollEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text == ""{
            textView.text = placeholder
        }
        self.removeTapGesture()
    }
}

