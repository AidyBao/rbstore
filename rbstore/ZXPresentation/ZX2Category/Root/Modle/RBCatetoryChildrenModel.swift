//
//  RBCatetoryChildrenModel.swift
//  rbstore
//
//  Created by 120v on 2017/8/2.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBCatetoryChildrenModel: NSObject {
    
    var catetoryId: Int             = 0
    var parentId: Int               = 0
    var parentIdStr: String         = ""
    var name: String                = ""
    var fileUrl: String             = ""
    var status: Int                 = 0
    var remark: Int                 = 0
    var operatorId: Int             = 0
    var operatorName: String        = ""
    var operationTime: Int          = 0
    var operationTimeStr: String    = ""
    var fileUrlStr: String          = ""
    var children: NSMutableArray    = []
    
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["catetoryId":"id"]
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["children":RBCatetorySubModel.classForCoder()]
    }

}
