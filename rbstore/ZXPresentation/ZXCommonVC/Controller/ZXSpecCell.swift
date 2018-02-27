//
//  ZXSpecCell.swift
//  rbstore
//
//  Created by screson on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXSpecCell: UICollectionViewCell {

    @IBOutlet weak var lbSpecName: ZXUILabel!
    
    var specItem:ZXSpecItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.borderColor = UIColor.zx_borderColor.cgColor
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 12
        self.lbSpecName.text = ""
    }
    
    func reloadData(_ item:ZXSpecItem?) {
        self.specItem = item
        self.lbSpecName.text = ""
        if let item = self.specItem {
            self.lbSpecName.text = item.value
            if item.zx_isSelected {
                self.contentView.backgroundColor = UIColor.zx_tintColor
                self.lbSpecName.textColor = UIColor.white
                self.contentView.layer.borderColor = UIColor.clear.cgColor
            } else {
                self.contentView.backgroundColor = UIColor.white
                self.lbSpecName.textColor = UIColor.zx_textColorBody
                self.contentView.layer.borderColor = UIColor.zx_textColorBody.cgColor
            }
            if !item.zx_isSelected {//避免覆盖已选择的状态
                switch item.zx_selectType {
                    case .valid:
                        self.lbSpecName.textColor = UIColor.zx_textColorBody
                        self.contentView.backgroundColor = UIColor.white
                        self.contentView.layer.borderWidth = 0.5
                        self.contentView.layer.borderColor = UIColor.zx_textColorBody.cgColor
//                    case .soldOut:
//                        self.lbSpecName.textColor = UIColor.lightGray
//                        self.contentView.layer.borderWidth = 0.5
//                        self.contentView.layer.borderColor = UIColor.zx_textColorBody.cgColor
                    case .soldOut,.notExist:
                        self.lbSpecName.textColor = UIColor.lightGray
                        self.contentView.backgroundColor = UIColor.zx_backgroundColor
                        self.contentView.layer.borderWidth = 0.5
                        self.contentView.layer.borderColor = UIColor.clear.cgColor
                }
            }
            switch item.zx_selectType {
                case .valid:
                    self.isUserInteractionEnabled = true
                case .soldOut:
                    self.isUserInteractionEnabled = true
                case .notExist:
                    self.isUserInteractionEnabled = false
            }
        }
    }
}
