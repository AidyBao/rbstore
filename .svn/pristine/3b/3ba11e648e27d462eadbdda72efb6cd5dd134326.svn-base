//
//  ZXActiveModel.swift
//  rbstore
//
//  Created by screson on 2017/8/8.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXActivityModel: ZXShowModel {
    var activeId: String = ""
    var title: String = ""
    var headUrlStr: String = ""
    var activeDetailList = [ZXGoodsModel]()
    
    var zx_title:String {//限制20个字
        get {
            if title.characters.count > 20 {
                return title.substring(to: 20) + "..."
            }
            return title
        }
    }
    
    override var showId: String {
        set{}
        get{ return self.activeId }
    }
    
    override var showTitle: String {
        set{}
        get{ return self.title }
    }
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["activeId":"id"]
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["activeDetailList": ZXGoodsModel.self]
    }
}
