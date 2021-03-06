//
//  RBCategoryNomalCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol RBCategoryNomalCellDelegate: NSObjectProtocol {
    func didSelectedNomalCellJoinCar(_ sender: UIButton , _ model: ZXGoodsModel)
}

class RBCategoryNomalCell: UICollectionViewCell {
    
    static let RBCategoryNomalCellID: String = "RBCategoryNomalCell"
    weak var delegate: RBCategoryNomalCellDelegate?
    @IBOutlet weak var goodImg: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var costLB: UILabel!
    @IBOutlet weak var joinCarBTN: ZXUIButton!
    var goodModel: ZXGoodsModel!
    
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if UIDevice.zx_DeviceSizeType() == .s_4_0Inch {
//            self.btnWidth.constant = 70
//            self.btnHeight.constant = 24
//        } else {
//            self.btnWidth.constant = 100
//            self.btnHeight.constant = 30
//        }
        
        self.joinCarBTN.layer.cornerRadius = 3.0
        self.joinCarBTN.layer.masksToBounds = true
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameLB.text = ""
        
        self.costLB.font = UIFont.zx_bodyFont
        self.costLB.textColor = UIColor.zx_colorWithHexString("#fd4545")
        self.costLB.text = ""
    }
    
    func loadData(_ model: ZXGoodsModel) {
        self.goodModel = model
        self.goodImg.kf.setImage(with: URL.init(string: model.mainUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        self.nameLB.text = model.title
        self.costLB.text = String.init(format: "￥%.2f", model.salePrice)
    }
    
    
    @IBAction func joinCarBTNAction(_ sender: UIButton) {
        if delegate != nil {
            self.delegate?.didSelectedNomalCellJoinCar(sender, self.goodModel)
        }
    }

}
