//
//  ZXSingleTextCell.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXSingleTextCell: UITableViewCell {

    @IBOutlet weak var lbText: ZXUILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        lbText.typeIndex = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(_ text:String,color:UIColor = UIColor.zx_tintColor) {
        self.lbText.text = text
        self.lbText.textColor = color
    }
}
