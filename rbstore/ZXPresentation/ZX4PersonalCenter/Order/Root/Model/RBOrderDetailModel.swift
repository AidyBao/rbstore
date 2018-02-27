//
//  RBOrderDetailModel.swift
//  rbstore
//
//  Created by 120v on 2017/8/4.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBOrderDetailModel: NSObject {
    
    var detailId: Int = 0
    var orderId: Int = 0
    var specProductId: Int = 0
    var productId: Int = 0
    var productName: String = ""
    var specNames: String = ""
    var mainUrl: String = ""
    var price: Float = 0
    var num: Int = 0
    var orderDate: Int32 = 0
    var orderDateStr: String = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["detailId":"id"]
    }
}
