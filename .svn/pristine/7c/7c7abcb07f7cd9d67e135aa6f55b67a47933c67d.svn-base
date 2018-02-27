//
//  ZXBuyCountCCVCell.swift
//  rbstore
//
//  Created by screson on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit



class ZXBuyCountCCVCell: UICollectionViewCell {

    var delegate:ZXCartControlProtocol?
    
    @IBOutlet weak var lbNum: ZXUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func subAction(_ sender: Any) {
        delegate?.zxCartSubOne(for: self)
    }
    
    @IBAction func plusAction(_ sender: Any) {
        delegate?.zxCartAddOne(for: self)
    }
}
