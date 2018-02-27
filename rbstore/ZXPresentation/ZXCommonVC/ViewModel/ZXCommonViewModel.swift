//
//  ZXCommonViewModel.swift
//  rbstore
//
//  Created by screson on 2017/8/18.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

//数据字典
enum ZXCommonDicListType: Int {
    case unknown            =   0
    case ageList            =   1   //年龄段
    case freight            =   2   //运费说明
    case invoiceType        =   3   //发票类型
    case invoiceTitle       =   4   //抬头类型
    case invoiceContent     =   5   //发票内容
    case invoiceInfomation  =   6   //发票须知
    case isOpenInvoice      =   7   //是否开具发票
    case seviceTel          =   8   //咨询电话
}

/// 通用类型配置
class ZXCTypeModel: NSObject {
    var id:String = ""
    var type:Int = 0
    var typeLabel:String = ""
    var key:String = ""
    var value:String = ""
    var remark:String = ""
    
    var zx_type:ZXCommonDicListType {
        get {
            if let t = ZXCommonDicListType.init(rawValue: self.type) {
                return t
            }
            return .unknown
        }
    }
}

class ZXCommonViewModel: NSObject {
    static func commonDicList(with type:ZXCommonDicListType,completion:((_ cModel:ZXCTypeModel?) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Common.dicList), params: ["type":type.rawValue], method: .post) { (s, c, obj, js, error) in
            if c == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Array<Dictionary<String,Any>>,data.count > 0 {
                    completion?(ZXCTypeModel.mj_object(withKeyValues: data.first!))
                } else {
                    completion?(nil)
                }
            } else {
                completion?(nil)
            }
        }
    }
}
