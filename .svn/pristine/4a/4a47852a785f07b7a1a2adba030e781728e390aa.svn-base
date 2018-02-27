//
//  RBHotSearchCache.swift
//  rbstore
//
//  Created by 120v on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let RB_Cache_UserHotSearch     =   "RBCacheUserHotSearch"
let RB_HotSearchKey            =   "RBHotSearchKey"

class RBHotSearchCache: NSObject {
    
    class func getCache() -> Array<Any> {
        let userDefaults = UserDefaults.standard
        
        if let cacheList = userDefaults.object(forKey: RB_Cache_UserHotSearch) as? Dictionary<String,Any> {
            if ((cacheList[RB_HotSearchKey] as? Array<Any>) != nil) {
                return cacheList[RB_HotSearchKey] as! Array
            }
        }
        return Array.init()
    }
    
    class func saveCache(_ hotArray: NSMutableArray) -> () {
        var dicStoreList:Dictionary<String,Any> = [:]
        let userDefaults = UserDefaults.standard
        dicStoreList[RB_HotSearchKey] = hotArray
        userDefaults.set(dicStoreList, forKey: RB_Cache_UserHotSearch)
        userDefaults.synchronize()
    }
}
