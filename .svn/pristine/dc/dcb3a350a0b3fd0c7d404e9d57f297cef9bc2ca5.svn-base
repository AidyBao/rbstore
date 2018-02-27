//
//  RBCollectCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBCollectCell: UITableViewCell {
    
    static let RBCollectCellID: String = "RBCollectCell"
    
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var specsLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var statusImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUIStyle()
    }
    
    func setUIStyle() -> Void {
        self.titleLB.font = UIFont.zx_bodyFont
        self.titleLB.textColor = UIColor.zx_textColorBody
        
        self.specsLB.font = UIFont.zx_bodyFont
        self.specsLB.textColor = UIColor.zx_textColorMark
        
        self.priceLB.font = UIFont.zx_bodyFont
        self.priceLB.textColor = UIColor.red
        
        self.statusImg.isHidden = true
    }
    
    func loadData(_ model: RBMyCollectModel) {
        self.titleLB.text = model.title
        
        self.statusImg.isHidden = true
        switch model.status {
        case 0://已失效
            self.statusImg.isHidden = false
            self.statusImg.image = #imageLiteral(resourceName: "zx-goods-invalid")
        case 1://无货
            self.statusImg.isHidden = false
            self.statusImg.image = #imageLiteral(resourceName: "zx-goods-soldOut")
        case 2://下架
            self.statusImg.isHidden = false
            self.statusImg.image = #imageLiteral(resourceName: "zx-goods-notexist")
        default:
            break
        }
        
//        if model.skuCode == "" {//是否下架
//            self.statusImg.isHidden = false
//            self.statusImg.image = #imageLiteral(resourceName: "zx-goods-notexist")
//        }else{
//            if model.stock == 0 {//库存
//                self.statusImg.isHidden = false
//                self.statusImg.image = #imageLiteral(resourceName: "zx-goods-soldOut")
//            }
//        }
        
        self.goodsImg.kf.setImage(with: URL.init(string: model.mainUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        
        self.titleLB.text = model.title
        self.specsLB.text = model.specValues
        self.priceLB.text = String.init(format: "￥%.2f",model.salePrice)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
