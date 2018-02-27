//
//  ZXShortCategoryModel.swift
//  rbstore
//
//  Created by screson on 2017/8/8.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXShortCategoryModel: ZXShowModel {
    var targetType: Int = 0
    var targetId: String = ""
    var title: String = ""
    var mainUrlStr: String = ""
    
    override var showTitle: String {
        set {
            
        }
        get {
            return self.title
        }
    }
    
    override var showId: String {
        set {}
        get {
            return self.targetId
        }
    }
    
    override var zx_linkType: ZXLinkType {
        get {
            if self.targetType == 1 {
                return ZXLinkType.category
            } else if self.targetType == 2 {
                return ZXLinkType.floorGoodsList
            }
            return ZXLinkType.none
        }
    }
}
