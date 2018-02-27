//
//  RBMyOrderHeader.swift
//  rbstore
//
//  Created by 120v on 2017/9/8.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMyOrderHeader: UITableViewCell {
    
    static let RBMyOrderHeaderID: String = "RBMyOrderHeader"
    @IBOutlet weak var contentMaskView: ZXUIView!
    @IBOutlet weak var dataLB: UILabel!
    @IBOutlet weak var statusLB: UILabel!
    @IBOutlet weak var sepeatorLine: UIImageView!
    var orderRootModel: RBOrderRootModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataLB.font = UIFont.zx_bodyFont
        self.dataLB.textColor = UIColor.zx_textColorBody
        
        self.statusLB.font = UIFont.zx_bodyFont
        self.statusLB.textColor = UIColor.zx_tintColor
    }
    
    func loadData(_ model: RBOrderRootModel) {
        self.orderRootModel = model
        if model.orderDateStr.isEmpty == false {
            let date = model.orderDateStr.substring(with: Range.init(uncheckedBounds: (lower: 0, upper: 10)))
            self.dataLB.text = "\(date)"
        }else{
            self.dataLB.text = ""
        }
        if model.orderStatus == 1 {
            if model.payStatus == 1 {
                self.statusLB.text = model.payStatusStr
            }else{
                self.statusLB.text = model.orderStatusStr
            }
        }else{
            self.statusLB.text = model.orderStatusStr
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
