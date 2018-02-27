//
//  ZXCButton.swift
//  rbstore
//
//  Created by screson on 2017/7/25.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

@IBDesignable
class ZXCButton: ZXRButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    fileprivate var shaperLayer = CAGradientLayer()
    @IBInspectable  var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius  = cornerRadius
//            layer.masksToBounds = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layer = self.layer as? CAGradientLayer {
            if isEnabled {
                layer.colors = [UIColor.zx_colorRGB(116, 116, 230, 1.0).cgColor,UIColor.zx_colorRGB(98, 98, 225, 1.0).cgColor]
                layer.locations = [NSNumber.init(value: 0),NSNumber.init(value: 1)]
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint = CGPoint(x: 1, y: 0.5)
            } else {
                layer.colors = [UIColor.lightGray.cgColor,UIColor.lightGray.cgColor]
                layer.locations = [NSNumber.init(value: 0),NSNumber.init(value: 1)]
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint = CGPoint(x: 1, y: 0.5)
            }
        }
    }
    
    override func configUI() {
        super.configUI()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
    }
}
