//
//  RBAddressModel.swift
//  rbstore
//
//  Created by 120v on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBAddressModel: NSObject {
    var addrId:Int = -1
    var memberId:Int = -1
    var consignee:String = ""
    var tel:String = ""
    var cityAddress:String = ""
    var code:String = ""
    var address:String = ""
    var isDefault:Int = 0
    var status:Int = -1
    var remark:String = ""
    var operatorId:String = ""
    var operatorName:String = ""
    var operationTime:String = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["addrId":"id"]
    }
    
    var zx_description:String {
        get {
            return cityAddress + address
        }
    }
}
