//
//  RBAgeRootCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBAgeRootCell: UITableViewCell {
    
    static let RBAgeRootCellID: String = "RBAgeRootCell"
    
    @IBOutlet weak var contentMaskView: UIView!
    @IBOutlet weak var ageLB: UILabel!
    @IBOutlet weak var selectedBTN: ZXUIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.ageLB.font = UIFont.zx_bodyFont
        self.ageLB.textColor = UIColor.zx_textColorBody
    }
    
    func loadCell(indexPath cellIndexPath: IndexPath , _ model: RBAgeGroupModel) {
        self.ageLB.text = model.value
        if model.isSelected {
            self.selectedBTN.isSelected = true
        }else{
            self.selectedBTN.isSelected = false
        }
        switch cellIndexPath.row {
        case 0:
            self.contentMaskView.layer.mask = self.topLayer
        case 4:
            self.contentMaskView.layer.mask = self.bottomLayer
        default:
            break
        }
    }
    
    var topLayer: CAShapeLayer = {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 51.5), byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let layer: CAShapeLayer = CAShapeLayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 51.5)
        layer.path = maskPath.cgPath
        return layer
    }()
    
    var bottomLayer: CAShapeLayer = {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 51.5), byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let layer: CAShapeLayer = CAShapeLayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 51.5)
        layer.path = maskPath.cgPath
        return layer
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
