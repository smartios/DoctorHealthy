//
//  ExtendVideoCallViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 22/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

enum ExtendVideoAction {
    case Free
    case Paid
    case Thanks
}
protocol ExtendVideoDelegate {
    func didSelectOnExtendVideoAction(_ action: ExtendVideoAction)
}
class ExtendVideoCallViewController: UIViewController {

    @IBOutlet weak var popCotainerView: UIView!{
        didSet{
            popCotainerView.clipsToBounds = true
            popCotainerView.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var freeButton: UIButton!{
        didSet{
            freeButton.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var paidButton: UIButton!{
        didSet{
            paidButton.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var thanksButton: UIButton!{
        didSet{
            thanksButton.layer.cornerRadius = 3
        }
    }
    @IBOutlet var paidHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var crossButton: UIButton!
    var isPaidAvailable:Bool = false{
        didSet{
            if isPaidAvailable{
                self.paidHeightConstraint.constant = 40
            }else{
                self.paidHeightConstraint.constant = 0
            }
        }
    }
    
    var delegate: ExtendVideoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if isPaidAvailable{
//            self.paidHeightConstraint.constant = 40
//        }else{
//            self.paidHeightConstraint.constant = 0
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Cross Action
    @IBAction func onClickedCrossButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    // MARK:- Free button action
    @IBAction func onClickedFreeButton(_ sender: UIButton) {
        delegate?.didSelectOnExtendVideoAction(.Free)
        self.view.removeFromSuperview()
    }
    
    // MARK:- Paid button action
    @IBAction func onClickedPaidButton(_ sender: UIButton) {
        delegate?.didSelectOnExtendVideoAction(.Paid)
        self.view.removeFromSuperview()
    }
    
    // MARK:- Thanks button action
    @IBAction func onClickedThanksButton(_ sender: UIButton) {
        delegate?.didSelectOnExtendVideoAction(.Thanks)
        self.view.removeFromSuperview()
    }
    
}
