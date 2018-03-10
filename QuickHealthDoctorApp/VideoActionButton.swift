//
//  VideoActionButton.swift
//  QuickHealthDoctorApp
//
//  Created by Bhoopendra on 19/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit


protocol VideoActionButtonDelegate {
    //Mute unmute action
    func muteUnmutebtnClicked(value:Bool)
    //Switch Camera action
    func switchCameraBtnClicked()
    //Disconnect call action
    func disconnectCallBtnClicked()
    //Chat  btn action
    func chatBtnClicked()
    //Prescription Action
    func prescriptionBtnClicked()
    
    func stopSendingStreamBtnClicked(value:Bool)
}


class VideoActionButton: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var chatBtn: UIButton!
    @IBOutlet var stopStreamBtn: UIButton!
    @IBOutlet var notesBtn: UIButton!
    @IBOutlet var endCallbtn: UIButton!
    @IBOutlet var muteBtn: UIButton!
    
    var delegate:VideoActionButtonDelegate?
    var isCallConnected = false{
        didSet{
            self.showHideButton(isCallConnected)
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        print("override init(frame: CGRect) ")
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("required init?(coder aDecoder: NSCoder)")
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("VideoActionButton", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        self.showHideButton(isCallConnected)
    }
    
    private func showHideButton(_ callConnected:Bool){
        self.chatBtn.isHidden = !callConnected
        self.stopStreamBtn.isHidden = !callConnected
        self.notesBtn.isHidden = !callConnected
        self.endCallbtn.isHidden = false
        self.muteBtn.isHidden = !callConnected
    }
    
    @IBAction func muteBtnClicked(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        self.delegate?.muteUnmutebtnClicked(value: sender.isSelected)
    }
    
    @IBAction func endCallBtnClicked(_ sender: UIButton) {
        self.delegate?.disconnectCallBtnClicked()
    }
  
    @IBAction func prescriptionBtnClicked(_ sender: UIButton) {
        self.delegate?.prescriptionBtnClicked()
    }
    
    @IBAction func chatBtnClicked(_ sender: UIButton) {
        self.delegate?.chatBtnClicked()
    }
    
    @IBAction func switchCameraBtnClicked(_ sender: UIButton) {
        self.delegate?.switchCameraBtnClicked()
    }
    
    @IBAction func stopStreambtnClicked(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        self.delegate?.stopSendingStreamBtnClicked(value:sender.isSelected)
    }
}
