//
//  WaitingRoomViewController.swift
//  QuickHealthDoctorApp
//
//  Created by singsys on 1/24/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import Foundation

protocol PulsingCallDelegate{
    func endCallClicked()
}

class WaitingRoomViewController: UIViewController {

    @IBOutlet var pictureImg: UIImageView!
    @IBOutlet var centerView: UIView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var idLabel : UILabel!
    @IBOutlet var designationLabel : UILabel!
    
    var patientDetail:NSDictionary!
    
    var halo: PulsingHaloLayer  = PulsingHaloLayer()
    var delegate:PulsingCallDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        if patientDetail != nil{
            nameLabel.text = (patientDetail.object(forKey: "patient_name") as! String)
            idLabel.text = (patientDetail.object(forKey: "patient_unique_number") as! String)
            designationLabel.text = ""
        }
        loadgif()
        NotificationCenter.default.addObserver(self, selector: #selector(acceptCall(_:)), name:NSNotification.Name(rawValue: "callRejected"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedToDismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: PULSING HALO
    func loadgif()
    {
        halo.removeFromSuperlayer()
        
        let layer = PulsingHaloLayer()
        
        self.halo = layer
        
        pictureImg.setNeedsLayout()
        pictureImg.layoutIfNeeded()
        
        centerView.setNeedsLayout()
        centerView.layoutIfNeeded()
        
        //self.picView.superview!.layer.insertSublayer(self.halo, below: self.picView.layer)
        
        pictureImg.superview!.layer.insertSublayer(self.halo, below: pictureImg.layer)
        
        halo.haloLayerNumber = 5
        halo.radius = (CGFloat)(pictureImg.frame.size.height)
        halo.animationDuration = 4
        halo.backgroundColor = UIColor.gray.cgColor
        halo.borderWidth = 1.0
        halo.borderColor = UIColor.gray.cgColor
        
        halo.position = pictureImg.center
        
        //self.picView.layer.addSublayer(self.centerView.layer)
        halo.start()
    }

    //MARK: Action Method
    
    @IBAction func acceptCall (_ sender: UIButton)
    {
        self.delegate.endCallClicked()
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "callRejected"), object: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
