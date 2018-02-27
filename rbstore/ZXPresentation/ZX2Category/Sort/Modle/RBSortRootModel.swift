//
//  RBSortRootModel.swift
//  rbstore
//
//  Created by 120v on 2017/7/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBSortRootModel: NSObject {
    var isSelected: Bool                = false
    var attrListId: Int                 = 0 //属性集合Id
    var name: String                    = ""
    var inputType: String               = ""
    var fieldOptionList: NSMutableArray = []
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["attrListId":"id"]
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["fieldOptionList":RBSortChrildModel.classForCoder()]
    }
}
