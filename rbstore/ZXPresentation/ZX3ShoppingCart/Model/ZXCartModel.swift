//
//  ZXCartModel.swift
//  rbstore
//
//  Created by screson on 2017/8/15.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum ZXCartStatus:Int {
    case invalid = 0    //已失效
    case soldOut = 1    //无货
    case offShelves = 2 //下架
    case inSale = 3     //销售中
}

class ZXCartModel: ZXShowModel {
    var id:String = ""
    var specProductId:String =  ""
    var productId:String =  ""
    var num:Int =  0
    var isChosen:Int =  0
    var title:String =  ""
    var subtitle:String =  ""
    var salePrice:Double =  0
    var stock:Int =  0
    var specOptionIds:String =  ""          //5
    var specOptionValues:String =  ""       //黑色
    var status:Int =  0
    var mainUrlStr:String =  ""
    
    var zx_isChosen:Bool {
        get {
            if isChosen == 1 {
                return true
            }
            return false
        }
    }
    //编辑状态选中不调用接口
    var _editCheck:Bool?
    var zx_editChecked:Bool {
        set {
            _editCheck = newValue
        }
        get {
            if let e = _editCheck {
                return e
            }
            return self.zx_isChosen
        }
    }
    
    func clearEditCheckStatus() {
        self._editCheck = nil
    }
    
    var zx_status: ZXCartStatus {
        get {
            if let s = ZXCartStatus.init(rawValue: self.status) {
                return s
            }
            return .invalid
        }
    }
}
