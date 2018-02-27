//
//  RBMyOrderCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMyOrderCell: UITableViewCell {
    
    static let RBMyOrderCellID:String = "RBMyOrderCell"
    
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsTitleLB: UILabel!
    @IBOutlet weak var spceLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.goodsTitleLB.font = UIFont.zx_bodyFont
        self.goodsTitleLB.textColor = UIColor.zx_textColorBody
        
        self.spceLB.font = UIFont.zx_bodyFont
        self.spceLB.textColor = UIColor.zx_textColorMark
        
        self.priceLB.font = UIFont.zx_bodyFont
        self.priceLB.textColor = UIColor.zx_colorWithHexString("#fd4545")
    }
    
    func loadData(_ model: RBOrderDetailModel) {
        self.goodsTitleLB.text = model.productName
        self.goodsImg.kf.setImage(with: URL.init(string: model.mainUrl), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        self.spceLB.text = model.specNames
        self.priceLB.text = String.init(format: "￥%.2f x %d", model.price,model.num)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
