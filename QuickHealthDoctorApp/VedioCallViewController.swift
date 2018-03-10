//
//  VedioCallViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 19/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import OpenTok

class VideoCallViewController: UIViewController,OTSessionDelegate {
    lazy var session: OTSession = {
        return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sessionDidConnect(_ session: OTSession) {
        <#code#>
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        <#code#>
    }

}
