//
//  String+Predicate.swift
//  rbstore
//
//  Created by 120v on 2017/8/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension String {
    
    //可使用汉字、英文、数字及下划线,不包含汉字符合、英文符号
    public func zx_predicateNickname() -> Bool {
        let pattern = "(^[\\u4E00-\\u9FA5A-Za-z0-9_]+$)"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
}
