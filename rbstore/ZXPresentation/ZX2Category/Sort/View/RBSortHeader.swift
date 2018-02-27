//
//  RBSortHeader.swift
//  rbstore
//
//  Created by 120v on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol RBSortHeaderDelegate: NSObjectProtocol {
    func didMoreButtonAction(_ sender: UIButton, _ sectionIndex: NSInteger)
}

class RBSortHeader: UICollectionReusableView {
    
    static let RBSortHeaderID:String = "RBSortHeader"
    weak var delegate: RBSortHeaderDelegate?
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var moreBTN: UIButton!
    @IBOutlet weak var moreBTN2: UIButton!
    @IBOutlet weak var sepeatorLine: UIView!
    var sectionIndex: NSInteger = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLB.font = UIFont.zx_bodyFont
        self.titleLB.textColor = UIColor.zx_textColorBody
        self.titleLB.text = ""
        
        self.moreBTN.isSelected = false
        self.moreBTN2.isSelected = false
        
        self.sepeatorLine.backgroundColor = UIColor.clear
        self.sepeatorLine.layer.insertSublayer(self.dashedLineLayer, at: 0)
    }
    
    func loadData(_ model: RBSortRootModel , _ index: NSInteger) {
        
        self.titleLB.text = model.name
        self.sectionIndex = index
        
        if model.fieldOptionList.count > 6 {
            self.moreBTN.isHidden = false
            self.moreBTN2.isHidden = false
            if model.isSelected {
                self.moreBTN.isSelected = true
                self.moreBTN2.isSelected = true
            }else{
                self.moreBTN.isSelected = false
                self.moreBTN2.isSelected = false
            }
        }else{
            self.moreBTN.isHidden = true
            self.moreBTN2.isHidden = true
        }
    }
    
    @IBAction func moreBTNAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if delegate != nil {
            delegate?.didMoreButtonAction(sender,self.sectionIndex)
        }
    }
    
    fileprivate var dashedLineLayer: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: ZXBOUNDS_WIDTH * (1 - SortViewGap_Scale) - 28, height: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: ZXBOUNDS_WIDTH * (1 - SortViewGap_Scale) - 28, y: 1))
        shapeLayer.path = path
        return shapeLayer
    }()
}
