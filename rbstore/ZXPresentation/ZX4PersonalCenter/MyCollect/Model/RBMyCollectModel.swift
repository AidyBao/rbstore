//
//  RBMyCollectModel.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMyCollectModel: NSObject {
    var collectId:Int           = 0
    var memberId:Int            = 0
    var productId:Int           = 0
    var specProductId:Int       = 0
    var favoriteDatetime:Int    = 0
    var status:Int              = 0
    var salePrice:Float         = 0
    var stock:Int               = 0
    var skuCode:String          = ""
    var title:String            = ""
    var mainUrl:String          = ""
    var specValues:String       = ""
    var mainUrlStr:String       = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["collectId":"id"]
    }

}
