//
//  RBMessageDetailCell.swift
//  rbstore
//
//  Created by 120v on 2017/9/5.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMessageDetailCell: UITableViewCell {
    
    static let RBMessageDetailCellID: String = "RBMessageDetailCell"
    
    @IBOutlet weak var detailLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.white
        
        self.detailLB.font = UIFont.zx_bodyFont
        self.detailLB.textColor = UIColor.zx_textColorBody
        self.detailLB.text = ""
        
    }
    
    func loadData(_ content: String) {
        self.detailLB.text = content
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
