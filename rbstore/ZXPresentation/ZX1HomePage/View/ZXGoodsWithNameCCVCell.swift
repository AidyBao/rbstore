//
//  ZXGoodsWithNameCCVCell.swift
//  rbstore
//
//  Created by screson on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


/// CCVCell 图片+名称
class ZXGoodsWithNameCCVCell: UICollectionViewCell {

    @IBOutlet weak var imgvIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.zx_subTintColor
        self.imgvIcon.backgroundColor = UIColor.white
        self.lbName.font = UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 2)
        self.lbName.textColor = UIColor.zx_textColorBody
        self.lbName.text = ""
    }
    
    func reloadData(_ model:ZXRecommendGoodsModel) {
        self.imgvIcon.image = nil
        self.lbName.text = model.title
        self.imgvIcon.kf.setImage(with: URL(string:model.mainUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
    }

}
