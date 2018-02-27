//
//  RBCheckLogisticsCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBCheckLogisticsCell: UITableViewCell {
    
    static let RBCheckLogisticsCellID: String = "RBCheckLogisticsCell"
    
    @IBOutlet weak var contentMaskView: UIView!
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var centerView: ZXUIView!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var statusLB: UILabel!
    @IBOutlet weak var dataLB: UILabel!
    @IBOutlet weak var sepeatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.statusLB.font = UIFont.zx_bodyFont
        self.statusLB.textColor = UIColor.zx_textColorBody
        
        self.dataLB.font = UIFont.zx_bodyFont
        self.dataLB.textColor = UIColor.zx_textColorBody
        
        self.sepeatorLine.backgroundColor = UIColor.clear
        self.sepeatorLine.layer.insertSublayer(self.dashedLineLayer, at: 0)
    }
    
    func loadCellStyle(_ indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                self.contentMaskView.layer.mask = self.topLayer
                self.upView.isHidden = true
            case 3:
                self.contentMaskView.layer.mask = self.bottomLayer
                self.downView.isHidden = true
                self.sepeatorLine.isHidden = true
            default:
                break
            }
        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate var dashedLineLayer: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 28 * 2, height: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 1)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: ZXBOUNDS_WIDTH - 28 * 2, y: 1))
        shapeLayer.path = path
        return shapeLayer
    }()
    
    var topLayer: CAShapeLayer = {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 59), byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize.init(width: 5.0, height: 5.0))
        let layer: CAShapeLayer = CAShapeLayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 59)
        layer.path = maskPath.cgPath
        return layer
    }()
    
    var bottomLayer: CAShapeLayer = {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 59), byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 5, height: 5))
        let layer: CAShapeLayer = CAShapeLayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 14*2, height: 59)
        layer.path = maskPath.cgPath
        return layer
    }()
}
