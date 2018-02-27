//
//  RBSearchRootCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBSearchRootCell: UICollectionViewCell {
    
    static let RBSearchRootCellID: String = "RBSearchRootCell"
    @IBOutlet weak var nameLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 22/2.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.layer.borderWidth = 1.0
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameLB.text = ""
    }
    
    
    
    func loadData(_ str: String) {
        self.nameLB.text = str 
    }
    
    
    class func getCellSize(_ str: String) -> CGSize {
        let cellSize: CGSize = str.zx_textRectSize(toFont: UIFont.zx_bodyFont, limiteSize: CGSize.init(width: ZXBOUNDS_WIDTH - 30, height: 20.0))
        return cellSize
    }
}
