//
//  ZXGoodsDetailInfoCell.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


/// 商品名称 价格基本信息
class ZXGoodsDetailInfoCell: UITableViewCell {

    @IBOutlet weak var lbName: ZXUILabel!
    @IBOutlet weak var lbSubTile: ZXUILabel!
    
    @IBOutlet weak var lbPrice: ZXUILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.lbSubTile.textColor = UIColor.zx_textColorMark
        self.lbPrice.textColor = UIColor.zx_customAColor
        
        self.lbName.text = ""
        self.lbSubTile.text = ""
        self.lbPrice.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData(_ model: ZXGoodsDetailModel?) {
        self.lbName.text = ""
        self.lbSubTile.text = ""
        self.lbPrice.text = ""
        if let m = model,let p = m.product {
            self.lbName.text = p.title
            self.lbSubTile.text = p.subtitle
            if let selectedSpec = m.zx_selectedSpecCombo {
                self.lbPrice.text = String.init(format: "%0.2f", selectedSpec.salePrice).zx_priceString()
            } else {
                self.lbPrice.text = String.init(format: "%0.2f", p.salePrice).zx_priceString()
            }
        }
    }
    
}
