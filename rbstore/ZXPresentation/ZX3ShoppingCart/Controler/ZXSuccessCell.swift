//
//  ZXSuccessCell.swift
//  rbstore
//
//  Created by screson on 2017/7/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXSuccessCell: UITableViewCell {

    var orderModel:ZXShowModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reviewOrder(_ sender: UIButton) {
        ZXRouter.showDetail(type: .orderDetail, model: self.orderModel)
    }
    
    @IBAction func backToHomePage(_ sender: UIButton) {
        ZXRouter.zx_backToHomePage()
    }
}
