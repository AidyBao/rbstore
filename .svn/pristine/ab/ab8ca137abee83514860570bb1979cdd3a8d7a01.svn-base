//
//  RBSearchCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBSearchCell: UITableViewCell {
    
    static let RBSearchCellID: String = "RBSearchCell"
    @IBOutlet weak var sepeatorLine: UIView!
    @IBOutlet weak var nameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameLB.text = ""
        
        self.sepeatorLine.backgroundColor = UIColor.clear
        self.sepeatorLine.layer.insertSublayer(self.dashedLineLayer, at: 0)
    }
    
    func loadData(_ keyWord: String) {
        self.nameLB.text = keyWord
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate var dashedLineLayer: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 28, height: 0.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: ZXBOUNDS_WIDTH - 28, y: 1))
        shapeLayer.path = path
        return shapeLayer
    }()
    
}
