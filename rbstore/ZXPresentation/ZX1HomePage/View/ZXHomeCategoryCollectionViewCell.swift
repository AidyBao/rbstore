//
//  ZXHomeCategoryCollectionViewCell.swift
//  rbstore
//
//  Created by screson on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXHomeCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgvIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbName.font = UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 2)
        self.lbName.textColor = UIColor.zx_textColorTitle
        self.imgvIcon.image = nil
        self.lbName.text = ""
    }
    
    func reloadData(_ model:ZXShortCategoryModel) {
        self.imgvIcon.kf.setImage(with: URL(string: model.mainUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        self.lbName.text = model.title
    }
}
