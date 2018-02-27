//
//  RBCategorySubHeader.swift
//  rbstore
//
//  Created by 120v on 2017/7/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBCategorySubHeader: UICollectionReusableView {
    
    static let RBCategorySubHeaderID: String = "RBCategorySubHeader"
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var sepeatorLine: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLB.font = UIFont.zx_markFont
        self.nameLB.textColor = UIColor.zx_textColorTitle
        self.nameLB.text = ""
        
        self.sepeatorLine.backgroundColor = UIColor.clear
        self.sepeatorLine.layer.insertSublayer(self.dashedLineLayer, at: 0)
    }
    
    func loadData(_ model: RBCatetoryChildrenModel) {
        self.nameLB.text = model.name
    }
    
    fileprivate var dashedLineLayer: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH * (1 - TableViewGap_Scale) - 35 - 25, height: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: ZXBOUNDS_WIDTH * (1 - TableViewGap_Scale) - 35 - 25, y: 1))
        shapeLayer.path = path
        return shapeLayer
    }()

}
