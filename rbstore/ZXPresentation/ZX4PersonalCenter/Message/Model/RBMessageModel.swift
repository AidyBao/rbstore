//
//  RBMessageModel.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMessageModel: NSObject {
    
    var messageId: Int          = 0
    var pushId: Int             = 0
    var promotionId:Int         = 0
    var title:String            = ""
    var isRead:Int              = 0
    var remark:String           = ""
    var sendDate:Int            = 0
    var sendDateStr:String      = ""
    var content:String          = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["messageId":"id"]
    }
}
