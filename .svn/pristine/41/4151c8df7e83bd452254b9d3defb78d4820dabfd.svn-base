//
//  ZXGoodsDetailParamsHeader.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


protocol ZXGoodsDetailParamsHeaderDelegate: class {
    func zxGoodsDetailParamsHeaderTapAt(_ postion:ZXNavBarButtonItemPosition)
}

extension ZXGoodsDetailParamsHeaderDelegate {
    func zxGoodsDetailParamsHeaderTapAt(_ postion:ZXNavBarButtonItemPosition) {}
}

/// Description
class ZXGoodsDetailParamsHeader: UITableViewHeaderFooterView {
    
    weak var delegate:ZXGoodsDetailParamsHeaderDelegate?
    
    var btnLeft = UIButton(type: .custom)
    var btnRight = UIButton(type: .custom)
    
    fileprivate var imgLine = UIImageView()
    
    var vLine = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(btnLeft)
        self.contentView.addSubview(btnRight)
        self.contentView.addSubview(vLine)
        self.contentView.addSubview(imgLine)
        
        self.imgLine.contentMode = .scaleToFill
        self.imgLine.clipsToBounds = true
        self.imgLine.image = #imageLiteral(resourceName: "line")
        
        self.vLine.backgroundColor = UIColor.zx_colorRGB(201, 212, 218, 1)
        
        self.btnLeft.translatesAutoresizingMaskIntoConstraints = false
        self.btnRight.translatesAutoresizingMaskIntoConstraints = false
        self.vLine.translatesAutoresizingMaskIntoConstraints = false
        self.imgLine.translatesAutoresizingMaskIntoConstraints = false

        
        let leading = NSLayoutConstraint(item: self.btnLeft, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.btnLeft, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.btnLeft, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: self.btnLeft, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 0.5, constant: 0)
        self.contentView.addConstraints([leading,top,bottom,width])
        
        
        let trailing = NSLayoutConstraint(item: self.btnRight, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0)
        let center = NSLayoutConstraint(item: self.btnRight, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: self.btnRight, attribute: .height, relatedBy: .equal, toItem: self.btnLeft, attribute: .height, multiplier: 1, constant: 0)
        let width2 = NSLayoutConstraint(item: self.btnRight, attribute: .width, relatedBy: .equal, toItem: self.btnLeft, attribute: .width, multiplier: 1.0, constant: 0)
        self.contentView.addConstraints([trailing,center,height,width2])
        
        self.btnLeft.titleLabel?.font = UIFont.zx_bodyFont
        self.btnLeft.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.btnLeft.setTitleColor(UIColor.zx_tintColor, for: .highlighted)
        self.btnLeft.setTitleColor(UIColor.zx_tintColor, for: .selected)
        self.btnLeft.setTitle("商品详情", for: .normal)
        
        self.btnRight.titleLabel?.font = UIFont.zx_bodyFont
        self.btnRight.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.btnRight.setTitleColor(UIColor.zx_tintColor, for: .highlighted)
        self.btnRight.setTitleColor(UIColor.zx_tintColor, for: .selected)
        self.btnRight.setTitle("商品参数", for: .normal)
        
        self.btnLeft.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.btnRight.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        self.btnLeft.isSelected = true
        
        let lineWidth = NSLayoutConstraint(item: self.vLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let lineHeight = NSLayoutConstraint(item: self.vLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22)
        let lineCenterX = NSLayoutConstraint(item: self.vLine, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let lineCenterY = NSLayoutConstraint(item: self.vLine, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        self.contentView.addConstraints([lineWidth,lineHeight,lineCenterX,lineCenterY])
        
        let imgLineLeading = NSLayoutConstraint(item: self.imgLine, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
        let imgLineHeight = NSLayoutConstraint(item: self.imgLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let imgLineBottom = NSLayoutConstraint(item: self.imgLine, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0)
        let imgLineTrailing = NSLayoutConstraint(item: self.imgLine, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0)
        self.contentView.addConstraints([imgLineLeading,imgLineHeight,imgLineBottom,imgLineTrailing])

        

    }
    
    func leftButtonAction() {
        if self.btnLeft.isSelected {
            return
        }
        self.btnLeft.isSelected = true
        self.btnRight.isSelected = false
        delegate?.zxGoodsDetailParamsHeaderTapAt(.left)
    }
    
    func rightButtonAction() {
        if self.btnRight.isSelected {
            return
        }
        self.btnLeft.isSelected = false
        self.btnRight.isSelected = true
        delegate?.zxGoodsDetailParamsHeaderTapAt(.right)
    }
    
    func reloadSelect(position:ZXNavBarButtonItemPosition) {
        if position == .left {
            self.btnLeft.isSelected = true
            self.btnRight.isSelected = false
        } else {
            self.btnLeft.isSelected = false
            self.btnRight.isSelected = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
