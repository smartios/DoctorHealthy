//
//  PrescriptionBtnView.swift
//  QuickHealthDoctorApp
//
//  Created by Bhoopendra on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class PrescriptionBtnView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var prescriptionBtn: UIButton!
    var delegate:VideoActionButtonDelegate?
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
        Bundle.main.loadNibNamed("PrescriptionBtnView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
    @IBAction func prescriptionBtnClicked(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        self.delegate?.prescriptionBtnClicked(sender)
    }
}
