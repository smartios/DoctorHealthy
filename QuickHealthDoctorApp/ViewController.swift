//
//  ViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS142 on 18/09/17.
//  Copyright © 2017 SS142. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var nurseImage: UIImageView!
    @IBOutlet weak var doctorImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nurseImage.layer.cornerRadius = nurseImage.frame.width/2
        nurseImage.layer.borderWidth = 1.0
        nurseImage.layer.borderColor = UIColor.white.cgColor
        nurseImage.clipsToBounds = true
        doctorImage.layer.cornerRadius = nurseImage.frame.width/2
        doctorImage.clipsToBounds = true
        doctorImage.layer.borderWidth = 1.0
        doctorImage.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func SignupButtonClicked(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

