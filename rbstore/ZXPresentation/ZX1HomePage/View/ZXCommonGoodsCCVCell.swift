//
//  ZXCommonGoodsCCVCell.swift
//  rbstore
//
//  Created by screson on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


/// 商品Cell
class ZXCommonGoodsCCVCell: UICollectionViewCell {
    
    
//    @IBOutlet weak var btnWidth: NSLayoutConstraint!
//    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btnAddtoCart: UIButton!
    fileprivate var goodsModel:ZXRecommendGoodsModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        
        self.imgIcon.backgroundColor = UIColor.white
        
        self.lbName.font = UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 2)
        self.lbName.textColor = UIColor.zx_textColorBody
        self.lbPrice.font = UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 1)
        self.lbPrice.textColor = UIColor.zx_customAColor
        self.lbPrice.adjustsFontSizeToFitWidth = true
        
        self.lbName.text = ""
        self.lbPrice.text = ""
        
//        if UIDevice.zx_DeviceSizeType() == .s_4_0Inch {
//            self.btnWidth.constant = 70
//            self.btnHeight.constant = 24
//        } else {
//            self.btnWidth.constant = 100
//            self.btnHeight.constant = 30
//        }
        self.btnAddtoCart.layer.cornerRadius = 3
        self.btnAddtoCart.layer.masksToBounds = true
    }
    
    func reloadData(_ model:ZXRecommendGoodsModel) {
        self.goodsModel = model
        self.imgIcon.image = nil
        self.lbName.text = model.title
        self.lbPrice.text = String.init(format: "%0.2f", model.salePrice).zx_priceString()
        self.imgIcon.kf.setImage(with: URL(string:model.mainUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        ZXBSControl.addToCart(self.goodsModel)
    }
}
