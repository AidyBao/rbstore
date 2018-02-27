//
//  ZXAddressCache.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/6/9.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let RB_CACHE_USERS_ADDRESS     =   "RBCacheUserAddress"
var addArray: NSMutableArray   = []

class ZXAddressCache: NSObject {
    
    //FIXME: 表示此处有bug 或者要优化 列如下
    static var userId:String {
        get {
            return "ZXAddress"
        }
    }
    
    static var addressModelArray:NSMutableArray? {
        get {
            if addArray.count == 0 {
                let userDefaults = UserDefaults.standard
                if let cacheList = userDefaults.object(forKey: RB_CACHE_USERS_ADDRESS) as? Dictionary<String,Any> {
                    addArray = ZXProvinceModel.mj_objectArray(withKeyValuesArray: cacheList[self.userId])
                    return addArray
                }
            }
            return addArray
        }
        set {
            if let newValue = newValue {
                var dicStoreList:Dictionary<String,Any> = [:]
                let userDefaults = UserDefaults.standard
                if let cacheList = userDefaults.object(forKey: RB_CACHE_USERS_ADDRESS) as? Dictionary<String,Any> {
                    dicStoreList = cacheList
                }
                let array:NSMutableArray = ZXProvinceModel.mj_keyValuesArray(withObjectArray: newValue as! [Any])!
                dicStoreList[self.userId] = array
                userDefaults.set(dicStoreList, forKey: RB_CACHE_USERS_ADDRESS)
                userDefaults.synchronize()
            }else{
                let userDefaults = UserDefaults.standard
                if var cacheList = userDefaults.object(forKey: RB_CACHE_USERS_ADDRESS) as? Dictionary<String,Any> {
                    cacheList.removeValue(forKey: self.userId)
                    userDefaults.set(cacheList, forKey: RB_CACHE_USERS_ADDRESS)
                }else{
                    userDefaults.removeObject(forKey: RB_CACHE_USERS_ADDRESS)
                }
                userDefaults.synchronize()
            }
        }
    }
}
