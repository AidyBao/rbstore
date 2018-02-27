//
//  RBSearchHeader.swift
//  rbstore
//
//  Created by 120v on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol RBSearchHeaderDelegate: NSObjectProtocol {
    func didDeletedButtonAction(_ sender: UIButton)
}

class RBSearchHeader: UICollectionReusableView {
    
    static let RBSearchHeaderID: String = "RBSearchHeader"
    weak var delegate: RBSearchHeaderDelegate?
    @IBOutlet weak var titleLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLB.font = UIFont.zx_bodyFont
        self.titleLB.textColor = UIColor.zx_textColorBody
    }
    
    @IBAction func deletedBtnAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.didDeletedButtonAction(sender)
        }
    }
}
