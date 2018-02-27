//
//  RBMessageDetailHeader.swift
//  rbstore
//
//  Created by 120v on 2017/8/4.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMessageDetailHeader: UITableViewCell {
    
    static let RBMessageDetailHeaderID: String = "RBMessageDetailHeader"
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var dataLB: UILabel!
    @IBOutlet weak var shipNameLB: UILabel!
    @IBOutlet weak var sepeatorLine: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.white
        
        self.titleLB.font = UIFont.zx_bodyFont
        self.titleLB.textColor = UIColor.zx_textColorBody
        self.titleLB.text = ""
        
        self.dataLB.font = UIFont.zx_bodyFont
        self.dataLB.textColor = UIColor.zx_textColorMark
        self.dataLB.text = ""
        
        self.shipNameLB.font = UIFont.zx_bodyFont
        self.shipNameLB.textColor = UIColor.zx_textColorBody
        self.shipNameLB.text = ""
        
        self.sepeatorLine.backgroundColor = UIColor.clear
        self.sepeatorLine.layer.insertSublayer(dashedLineLayer, at: 0)
    }
    
    func loadData(_ model: ZXHomeFloorsModel) {
        self.titleLB.text = model.title
        if model.sendDateStr.characters.count >= 10 {
//            let year = model.sendDateStr.substring(to: 4)
//            let month = model.sendDateStr.substring(with: Range.init(uncheckedBounds: (lower: 5, upper: 7)))
//            let day = model.sendDateStr.substring(with: Range.init(uncheckedBounds: (lower: 8, upper: 10)))
            let date = model.sendDateStr.substring(with: Range.init(uncheckedBounds: (lower: 0, upper: 10)))
            self.dataLB.text = "\(date)"
        }

        self.shipNameLB.text = ""
    }

    fileprivate var dashedLineLayer: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 2*14, height: 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 2))
        path.addLine(to: CGPoint(x: ZXBOUNDS_WIDTH - 2*14, y: 2))
        shapeLayer.path = path
        return shapeLayer
    }()

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
