//
//  RBModifySexCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBModifySexCell: UITableViewCell {
    
    static let RBModifySexCellID: String = "RBModifySexCell"
    
    @IBOutlet weak var contenMaskView: UIView!
    @IBOutlet weak var tileLB: UILabel!
    @IBOutlet weak var selectedBTN: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tileLB.font = UIFont.zx_bodyFont
        self.tileLB.textColor = UIColor.zx_textColorBody
    }
    
    func loadCell(indexPath cellIndexPath: IndexPath , sex sexStr: String) {
       
        switch cellIndexPath.row {
        case 0:
            self.contenMaskView.layer.mask = self.topLayer
            self.tileLB.text = "男"
            if sexStr.isEqual(self.tileLB.text) {
                self.selectedBTN.isSelected = true
            }else{
                self.selectedBTN.isSelected = false
            }
        case 1:
            self.contenMaskView.layer.mask = self.bottomLayer
            self.tileLB.text = "女"
            if sexStr.isEqual(self.tileLB.text) {
                self.selectedBTN.isSelected = true
            }else{
                self.selectedBTN.isSelected = false
            }
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
