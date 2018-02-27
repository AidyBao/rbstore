//
//  RBCateoryCenter.swift
//  rbstore
//
//  Created by 120v on 2017/8/9.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let Category_SelectedIndex = "Category_SelectedIndex"

class RBCateoryCenter: NSObject {
    
    /*
     @pragma mark 消息角标
     @param
     */
    class func requestForGetPushNum(completion:@escaping (Int) -> Void) -> Void {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Category.getPushNum), params: nil, method: .post) { (success, status, content, string, error) in
            if success {
                var pushNum: Int = 0
                if let num = content["pushNum"] as? Int,num > 0 {
                    pushNum = num
                }
                completion(pushNum)
            }
        }
    }
    
    /*
     @pragma mark 保存默认选择项
     @param
     */
    class func saveCategory(selectedIndex index: NSInteger) {
        UserDefaults.standard.set(index, forKey: Category_SelectedIndex)
        UserDefaults.standard.synchronize()
    }
    
    /*
     @pragma mark 重设分类默认选择项
     @param
     */
    class func getLastCategorySelectedIndex() -> NSInteger {
        var selectedIndex: NSInteger = 0
        if UserDefaults.standard.object(forKey: Category_SelectedIndex) != nil {
            selectedIndex = UserDefaults.standard.object(forKey: Category_SelectedIndex) as! NSInteger
        }
        return selectedIndex
    }
    /*
     @pragma mark 重设分类默认选择项
     @param
     */
    class func resetCategorySelectedIndex() {
        if UserDefaults.standard.object(forKey: Category_SelectedIndex) != nil {
            UserDefaults.standard.removeObject(forKey: Category_SelectedIndex)
        }
    }


}
