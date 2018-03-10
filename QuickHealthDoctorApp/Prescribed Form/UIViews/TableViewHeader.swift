//
//  TableViewHeader.swift
//  QuickHealthDoctorApp
//
//  Created by SL036 on 23/02/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit

class TableViewHeader: UIView {
    
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed("TableViewHeader", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
}
