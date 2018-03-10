//
//  FilePreviewViewController.swift
//  KBAmPower
//
//  Created by SS042 on 04/01/18.
//  Copyright © 2018 SS042. All rights reserved.
//

import UIKit
import WebKit

class FilePreviewViewController: UIViewController,UIWebViewDelegate {

    
    @IBOutlet var webView: UIWebView!
   
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var urlToLoad:URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.loadRequest(NSURLRequest(url: urlToLoad) as URLRequest)
        
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
