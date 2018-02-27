//
//  RBHistoryCache.swift
//  rbstore
//
//  Created by 120v on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let RB_Cache_UserHistory     =   "RBCacheUserHistroy"
let RB_HistoryKey            =   "RBHistoryKey"

class RBHistoryCache: NSObject {
   
    class func getCache() -> Array<String> {
        let userDefaults = UserDefaults.standard
        
        if let cacheList = userDefaults.object(forKey: RB_Cache_UserHistory) as? Dictionary<String,Any> {
            if ((cacheList[RB_HistoryKey] as? Array<String>) != nil) {
                return cacheList[RB_HistoryKey] as! Array
            }
        }
        return Array.init()
    }
    
    class func saveCache(_ historyArray: Array<String>) -> () {
        var dicStoreList:Dictionary<String,Any> = [:]
        let userDefaults = UserDefaults.standard
        dicStoreList[RB_HistoryKey] = historyArray
        userDefaults.set(dicStoreList, forKey: RB_Cache_UserHistory)
        userDefaults.synchronize()
    }
    
    class func removeAllObjects() {
        let userDefaults = UserDefaults.standard
        if var cacheList = userDefaults.object(forKey: RB_Cache_UserHistory) as? Dictionary<String,Any> {
            cacheList.removeValue(forKey: RB_HistoryKey)
            userDefaults.removeObject(forKey: RB_Cache_UserHistory)
        }
    }
}


