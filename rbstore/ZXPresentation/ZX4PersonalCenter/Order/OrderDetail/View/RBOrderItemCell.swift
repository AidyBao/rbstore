//
//  RBOrderItemCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let OrderCell_Height: CGFloat = 110

class RBOrderItemCell: UITableViewCell {

    static let RBOrderItemCellID:String = "RBOrderItemCell"
    
    @IBOutlet weak var contentMask: UIView!
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsTitleLB: UILabel!
    @IBOutlet weak var spceLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.goodsTitleLB.font = UIFont.zx_bodyFont
        self.goodsTitleLB.textColor = UIColor.zx_textColorBody
        self.goodsTitleLB.text = ""
        
        self.spceLB.font = UIFont.zx_bodyFont
        self.spceLB.textColor = UIColor.zx_textColorMark
        self.spceLB.text = ""
        
        self.priceLB.font = UIFont.zx_bodyFont
        self.priceLB.textColor = UIColor.zx_colorWithHexString("#fd4545")
        self.priceLB.text = ""
    }
    
    func loadData(_ model: RBOrderDetailModel,_ indexRow: Int,_ array:NSMutableArray) {
        self.goodsImg.kf.setImage(with: URL.init(string: model.mainUrl), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        self.goodsTitleLB.text = model.productName
        self.spceLB.text = model.specNames
        self.priceLB.text = String.init(format: "￥%.2f x %d", model.price,model.num)
        
        if array.count == 1 {
            self.contentMask.layer.cornerRadius = 5.0
            self.contentMask.layer.masksToBounds = true
        }else{
            if indexRow == 0 {
                self.contentMask.layer.mask = self.topLayer
            }
            
            if indexRow == array.count - 1 {
                self.contentMask.layer.mask = self.bottomLayer
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var topLayer: CAShapeLayer = {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: OrderCell_Height), byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let layer: CAShapeLayer = CAShapeLayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: OrderCell_Height)
        layer.path = maskPath.cgPath
        return layer
    }()
    
    var bottomLayer: CAShapeLayer = {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: OrderCell_Height), byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let layer: CAShapeLayer = CAShapeLayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: OrderCell_Height)
        layer.path = maskPath.cgPath
        return layer
    }()
    
}
