//
//  ZXSpecHeaderCollectionReusableView.swift
//  rbstore
//
//  Created by screson on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXSpecHeaderCollectionReusableView: UICollectionReusableView {
    
    let lbText = ZXUILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.lbText.typeIndex = 1
        self.lbText.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.addSubview(lbText)
        let leading = NSLayoutConstraint(item: self.lbText, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: self.lbText, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.lbText, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.lbText, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([top,leading,trailing,bottom])
        self.lbText.text = ""
        
        let line = UIImageView()
        line.backgroundColor = UIColor.clear
        line.image = #imageLiteral(resourceName: "line")
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(line)
        
        let leading1 = NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing1 = NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let height1 = NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let bottom1 = NSLayoutConstraint(item: line, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5)
        self.addConstraints([leading1,trailing1,bottom1,height1])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
