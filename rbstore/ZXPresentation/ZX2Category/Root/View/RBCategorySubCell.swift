//
//  RBCategorySubCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBCategorySubCell: UICollectionViewCell {
    
    static let RBCategorySubCellID: String = "RBCategorySubCell"
    
    @IBOutlet weak var goodImg: UIImageView!
    @IBOutlet weak var nameLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLB.font = UIFont.zx_bodyFont(14)
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameLB.text = ""
    }
    
    func loadData(_ model: RBCatetorySubModel) {
        self.goodImg.kf.setImage(with: URL.init(string: model.fileUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        self.nameLB.text = model.name
    }

}
