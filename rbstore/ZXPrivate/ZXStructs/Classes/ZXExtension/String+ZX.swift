//
//  String+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/3/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation
import UIKit

let PASSWORD_REG    = "^(?![^a-zA-Z]+$)(?!\\D+$).{6,20}$" //6-20位字母+数字
let MOBILE_REG      = "[1]\\d{10}$"
let EMAIL_REG       = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
let CHINESE_REG     = "(^[\\u4e00-\\u9fa5]+$)"
let VALID_REG     = "[\\u4E00-\\u9FA5A-Za-z0-9_]+$"

extension String {
    func index(at: Int) -> Index {
        return self.index(startIndex, offsetBy: at)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(at: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(at: to)
        return substring(to: toIndex)
    }
    
    func substring(with r:Range<Int>) -> String {
        let startIndex  = index(at: r.lowerBound)
        let endIndex    = index(at: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension String {
    func zx_matchs(regularString mstr:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@",mstr)
        return predicate.evaluate(with:self)
    }
    
    func zx_passwordValid() -> Bool {
        return zx_matchs(regularString: PASSWORD_REG)
    }
    
    func zx_mobileValid() -> Bool {
        return zx_matchs(regularString: MOBILE_REG)
    }
    
    func zx_emailValid() -> Bool {
        return zx_matchs(regularString: EMAIL_REG)
    }
    
    func zx_isChinese() -> Bool {
        return zx_matchs(regularString: CHINESE_REG)
    }
    
    func zx_inValidText() -> Bool {
        return !zx_matchs(regularString: VALID_REG)
    }
    
    func zx_textRectSize(toFont font:UIFont,limiteSize:CGSize) -> CGSize {
        let size = (self as NSString).boundingRect(with: limiteSize, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue|NSStringDrawingOptions.truncatesLastVisibleLine.rawValue), attributes: [NSFontAttributeName:font], context: nil).size
        return size
    }
    
    func zx_noticeName() -> NSNotification.Name {
        return NSNotification.Name.init(self)
    }
    
    func zx_telSecury() -> String {
        if self.zx_mobileValid() {
            let head = self.substring(with: 0..<3)
            let tail = self.substring(with: (self.characters.count - 4)..<self.characters.count)
            return "\(head)****\(tail)"
        } else {
            return self
        }
    }
    
    func zx_priceFormat(_ fontName:String,size:CGFloat,bigSize:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var price = self.zx_priceString()
        let aRange = NSMakeRange(0, price.characters.count)//¥ + 小数部分
        var pRange = NSMakeRange(1, price.characters.count)//整数部分
        
        let location = (price as NSString).range(of: ".")
        if  location.length > 0 {
            pRange = NSMakeRange(1, location.location)//整数部分
        }
        
        let formatPrice = NSAttributedString.zx_colorFormat(price, color: color, at: aRange)
        
        formatPrice.zx_appendFont(font: UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size), at: aRange)
        formatPrice.zx_appendFont(font: UIFont(name: fontName, size: bigSize) ?? UIFont.systemFont(ofSize: bigSize), at: pRange)
        
        return formatPrice
    }
    
    func zx_priceFormat(color:UIColor?) -> NSMutableAttributedString {
        return self.zx_priceFormat(UIFont.zx_titleFontName, size: UIFont.zx_titleFontSize, bigSize: UIFont.zx_titleFontSize, color: color ?? UIColor.zx_customAColor)
    }
    
    func zx_priceString(_ unit:Bool = true) -> String {
        var price = self
        if price.characters.count <= 0 {
            price = "0"
        }
        let location = (price as NSString).range(of: ".")
        if  location.length <= 0 {
            price += ".00"
        } else if (price.characters.count - 1 - location.location) < 2 {
            price += "0"
        }
        price = price.replacingOccurrences(of: "(?<=\\d)(?=(\\d\\d\\d)+(?!\\d))", with: ",", options: .regularExpression, range: price.startIndex..<price.endIndex)
        if unit {
            if !price.hasPrefix("¥") {
                return "¥\(price)"
            }
        } else {
            if price.hasPrefix("¥") {
                return price.substring(from: 1)
            }
        }
        
        return price
    }
}

extension NSNumber {
    func zx_priceString(_ unit:Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        var str = formatter.string(from: self) ?? "0.00"
        str = str.replacingOccurrences(of: "^[^\\d]*", with: unit ? "¥" : "", options: .regularExpression, range: str.startIndex..<str.endIndex)
        return str
    }
}
