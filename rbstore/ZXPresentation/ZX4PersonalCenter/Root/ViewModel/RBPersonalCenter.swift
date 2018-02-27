//
//  RBPersonalCenter.swift
//  rbstore
//
//  Created by 120v on 2017/8/1.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

typealias RBPersonalComplete = (Bool,RBConerMarkModel) -> Void

class RBPersonalCenter: NSObject {
    
    /**
     @pragma mark 每次启动获取一次区域数据
     @param
     */
    class func requestForGetArea(completion:@escaping (NSMutableArray) -> Void) -> Void {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.getAreaList), params: nil, method: .post) { (success, status, content, string, error) in
            var addrModelArray:NSMutableArray = NSMutableArray.init()
            if success {
                if status == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Array<Any> {
                        addrModelArray = ZXProvinceModel.mj_objectArray(withKeyValuesArray: data).mutableCopy() as! NSMutableArray
                        //保存
                        ZXAddressCache.addressModelArray = addrModelArray
                    }
                }
            }
            completion(addrModelArray)
        }
    }
    
    /*
     @pragma mark 角标
     @param
     */
    class func requestForConerMark(completion:@escaping RBPersonalComplete) -> Void {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.userConerMark), params: nil, method: .post) { (success, status, content, string, error) in
            var conerMarkModel = RBConerMarkModel.init()
            if success {
                if status == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        conerMarkModel = RBConerMarkModel.mj_object(withKeyValues: data)
                    }
                }
            }
            completion(success,conerMarkModel)
        }
    }
}
