//
//  RBMessageCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMessageCell: UITableViewCell {
    
    static let RBMessageCellID: String = "RBMessageCell"
    @IBOutlet weak var newFlagView: ZXUIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var dataLB: UILabel!
    @IBOutlet weak var detailLB: UILabel!
//    @IBOutlet weak var newFlagGap: NSLayoutConstraint!
    @IBOutlet weak var titleGap: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUIStyle()
    }
    
    func setUIStyle() -> Void {
        self.titleLB.font = UIFont.zx_bodyFont
        self.titleLB.textColor = UIColor.zx_textColorBody
        
        self.detailLB.font = UIFont.zx_bodyFont
        self.detailLB.textColor = UIColor.zx_textColorMark
        
        self.dataLB.font = UIFont.zx_bodyFont
        self.dataLB.textColor = UIColor.zx_textColorBody
        
        self.newFlagView.isHidden = true
        self.titleGap.constant = 10
    }
    
    func loadData(_ model: RBMessageModel) {
        self.titleLB.text = model.title
        
        if model.isRead == 1 {
            self.newFlagView.isHidden = true
            self.titleGap.constant = 10
        }else{
            self.newFlagView.isHidden = false
            self.titleGap.constant = 20
        }
        
        self.titleLB.text = model.title
        
        
        let current = ZXDateUtils.current.dateAndTime(false, timeWithSecond: true)
        
        let currentDate = current.substring(to: 10)
        if currentDate == model.sendDateStr {
            if current.characters.count != 0 {
                let currentTime = current.substring(with: Range.init(uncheckedBounds: (lower: 11, upper: 16)))
                self.dataLB.text = "\(currentTime)"
            }
        }else{
            if model.sendDateStr.characters.count >= 10 {
//                let year = model.sendDateStr.substring(to: 4)
//                let month = model.sendDateStr.substring(with: Range.init(uncheckedBounds: (lower: 5, upper: 7)))
//                let day = model.sendDateStr.substring(with: Range.init(uncheckedBounds: (lower: 8, upper: 10)))
                let date = model.sendDateStr.substring(with: Range.init(uncheckedBounds: (lower: 0, upper: 10)))
                self.dataLB.text = "\(date)"
            }
        }
        
        self.detailLB.text = model.content
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
